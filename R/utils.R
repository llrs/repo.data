get_cran_archive <- function() {
    if (is.null(pkg_state[["cran_archive"]])) {
        pkg_state[["cran_archive"]] <- cran_archive()
    }
    pkg_state[["cran_archive"]]
}

get_cran_comments <- function() {
    if (is.null(pkg_state[["cran_reasons"]])) {
        pkg_state[["cran_reasons"]] <- cran_comments()
    }
    pkg_state[["cran_reasons"]]
}

funlist <- function(x){unlist(x, FALSE, FALSE)}


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
