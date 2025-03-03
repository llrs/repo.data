
links_cran <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    cr <- save_state("cran_rdxrefs", xrefs2df(tools::CRAN_rdxrefs_db()))
}

aliasesCRAN$filename <- tools::file_path_sans_ext(aliasesCRAN$Source)
