#' Retrieve CRAN archive
#'
#' Retrieve the archive and the current database.
#'
#' There are some packages with NA in version, those are version names that do
#' not pass current [package_version()] with `strict = TRUE`.
#' Other packages might have been on CRAN but could have been removed.
#' @returns A data.frame with 6 columns: package, archived_date, version,
#'  cran_team, size and status.
#'  It is sorted by package name and archived_date.
#' @export
#' @seealso [CRAN_archive_db()], [CRAN_current_db()], [cran_comments()].
#' @examples
#' \donttest{
#' ca <- cran_archive()
#' head(ca)
#' }
cran_archive <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    archive <- save_state("archive", tools::CRAN_archive_db())
    current <- save_state("current", tools::CRAN_current_db())
    archive_df <- do.call(rbind, archive)
    all_packages <- rbind(archive_df, current)

    # Packages names
    archives <- vapply(archive, nrow, numeric(1))
    pkg <- rep(names(archive), times = archives)
    pkges <- c(pkg, gsub("_.*", "", rownames(current)))
    all_packages$package <- pkges

    # Packages versions
    version <- unlist(lapply(archive, rownames), FALSE, FALSE)
    versions <- c(version, rownames(current))
    versions <- gsub(".+_(.*)\\.tar\\.gz$", "\\1", versions)

    # Packages status
    all_packages$version <- versions
    all_packages$status <- "archived"
    all_packages$status[match(rownames(current), rownames(all_packages))] <- "current"

    # Arrange dates and data
    all_packages$mtime <- as.POSIXct(all_packages$mtime, tz = "UTC")
    keep_columns <- c("package", "mtime", "version", "uname", "size", "status")
    all_packages <- sort_by(all_packages[, keep_columns, drop = NA], ~package + mtime)
    colnames(all_packages)[2] <- "published_date"
    colnames(all_packages)[4] <- "cran_team"
    rownames(all_packages) <- NULL

    pkg_state[["cran_archive"]] <- all_packages
    all_packages
}


cran_archive_dates <- function() {
    ca <- get_cran_archive()
    dates <- split(ca$published_date, ca$package)
    l <- lapply(dates, function(x) {
        c(x[-length(x)] - 1, NA)
    })
    ca$archived_date <- .POSIXct(funlist(l), tz = "UTC")
    ca$archived_date[ca$status == "current"] <- as.POSIXct(Sys.time(), tz = "UTC")
    ca

    # TODO match package version with dates of archival or removal
    cc <- get_cran_comments()
    w <- which(cc$action %in% c("archived", "removed", "replaced", "renamed"))
    cc_packages <- cc[w, ]

    #
}
