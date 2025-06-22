#' Find earliest date of compatibility
#'
#' Search the DESCRIPTION file for the release dates of dependencies and return the earliest date according to CRAN's archive.
#' This is the date at which the package could be installed.
#'
#' Currently this function assumes that packages only use ">=" and not other operators.
#' This might change on the future if other operators are more used.
#' @param pkg Path to the package folder or name of the package published.
#' @inheritParams tools::package_dependencies
#'
#' @returns A vector with the datetimes of the published package (or current
#' date if not published) and the datetime the required restrictions were met.
#' @export
#' @examples
#' package_date("ABACUS")
#' package_date("paramtest")
#' package_date("Seurat") # Dependencies on packages not on CRAN
#' package_date("afmToolkit") # Dependency was removed from CRAN
package_date <- function(pkg = ".", which = "strong") {
    fields <- check_which(which)
    local_pkg <- check_local(pkg)

    # Get package dependencies.
    deps_df <- NULL
    if (any(file.exists(local_pkg))) {
        desc <- read.dcf(local_pkg[file.exists(local_pkg)], fields = c(PACKAGE_FIELDS, "Package"))
        deps <- desc[, intersect(fields, colnames(desc)), drop = FALSE]
        rownames(deps) <- desc[, "Package"]
        date_package <- Sys.Date()
        deps_df <- packages_dependencies(deps)
    } 
    if (any(!file.exists(local_pkg))) {
        rd <- repos_dependencies(which = fields)
        deps_df <- rbind(deps_df, rd[rd$package %in% pkg, , drop = FALSE])
        p <- cran_archive(pkg)
        date_package <- p$Datetime[nrow(p)]
    }

    # We don't need base packages
    deps_df <- deps_df[!deps_df$name %in% BASE, , drop = FALSE]
    which_r <- deps_df$name == "R"

    if (sum(which_r) && !check_installed("rversions")) {
        warning("To take into consideration R versions too please install package rversions.")
    }
    r_versions <- sum(which_r) && check_installed("rversions")

    if (!file.exists(local_pkg) && length(local_pkg) == 1L && NROW(deps_df) == 0L || NROW(deps_df) == 1L && r_versions) {
        return(c(Published = date_package, deps_available = NA))
    } else if (!file.exists(local_pkg) && nrow(p) == 0L) {
        stop("Package ", sQuote(pkg), " wasn't found on past or current CRAN archive or locally.")
    }

    # Use cran_archive, to get the release dates of packages.
    archive <- cran_archive(deps_df$name[!which_r])
    missing_packages <- setdiff(deps_df$name[!which_r], archive$Package)

    # abn depends on INLA that is an Additional_repositories
    if (length(missing_packages)) {
        warning("Package publication date could not be obtained for: ",
                toString(missing_packages), ".\n",
                "This indicate packages outside CRAN repository.", call. = FALSE,
                immediate. = TRUE)
    }

    # Filter to those that were available at the time
    pkg_available <- archive[archive$Package %in% deps_df$name & archive$Datetime < date_package, , drop = FALSE]
    removed_from_archive <- setdiff(deps_df$name, c(pkg_available$Package, "R"))

    if (length(removed_from_archive)) {
        warning("Package's dependencies were archived from CRAN after package publication: ",
                toString(removed_from_archive),
                call. = FALSE, immediate. = FALSE)
    }

    # Get versions required or initial package release date
    ver_match <- merge(pkg_available, deps_df[!which_r, , drop = FALSE], sort = FALSE,
          by.x = c("Package", "Version"), by.y = c("name", "version"))
    m_vm <- match(ver_match$Package, deps_df$name)
    deps_df$Datetime <- as.POSIXct(NA, tz = cran_tz)
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


#' Package dates
#'
#' Same as package_date but using CRAN's actions instead of public archive.
#'
#' This provides information about when a package was removed or archived for a
#' more accurate estimation.
#' @param pkg Name of the package on CRAN.
#' It accepts also local path to packages source directories but then the
#' function works as if the package is not released yet.
#' @inheritParams tools::package_dependencies
#' @keywords internal
#' @examples
#' # package_date_actions("afmToolkit")
package_date_actions <- function(pkg = ".", which = "strong") {
    fields <- check_which(which)
    local_pkg <- check_local(pkg)

    # Get package dependencies.
    deps_df <- NULL
    if (any(file.exists(local_pkg))) {
        desc <- read.dcf(local_pkg[file.exists(local_pkg)], fields = c(PACKAGE_FIELDS, "Package"))
        deps <- desc[, intersect(fields, colnames(desc)), drop = FALSE]
        rownames(deps) <- desc[, "Package"]
        date_package <- Sys.Date()
        deps_df <- rbind(deps_df, packages_dependencies(deps))
    } 
    if (any(!file.exists(local_pkg))) {
        rd <- repos_dependencies(which = fields)
        deps_df <- rbind(deps_df, rd[rd$package == pkg, , drop = FALSE])
        p <- cran_archive(pkg)
        date_package <- p$Datetime[nrow(p)]
    }
    

    # We don't need base packages
    deps_df <- deps_df[!deps_df$name %in% BASE, , drop = FALSE]
    which_r <- deps_df$name == "R"

    if (sum(which_r) && !check_installed("rversions")) {
        warning("To take into consideration R versions too please install package rversions.",
                call. = FALSE)
    }
    r_versions <- sum(which_r) && check_installed("rversions")

    if (!local_pkg && NROW(deps_df) == 0L || NROW(deps_df) == 1L && r_versions) {
        return(c(Published = date_package, deps_available = NA))
    } else if (!local_pkg && nrow(p) == 0L) {
        stop("Package ", sQuote(pkg), " wasn't found on past or current CRAN archive or locally.",
             call.  = FALSE)
    }

    # Use cran_actions, to get the release dates of packages.
    actions <- cran_actions()
    actions$Package <- as.character(actions$Package)
    actions <- actions[actions$Package %in% deps_df$name[!which_r], , drop = FALSE]
    actions$Datetime <- datetime2POSIXct(actions$Date, actions$Time)
    missing_packages <- setdiff(deps_df$name[!which_r], as.character(actions$Package))

    # abn depends on INLA that is an Additional_repositories
    if (length(missing_packages)) {
        warning("Package publication date could not be obtained for: ",
                toString(missing_packages), ".\n",
                "This indicate packages outside CRAN repository.", call. = FALSE,
                immediate. = TRUE)
    }

    # Filter to those that were available at the time
    # browser()
    diff_time <- difftime(actions$Datetime, date_package)
    pkg_available <- actions[sign(diff_time) < 0, , drop = FALSE]
    not_on_actions <- setdiff(deps_df$name, c(pkg_available$Package, "R"))

    if (length(not_on_actions)) {
        warning("Package's not available on the version of actions used ",
                toString(sQuote(not_on_actions)),
                call. = FALSE, immediate. = FALSE)
    }

    # Get versions required or initial package release date
    pkg_available$Version <- as.character(pkg_available$Version)
    ver_match <- merge(pkg_available, deps_df[!which_r, , drop = FALSE], sort = FALSE,
                       by.x = c("Package", "Version"), by.y = c("name", "version"))
    m_vm <- match(ver_match$Package, deps_df$name)
    deps_df$Datetime <- as.POSIXct(NA, tz = cran_tz)
    if (length(m_vm)) {
        deps_df$Datetime[m_vm] <- ver_match$Datetime
    }

    # Add date to those not version specified
    pkg_no_ver_match <- deps_df$name[setdiff(seq_len(nrow(deps_df)), m_vm)]
    pkg_no_ver_match <- setdiff(pkg_no_ver_match, c(not_on_actions, "R"))
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
