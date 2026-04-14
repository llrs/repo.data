# Author: CRAN (Kurt Hornik)/R core
download_issues <- function(type) {
    type <- match.arg(type, c("full", "info", "open"))
    file <- paste0("CRAN_issue_", type, ".rds")
    src <- file.path(
        Sys.getenv("R_CRAN_PACKAGE_ISSUES_URL",
                   "rsync://CRAN.R-project.org/CRAN-issues"),
        file)
    if (startsWith(src, "file://")) {
        tryCatch(
            readRDS(substring(src, 8L)),
            error = function(e) {
                NA
            })
    } else {
        dst <- tempfile()
        tryCatch({
            system2("rsync", c(src, dst))
            readRDS(dst)
        },
        error = function(e) {
            NA
        })
    }
}

#' CRAN issues
#'
#' Reports the notifications sent to package maintainers
#' with the hour it was sent and the deadline used.
#'
#' @returns A data.frame  with 8 columns:
#' \describe{
#'   \item{ID}{Year.number: Id of the issue.}
#'   \item{Package}{Package name.}
#'   \item{Date}{POSIXct object when the issue was sent.}
#'   \item{From}{CRAN member that sent that notification.}
#'   \item{Before}{Date by which the issue should be fixed.}
#'   \item{Title}{Reason of the issue.}
#'   \item{Label}{Some classification of the issue.}
#'   \item{Info}{Unstructured text with some information.}
#' }
#' @export
#'
#' @examples
#' ci <- cran_issues()
#' if (!is.null(dim(ci))) {
#'     head(ci)
#' }
cran_issues <- function() {
    issues <- download_issues("full")
    if (is_not_data(issues)) {
        return(NA)
    }

    if (anyDuplicated(issues$ID)) {
        warning("Duplicated IDs")
    }

    # Fix names
    vpn <- valid_package_name(issues$Package)
    if (any(!vpn)) {
        warning("Invalid package names: ", toString(sQuote(issues$Package[!vpn])))
        # Use raw strings: ?Quotes
        gsub(r"{[:";]}", replacement = "", issues$Package[!vpn])
    }
    # Fix dates
    mk <- (!is.na(issues$Before) & is.na(as.Date(issues$Before)))
    if (any(!mk)) {
        warning("Correcting incorrect dates on Before")
        rg <- regexpr("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}", issues$Before[mk])
        issues$Before[mk] <- regmatches(issues$Before[mk], rg)
    }
    issues$Before <- as.Date(issues$Before)

    issues <- sort_by(issues, issues$Date)
    rownames(issues) <- NULL
    issues
}
