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
#' ca <- cran_archive()
#' head(ca)
#' }
cran_archive <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    save_state("cran_archive", cran_pkges_archive(packages))
    out <- get_package_subset("cran_archive", packages)
    warnings_archive(out)
}

cran_pkges_archive <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    # Check if package is there
    if (!check_env("cran_archive")) {
        out <- get_package_subset("cran_archive", packages)
        if (check_subset(out, packages)) {
            warnings_archive(out)
            return(out)
        }
    }
    # Download data
    archive <- save_state("archive", tools::CRAN_archive_db(), FALSE)
    current <- save_state("current", tools::CRAN_current_db(), FALSE)

    archive_sb <- if (is.null(packages)) {
        archive
    } else {
        archive[packages[packages %in% names(archive)]]
    }

    # Convert to matrix for faster cbind
    keep_cols <- c("mtime", "size", "uname")
    archive_sbm <- lapply(archive_sb, function(pack) {
        as.matrix(pack[, keep_cols])
        })

    archive_m <- do.call(rbind, archive_sbm)
    all_packages <- rbind(archive_m, as.matrix(current[, keep_cols]))

    # Packages names
    archives <- vapply(archive_sb, nrow, numeric(1))
    pkg <- rep(names(archive_sb), times = archives)
    all_packages <- cbind(all_packages,
                          package = c(pkg, gsub("_.*", "", rownames(current))))

    # Return when everything is requested and it was already there.
    if (!is.null(packages)) {
        pkges <- intersect(packages, all_packages[, "package"])
    } else {
        pkges <- all_packages[, "package"]
    }

    if (!is.null(pkg_state[["cran_archive"]])) {
        return(get_package_subset("cran_archive", pkges))
    }

    # Packages versions
    version <- funlist(lapply(archive_sb, rownames))
    versions <- c(version, rownames(current))
    versions <- gsub(".+_(.*)\\.tar\\.gz$", "\\1", versions)

    # Subset to only the requested ones
    all_packages <- cbind(all_packages, version = versions, status = "archived")
    all_packages <- all_packages[all_packages[, "package"] %in% pkges, , drop = FALSE]
    # Convert back to data.frame
    all_packages <- as.data.frame(all_packages)
    all_packages$size <- as.numeric(all_packages$size)
    all_packages$mtime <- as.POSIXct(all_packages$mtime, tz = cran_tz)
    # Packages status
    all_packages$status[match(rownames(current), rownames(all_packages))] <- "current"


    # Arrange dates and data
    keep_columns <- c("package", "mtime", "version", "uname", "size", "status")
    all_packages <- sort_by(all_packages[, keep_columns, drop = FALSE], ~package + mtime)
    colnames(all_packages) <- c("Package", "Datetime", "Version", "User", "Size", "Status")
    rownames(all_packages) <- NULL

    # Save it is the complete list
    if (all(names(archive) %in% all_packages$package)) {
        save_state("cran_archive", all_packages)
    }
    if (!is.null(packages)) {
        warnings_archive(all_packages)
    }
    all_packages
}


# Like CRAN archive but provides the published date and the date of archival if known
cran_archive_dates <- function() {
    ca <- save_state("cran_archive", cran_archive())
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

warnings_archive <- function(all_packages) {
    # Rely on order of all_packages by date
    dup_arch <- duplicated(all_packages[, c("Package", "Version")])
    dups_arch <- sum(all_packages[, "Status"][dup_arch] == "current")
    if (dups_arch) {
        warning("There are ", dups_arch, " packages both archived and published\n",
                "This indicate manual CRAN intervention.",
                call. = FALSE, immediate. = TRUE)
    }
    all_packages
}
