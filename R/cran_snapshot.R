#' Check CRAN package state
#'
#' Given the available information which packages were on CRAN on a given date?
#' @note Due to missing of CRAN comments some packages are not annotated when
#' were they archived and more packages will be returned for any given date.
#' @param date The date you want to check.
#'
#' @returns The data.frame with the packages and versions at a given date.
#' @export
#'
#' @examples
#' cran_snapshot(Sys.Date() -2 )
cran_snapshot <- function(date) {

    stopifnot("Provide a date" = is(date, "Date"),
              "Accepted ranges is from the beginning of CRAN to today" = date <= Sys.Date() || date >= as.Date("1997-10-08"))
    ca <- save_state("cran_archive", cran_archive())
    if (date == Sys.Date()) {
        return(ca[ca$status == "current", ])
    }

    ca <- sort_by(ca, ~package + published_date)
    ca_before <- ca[as.Date(ca$published_date) <= date, , drop = TRUE]

    # Remove duplicated packages from the last to keep the latest version
    dups <- duplicated(ca_before$package, fromLast = TRUE)
    ca_before_date <- ca_before[!dups, c("package", "version", "published_date", "status")]

    cc <- save_state("cran_comments", cran_comments())

    # If date is earlier than any comments return what it was.
    if (date < min(cc$date, na.rm = TRUE)) {
        return(ca_before_date)
    }

    cc_archive <- cc[cc$action %in% c("archived", "removed") & cc$date <= date, ]
    cc_archive <- sort_by(cc_archive, ~package + date)
    dups <- duplicated(cc_archive$package, fromLast = TRUE)
    last_archival <- cc_archive[!dups & !is.na(cc_archive$package), ]

    missing <- setdiff(last_archival$package, ca_before_date$package)
    archived <- match(last_archival$package, ca_before_date$package, incomparables = missing)
    missing2 <- setdiff(ca_before_date$package, last_archival$package)
    archived2 <- match(ca_before_date$package, last_archival$package, incomparables = missing2)

    on_cran <- rep(TRUE, length.out = nrow(ca_before_date))
    names(on_cran) <- ca_before_date$package
    on_cran[na.omit(archived)] <- as.Date(ca_before_date$published_date[na.omit(archived)]) > last_archival$date[!is.na(archived)]
    cran_status <- ca_before_date[on_cran, ]

}


#' Estimate CRAN's date
#'
#' Check which CRAN dates are possible for a given packages and versions.
#' @param versions A data.frame with the packages names and versions
#' @param session Session information.
#'
#' @returns Last installation date from CRAN.
#' @export
#' @rdname cran_date
#' @examples
#' ip <- installed.packages()
#' cran_date(ip)
cran_date <- function(versions) {
    if ((!is.data.frame(versions) | !is.matrix(versions)) & !all(c("Package", "Version") %in% colnames(versions))) {
        stop("Versions should be a data.frame with 'Package' and 'Version' columns.")
    }


    ca_packages <- cran_pkges_archive(versions[, "Package"])
    ca <- save_state("cran_archive", cran_archive())
    # match packages names and versions
    ca_packages <- ca[ca$package %in% versions[, "Package"], ]
    ca_v <- apply(ca_packages[, c("package", "version")], 1, paste, collapse = "_")
    v_v <- apply(versions[, c("Package", "Version")], 1, paste, collapse = "_")
    m <- match(v_v, ca_v)

    # Find range of dates where was last updated.
    as.Date(max(ca_packages$published_date[na.omit(m)], na.rm = TRUE))
}

#' @rdname cran_date
#' @export
#' @examples
#' cran_session()
cran_session <- function(session = sessionInfo()) {
    if (is(session, "session_info")) {
        versions <- session$packages
        colnames(versions)[1:2] <- c("Package", "Version")
    } else {
        loaded <- lapply(session$loadedOnly, desc2version)
        other <- lapply(session$otherPkgs, desc2version)
        versions <- do.call(rbind, c(loaded, other))
    }
    cran_date(versions)
}


desc2version <- function(x){list2DF(x)[, c("Package", "Version")]}


