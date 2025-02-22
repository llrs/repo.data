#' Retrieve CRAN archive
#'
#' Retrieve the archive and the current database.
#'
#' There are some packages with NA in version, those are version names that do
#' not pass current [package_version()] with `strict = TRUE`.
#' Other packages might have been on CRAN but could have been removed.
#' @returns A data.frame with 6 columns: Package, Date (of publication), Version,
#'  User, size and status (archived or current).
#'  It is sorted by package name and date
#' @export
#' @seealso [CRAN_archive_db()], [CRAN_current_db()], [cran_comments()].
#' @examples
#' \donttest{
#' ca <- cran_archive()
#' head(ca)
#' }
cran_archive <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    out <- save_state("cran_archive", cran_pkges_archive(NULL))
    warnings_archive(out)
    out
}


cran_pkges_archive <- function(packages) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())

    # Check if package is there
    if (!is.null(pkg_state[["cran_archive"]])) {
        out <- get_package_subset("cran_archive", packages)
        if (check_subset(out, packages)) {
            warnings_archive(out)
            return(out)
        }
    }
    # Download data
    archive <- save_state("archive", tools::CRAN_archive_db())
    current <- save_state("current", tools::CRAN_current_db())

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
    all_packages <- all_packages[all_packages[, "package"] %in% pkges, , drop = FALSE]
    # Convert back to data.frame
    all_packages <- as.data.frame(all_packages)
    all_packages$size <- as.numeric(all_packages$size)
    all_packages$mtime <- as.POSIXct(all_packages$mtime, tz = "Europe/Vienna")

    # Packages status
    all_packages <- cbind(all_packages, version = versions, status = "archived")
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
        c(x[-length(x)] - 1, NA)
    })
    ca$archived_date <- as.POSIXlt(funlist(l), tz = "Europe/Vienna")
    ca$archived_date[ca$status == "current"] <- as.POSIXlt(Sys.time(), tz = "Europe/Vienna")
    ca

    # TODO match package version with dates of archival or removal
    cc <- save_state("cran_comments", cran_comments())
    w <- which(cc$action %in% c("archived", "removed", "replaced", "renamed"))
    cc_packages <- cc[w, ]

    #
}

warnings_archive <- function(all_packages) {
    dup_arch <- duplicated(all_packages[, c("Package", "Version")])
    if (any(dup_arch)) {
        warning("There are ", sum(dup_arch), " packages both archived and published\n",
                "This indicate manual CRAN intervention.",
                call. = FALSE)
    }
}
