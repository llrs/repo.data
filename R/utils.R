save_state <- function(name, out) {
    if (is.null(pkg_state[[name]])) {
        message("Calculating ", name, ", this might take a bit.\n",
                "Next call will be faster.")
        pkg_state[[name]] <- out
    }
    pkg_state[[name]]
}

ls_state <- function() {
    sapply(pkg_state, is)
}

funlist <- function(x){unlist(x, FALSE, FALSE)}

get_package_subset <- function(name, pkges) {
    if (!is.null(pkg_state[[name]])) {
        df <- pkg_state[[name]]
        if ("package" %in% colnames(df)) {
            df[df$package %in% pkges, , drop = FALSE]
        } else {
            df[df$Package %in% pkges, , drop = FALSE]
        }
    } else {
        NULL
    }
}

check_subset <- function(obj, pkges) {
    if ("package" %in% colnames(obj)) {
        all(pkges %in% obj$package)
    } else {
        all(pkges %in% obj$Package)
    }
}

check_installed <- function(x) {
    requireNamespace(x, quietly = TRUE)
}

# tools:::CRAN_baseurl_for_src_area but with fixed mirror
CRAN_baseurl <- function() {
    Sys.getenv("R_CRAN_SRC", "https://CRAN.R-project.org")
}

# tools:::read_CRAN_object but for several types
read_CRAN <- function(cran, path) {
    con <- gzcon(url(sprintf("%s/%s", cran, path), open = "rb"))
    on.exit(close(con))
    if (endsWith(path, "rds") || endsWith(path, "RDS")) {
        readRDS(con)
    } else {
        read.dcf(con)
    }
}

check_r_version <- function() {
    ver <- paste0(R.Version()[c("major","minor")], collapse = ".")
    r_ver <- package_version(ver)
    target <- package_version("4.5.0")
    r_ver >= target
}


.cran_archive <- function() {
    if (check_r_version()) {
        return(tools::CRAN_archive_db())
    }
    read_CRAN(CRAN_baseurl(), "src/contrib/Meta/archive.rds")
}

datetime2POSIXct <- function(date, time, tz = "Europe/Vienna") {
    moment <- paste(date, time)
    moment[is.na(date)] <- NA
    moment <- as.POSIXct(moment, tz = tz)
    moment
}
