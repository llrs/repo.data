#' Find earliest date of compatibility
#'
#' Search the DESCRIPTION file for the release dates of dependencies and return the earliest date.
#' This is the date at which the package could be installed.
#'
#' Currently this function assumes that packages only use ">=" and not other operators.
#' This might change on the future if other operators are more used.
#' @param pkg Path to the package folder or name of the package published.
#' @inheritParams tools::package_dependencies
#'
#' @returns A vector with the datetimes of the published package (or current
#' time if not published) and the date the required restrictions are met.
#' @export
#' @examples
#' package_date("ABACUS")
#' package_date("paramtest")
#' package_date("afmToolkit") # Dependency was removed from CRAN
package_date <- function(pkg = ".", which = "strong") {
    fields <- check_which(which)
    desc_pack <- file.path(pkg, "DESCRIPTION")
    local_pkg <- file.exists(desc_pack)

    # Get package dependencies.
    if (local_pkg) {
        desc <- read.dcf(desc_pack, fields = c(package_fields, "Package"))
        deps <- desc[, intersect(fields, colnames(desc)), drop = FALSE]
        rownames(deps) <- desc[, "Package"]
        date_package <- Sys.Date()
        deps_df <- packages_dependencies(deps)
    } else {
        rd <- repos_dependencies(which = fields)
        deps_df <- rd[rd$package == pkg, , drop = FALSE]
        p <- cran_pkges_archive(pkg)
        date_package <- p$Datetime[nrow(p)]
    }

    # We don't need base packages
    deps_df <- deps_df[!deps_df$name %in% BASE, , drop = FALSE]
    which_r <- deps_df$name == "R"

    if (sum(which_r) && !requireNamespace("rversions", quietly = TRUE)) {
        warning("To take into consideration R versions too please install package rversions.")
    }
    r_versions <- sum(which_r) && requireNamespace("rversions", quietly = TRUE)

    if (!local_pkg && NROW(deps_df) == 0L || NROW(deps_df) == 1L && r_versions) {
        return(c(Published = date_package, deps_available = NA))
    } else if (!local_pkg & nrow(p) == 0L) {
        stop("Package ", sQuote(pkg), " wasn't found on past or current CRAN archive or locally.")
    }

    # Use cran_archive, to get the release dates of packages.
    archive <- cran_pkges_archive(deps_df$name[!which_r])
    missing_packages <- setdiff(deps_df$name[!which_r], archive$Package)

    # abn depends on INLA that is an Additional_repositories
    if (length(missing_packages)) {
        warning("Package publication date could not be obtained for: ",
                paste(missing_packages, collapse = ", "), ".\n",
                "This indicate packages outside CRAN repository.", call. = FALSE,
                immediate. = TRUE)
    }

    # Filter to those that were available at the time
    pkg_available <- archive[archive$Package %in% deps_df$name & archive$Datetime < date_package, , drop = FALSE]
    removed_from_archive <- setdiff(deps_df$name, c(pkg_available$Package, "R"))

    if (length(removed_from_archive)) {
        warning("Package's dependencies archive were removed from CRAN after package publication: ",
                paste(removed_from_archive, collapse = ", "),
                call. = FALSE, immediate. = FALSE)
    }

    # Get versions required or initial package release date
    ver_match <- merge(pkg_available, deps_df[!which_r, , drop = FALSE], sort = FALSE,
          by.x = c("Package", "Version"), by.y = c("name", "version"))
    m_vm <- match(ver_match$Package, deps_df$name)
    deps_df$Datetime <- as.POSIXct(NA, tz = "Europe/Vienna")
    if (length(m_vm)) {
        deps_df$Datetime[m_vm] <- ver_match$Datetime
    }

    # Add date to those not version specified
    pkg_no_ver_match <- deps_df$name[setdiff(seq_len(nrow(deps_df)), m_vm)]
    pkg_no_ver_match <- setdiff(pkg_no_ver_match, c(removed_from_archive, "R"))
    if (length(pkg_no_ver_match)) {
        ver_no_match <- pkg_available[pkg_available$Package %in% pkg_no_ver_match, , drop = FALSE]
        ver_no_match <- ver_no_match[!duplicated(ver_no_match$Package, fromLast = TRUE), ,
                                     drop = FALSE]
        m_vnm <- match(ver_no_match$Package, deps_df$name)
        deps_df$Datetime[m_vnm] <- ver_no_match$Datetime
    }

    # Find release date of R version
    if (r_versions) {
        rver <- rversions::r_versions()
        ver_position <- match(deps_df$version[which_r], package_version(rver$version))
        deps_df$Datetime[which_r] <- rver$date[ver_position]
    }

    # Get the latest date.
    c(Published = date_package, deps_available = max(deps_df$Datetime, na.rm = TRUE))
}
