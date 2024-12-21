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
    archive <- tools::CRAN_archive_db()
    current <- tools::CRAN_current_db()
    archive_df <- do.call("rbind", archive)
    all_packages <- rbind(archive_df, current)

    archives <- vapply(archive, nrow, numeric(1))
    pkg <- rep(names(archive), times = archives)
    pkges <- c(pkg, gsub("_.*", "", rownames(current)))
    all_packages$package <- pkges
    version <- lapply(archive, function(x) {
        gsub(x = rownames(x), pattern = ".+_(.*)\\.tar\\.gz$",
        replacement = "\\1")})
    version <- unlist(version, FALSE, FALSE)
    versions <- c(version, gsub(".+_(.*)\\.tar\\.gz$", "\\1", rownames(current)))

    all_packages$version <- versions
    all_packages$status <- "archived"
    all_packages$status[match(rownames(current), rownames(all_packages))] <- "current"

    # Arrange dates and data
    all_packages$mtime <- lubridate::with_tz(all_packages$mtime, tzone = "UTC")
    all_packages$ctime <- lubridate::with_tz(all_packages$ctime, tzone = "UTC")
    keep_columns <- c("package", "mtime", "ctime", "atime", "version", "uname", "size", "status")
    all_packages <- sort_by(all_packages[, keep_columns, drop = NA], ~package + mtime)
    colnames(all_packages)[6] <- "cran_team"
    rownames(all_packages) <- NULL

    pkg_state[["cran_archive"]] <- all_packages
    all_packages
}


#' CRAN comments
#'
#' CRAN volunteers document since ~2009 why they archive packages.
#' This function retrieves the data and prepares it for its usage.
#'
#' The comments are slightly edited: multiple comments for the same action that
#' they took are joined together.
#' Actions are inferred from keywords.
#' @returns A data.frame with four columns: package, comment, date and action.
#' @references Original file: <https://cran.r-project.org/src/contrib/PACKAGES.in>
#' @export
#' @examples
#' \donttest{
#' cc <- cran_comments()
#' head(cc)
#' }
cran_comments <- function() {
    url <- "https://cran.r-project.org/src/contrib/PACKAGES.in"
    file <- as.data.frame(read.dcf(url(url)))
    comments_df <- extract_field(file, field = "X-CRAN-Comment")

    history_df <- extract_field(file, field = "X-CRAN-History")
    full_history <- rbind(comments_df, history_df)
    fh <- sort_by(full_history, ~package + date)
    rownames(fh) <- NULL

    pkg_state[["cran_comments"]] <- fh
    fh
}



merge_comments <- function(df, column) {
    # Find which are empty
    rows_no_column <- which(is.na(df[[column]]))
    rows_affected <- sort(unique(c(rows_no_column - 1, rows_no_column)),
                          decreasing = FALSE)

    # Find extension of the comment
    starts <- setdiff(rows_affected, rows_no_column)
    ends <- rows_no_column[(rows_no_column - 1)[-1] != rows_no_column[-length(rows_no_column)]]
    stopifnot(length(starts) == length(ends))

    # Do not merge comments that involve different packages
    diff_pkg <- which(df$package[starts] != df$package[ends])

    rows_same_pkg <- mapply(seq, from = starts[-diff_pkg],
                            to = ends[-diff_pkg])
    comments_same_pkg <- vapply(rows_same_pkg,
                                function(seq, text) {
                                    paste(text[seq], collapse = "; ")},
                                text = df$comment, FUN.VALUE = character(1L))
    df[starts[-diff_pkg], "comment"] <- comments_same_pkg

    # Do not remove those rows that weren't merged
    rows_diff_pkg <- mapply(seq, from = starts[diff_pkg],
                 to = ends[diff_pkg])
    df <- df[-setdiff(rows_no_column, unlist(rows_diff_pkg, FALSE, FALSE)), ]
    rownames(df) <- NULL
    df
}


extract_field <- function(file,
                          field,
                          regex_date = "([0-9]{4}-[0-9]{2}-[0-9]{2})",
                          regex_action = "^([Uu]narchived?|[Aa]rchived?|[Rr]enamed?|[Oo]rphaned?|[Rr]eplaced?|[Rr]emoved?)"
) {
    file[[field]] <- gsub("\\.\n,?\n", ": ", file[[field]])
    # Extract multiline comments

    comments_l <- lapply(strsplit(file[[field]], "[\n]+"),
                         function(x) {trimws(unlist(x, FALSE, FALSE))})
    comments_c <- unlist(comments_l, FALSE, FALSE)
    df <- data.frame(package = rep(file$Package, lengths(comments_l)),
                     comment = comments_c)
    comments_df <- cbind(df,
                         strcapture(pattern = regex_date, x = df$comment,
                                    proto = data.frame(date = Sys.Date()[0])),
                         strcapture(pattern = regex_action, x = df$comment,
                                    proto = data.frame(action = character()))
    )
    comments_df <- comments_df[!is.na(comments_df$comment), ]
    rownames(comments_df) <- NULL
    comments_df$action <- tolower(comments_df$action)

    # Fix some corner cases
    comments_df$action[grep("Back on CRAN", comments_df$comment, ignore.case = TRUE)] <- "unarchived"
    starts_date_wo_action <- grep(paste0("^", regex_date), comments_df$comment)
    comments_df$action[starts_date_wo_action] <- "archived"

    # Merge multiple comments of the same action to the same string
    merge_comments(comments_df, "action")
}


cran_comments_pkg <- function(package) {
    cc <- get_cran_comments()
    cc_pkg <- cc[cc$package == package, ]
    rownames(cc_pkg) <- NULL
    cc_pkg
}
