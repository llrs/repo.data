#' Retrieve CRAN archive
#'
#' Retrieve the archive and the current database.
#'
#' Some packages would get an NA in Version, if [package_version()] were to be
#' used with `strict = FALSE`.
#' Packages might have been on CRAN but could have been removed and won't show up.
#' Depending on the data requested and packages currently on CRAN, you might get
#' a warning regarding a package being both archived and current.
#' @inheritParams base_alias
#' @returns A data.frame with 6 columns: Package, Date (of publication), Version,
#'  User, size and status (archived or current).
#'  It is sorted by package name and date.
#' @export
#' @seealso The raw source of the data is: \code{\link[tools:CRAN_archive_db]{CRAN_archive_db()}},
#' \code{\link[tools:CRAN_current_db]{CRAN_current_db()}}.
#'  For some dates and comments about archiving packages: [cran_comments()].
#' @examples
#' \donttest{
#' ca <- cran_archive("A3")
#' head(ca)
#' }
cran_archive <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    current <- save_state("current", tools::CRAN_current_db(), FALSE)
    archive <- save_state("archive", tools::CRAN_archive_db(), FALSE)

    env <- "full_cran_archive"
    arch_names <- names(archive)
    curr_names <- gsub("_.+", "", rownames(current)) # Rownames without version
    # Check for random packages
    all_names <- unique(c(arch_names, curr_names))
    omit_pkg <- setdiff(packages, all_names)
    if (length(omit_pkg)) {
        warning("Omitting packages ", toString(omit_pkg),
                ".\nMaybe they were not on CRAN?", immediate. = TRUE)
    }
    # Keep only packages that can be processed
    packages <- setdiff(packages, omit_pkg)
    if (!is.null(packages) && !length(packages)) {
        return(NULL)
    }

    # Check if there is already data
    first_arch <- empty_env(env)
    if (first_arch) {
        arch <- curr2m(current)
    } else {
        arch <- pkg_state[[env]]
    }

    # Decide which packages are to be added to the data
    if (!is.null(packages) & !first_arch) {
        new_packages <- setdiff(packages, arch[, "package"])
    } else if (!is.null(packages) & first_arch) {
        new_packages <- intersect(packages, all_names)
    } else if (is.null(packages) & first_arch) {
        new_packages <- all_names
    } else if (is.null(packages) & !first_arch) {
        new_packages <- setdiff(all_names, arch[, "package"])
    }

    # Add new package's data
    if (length(new_packages)) {
        new_arch <- arch2m(archive[intersect(new_packages, arch_names)])
        arch <- rbind(arch, new_arch)
        # To be able to detect current and archived versions
        warnings_archive(arch)
        pkg_state[[env]] <- arch
    }

    if (is.null(packages)) {
        arch2df(arch)
    } else {
        arch2df(arch[arch[, "package"] %in% packages, , drop = FALSE])
    }
}


# Like CRAN archive but provides the published date and the date of archival if known
cran_archive_dates <- function() {
    ca <- save_state("full_cran_archive", cran_archive())
    dates <- split(ca$published_date, ca$package)
    l <- lapply(dates, function(x) {
        c(x[-length(x)] - 1L, NA)
    })
    ca$archived_date <- as.POSIXlt(funlist(l), tz = cran_tz)
    ca$archived_date[ca$status == "current"] <- as.POSIXlt(Sys.time(), tz = cran_tz)
    ca

    # TODO match package version with dates of archival or removal
    cc <- save_state("cran_comments", cran_comments())
    w <- which(cc$action %in% c("archived", "removed", "replaced", "renamed"))
    cc[w, ]
}


