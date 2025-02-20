

#' CRAN comments
#'
#' CRAN volunteers document since ~2009 why they archive packages.
#' This function retrieves the data and prepares it for analysis, classifying
#' the actions taken by the team per package and date.
#'
#' The comments are slightly edited: multiple comments for the same action are
#' joined together so that they can be displayed on a single line.
#' Actions are inferred from 7 keywords: archived, orphaned, removed, renamed,
#'  replaced, unarchived, unorphaned.
#' @note There can be room for improvement: some comments describe two actions, please
#' let me know if you think this can be improved.
#' Other actions can be described on multiple comments/lines or out of order.
#' Compare with the original file in case of doubts.
#' @returns A data.frame with four columns: package, comment, date and action.
#' @references Original file: <https://cran.r-project.org/src/contrib/PACKAGES.in>
#' @export
#' @examples
#' \donttest{
#' cc <- cran_comments()
#' head(cc)
#' }
cran_comments <- function() {
    file <- save_state("comments", read_CRAN(CRAN_baseurl(),
                                             "/src/contrib/PACKAGES.in"))
    file <- as.data.frame(file)
    comments_df <- extract_field(file, field = "X-CRAN-Comment")
    history_df <- extract_field(file, field = "X-CRAN-History")
    full_history <- rbind(comments_df, history_df)

    # TODO: Merge comments split between history and comment fields
    fh <- sort_by(full_history, ~package + date)
    edit <- !endsWith(fh$action, "ed")
    fh$action[edit & !is.na(edit)] <- paste0(fh$action[edit & !is.na(edit)], "d")
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
                          regex_action = "^([Uu]narchived?|[Aa]rchived?|[Rr]enamed?|[Oo]rphaned?|[Rr]eplaced?|[Rr]emoved?|[Uu]norphaned?)"
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
    cc <- save_state("cran_comments", cran_comments())
    cc_pkg <- cc[cc$package == package, ]
    rownames(cc_pkg) <- NULL
    cc_pkg
}
