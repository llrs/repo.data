#' CRAN's alias
#'
#' Retrieve alias available on CRAN.
#' @inheritParams base_alias
#' @returns A data.frame with three columns: Package, Source and Target.
#' @export
#' @family alias
#' @seealso The raw source of the data is: \code{\link[tools:CRAN_aliases_db]{CRAN_aliases_db()}}.
#' @examples
#' ca <- cran_alias()
#' head(ca)
cran_alias <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    stopifnot("NULL or a character string" = is.null(packages) || is.character(packages))
    first <- check_env("cran_aliases") && is.null(packages)
    save_state("cran_aliases", alias2df(tools::CRAN_aliases_db()))
    alias <- get_package_subset("cran_aliases", packages)
    if (first) {
        check_alias(alias)
    }
    as.data.frame(alias[, c("Package", "Source", "Target")])
}
