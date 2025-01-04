#' Check CRAN package state
#'
#' @param date The date you want to check.
#'
#' @returns The data.frame with the packages and versions at a given date.
#' @export
#'
#' @examples
#' cran_snapshot(Sys.Date() -2 )
cran_snapshot <- function(date) {

    stopifnot(is(date, "Date") || date > Sys.Date())
    ac <- get_cran_archive()
    if (date == Sys.Date()) {
        return(ac[ac$status == "current", ])
    }

    ac <- sort_by(ac, ~package + archived_date)
    ac_before <- ac[ac$submitted_date <= date & ac$archived_date > date, , drop = TRUE]

    # Remove duplicated packages from the last to keep the latest version
    dups <- duplicated(ac_before$package, fromLast = TRUE)
    ac_before[!dups, c("package", "version", "submitted_date", "archived_date")]
}


cran_date <- function(versions) {
    if (is.data.frame(versions) && colnames(versions) %in% c("package", "version")) {

    }
    # match packages names
    # match versions
    # find range of dates.
}
