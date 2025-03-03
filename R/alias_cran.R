alias_cran <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    ca <- save_state("cran_aliases", alias2df(tools::CRAN_aliases_db()))
    as.data.frame(ca)
}


