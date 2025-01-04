alias_cran <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    aliases_CRAN <- tools::CRAN_aliases_db()
}
