save_state <- function(name, fun) {
    if (is.null(pkg_state[[name]])) {
        pkg_state[[name]] <- fun
    }
    pkg_state[[name]]
}

funlist <- function(x){unlist(x, FALSE, FALSE)}

get_package_subset <- function(name, pkges) {
    if (!is.null(pkg_state[[name]])) {
        df <- pkg_state[[name]]
        if ("package" %in% colnames(df)) {
            df[df$package == pkges, , drop = FALSE]
        } else {
            df[df$Package == pkges, , drop = FALSE]
        }
    } else {
        NULL
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


cran_archive <- function() {
    if (check_r_version()) {
        return(tools::CRAN_archive_db())
    }
    read_CRAN(CRAN_baseurl(), "src/contrib/Meta/archive.rds")
}
