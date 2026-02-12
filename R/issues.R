# Author: CRAN
download_issues <- function(type) {
    type <- match.arg(type, c("full", "info", "open"))
    file <- paste0("CRAN_issue_", type, ".rds")
    src <- file.path(
        Sys.getenv("R_CRAN_PACKAGE_ACTIONS_URL",
                   "rsync://CRAN.R-project.org/CRAN-issues"),
        file)
    if (startsWith(src, "file://")) {
        readRDS(substring(src, 8L))
    } else {
        dst <- tempfile()
        system2("rsync", c(src, dst))
        readRDS(dst)
    }
}


cran_issues <- function() {
    issues <- download_issues()
    valid_package_name(issues$Package)
}
