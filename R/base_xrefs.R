#' Base R's links
#'
#' Retrieve links on R documentation files.
#' @inheritParams base_alias
#' @returns A data.frame with the links on R's files.
#' It has 4 columns: Package, Anchor, Target and Source.
#' @family links
#' @seealso The raw source of the data is: [tools::base_rdxrefs_db()]
#' @export
#' @examples
#' bl <- base_links()
#' head(bl)
base_links <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    save_state("base_rdxrefs", xrefs2df(tools::base_rdxrefs_db()))
    links <- get_package_subset("base_rdxrefs", packages)
    as.data.frame(links)[, c("Package", "Source", "Target", "Anchor")]
}
