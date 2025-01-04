
links_cran <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    rdxrefs_CRAN <- tools::CRAN_rdxrefs_db()
}
