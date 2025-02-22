#' Find earliest date of compatibility
#'
#' Search the DESCRIPTION file for the release dates of dependencies and return the earliest date.
#' This is the date at which the package could be installed.
#'
#' Currently this function assumes that packages only use ">=" and not other operators.
#' This might change on the future if other operators are more used.
#' @param dir Path to the package folder or name of the package published.
#' @inheritParams tools::package_dependencies
#'
#' @returns A vector with the datetimes of the published package (or current
#' time if not published) and the date the required restrictions are met.
#' @export
#' @examples
#' package_date("ABACUS")
package_date <- function(dir = ".", which = "all") {
    fields <- check_which(which)
    desc_pack <- file.path(dir, "DESCRIPTION")
    local_pkg <- file.exists(desc_pack)

    # Get package dependencies.
    if (local_pkg) {
        desc <- read.dcf(desc_pack, fields = c(package_fields, "Package"))
        deps <- desc[, intersect(fields, colnames(desc)), drop = FALSE]
        rownames(deps) <- desc[, "Package"]
        date_package <- Sys.Date()
        deps_df <- package_dependencies(deps)
    } else {
        rd <- repos_dependencies()
        deps_df <- rd[rd$package == dir, ]
    }

    if (!local_pkg && NROW(deps_df) == 0) {
        stop("Package couldn't be found on the current repositories or locally.")
    }

    if (!local_pkg) {
        p <- cran_pkges_archive(dir)
        date_package <- p$Datetime[nrow(p)]
    }

    # We don't need base packages
    base <- rownames(installed.packages(priority = "base"))
    deps_df <- deps_df[!deps_df$name %in% base, , drop = FALSE]
    which_r <- deps_df$name == "R"

    # Use cran_archive, to get the release dates of packages.
    archive <- cran_pkges_archive(deps_df$name[!which_r])
    missing_packages <- setdiff(deps_df$name[!which_r], archive$Package)

    # abn depends on INLA that is an Additional_repositories
    if (length(missing_packages)) {
        warning("Some package publication date could not be obtained.\n",
                "This might indicate packages outside CRAN.", call. = FALSE)
    }
    archive$Version <- package_version(archive$Version)

    # Get versions required or initial package release date
    ver_match <- merge(archive, deps_df[!which_r, , drop = FALSE], sort = FALSE,
          by.x = c("Package", "Version"), by.y = c("name", "version"))
    m_vm <- match(ver_match$Package, deps_df$name)
    deps_df$Datetime <- as.POSIXct(Sys.time(), tz = "Europe/Vienna")
    deps_df$Datetime[m_vm] <- ver_match$Datetime

    pkg_no_ver_match <- setdiff(deps_df$name[!which_r], ver_match$Package)
    ver_no_match <- archive[archive$Package %in% pkg_no_ver_match, , drop = FALSE]
    ver_no_match <- ver_no_match[!duplicated(ver_no_match$Package), , drop = FALSE]
    m_vnm <- match(ver_no_match$Package, deps_df$name)
    deps_df$Datetime[m_vnm] <- ver_no_match$Datetime

    if (requireNamespace("rversions", quietly = TRUE)) {
        rver <- rversions::r_versions()
        ver_position <- match(deps_df$version[which_r], package_version(rver$version))
        deps_df$Datetime[which_r] <- rver$date[ver_position]
    } else {
        deps_df <- deps_df[-which(which_r), , drop = FALSE]
        warning("To take into consideration R versions too please install package rversions")
    }

    # Get the latest date.
    c(Published = date_package, deps_available = max(deps_df$Datetime, na.rm = TRUE))
}
