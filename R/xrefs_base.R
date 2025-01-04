base_links <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    xrefs_base <- tools::base_rdxrefs_db()
}
