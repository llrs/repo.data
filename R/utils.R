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
