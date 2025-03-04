
#' CRAN's links
#'
#' Retrieve links on CRAN packages' R documentation files.
#' @returns A data.frame with the links on CRAN's packages
#' @export
#' @examples
#' cl <- cran_links()
#' head(cl)
cran_links <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    cr <- save_state("cran_rdxrefs", xrefs2df(tools::CRAN_rdxrefs_db()))
    as.data.frame(cr)
}
