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
    issues <- download_issues("full")

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
        warning("Incorrect dates on Before")
        rg <- regexpr("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}", issues$Before[mk])
        issues$Before[mk] <- regmatches(issues$Before[mk], rg)
    }

    ui <- unique(issues)

    # date <- as.Date(ui$Date)
    # before <- as.Date(ui$Before)
    # w <- which(before < date)
    ui

}
}
