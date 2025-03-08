#' CRAN's links
#'
#' Retrieve links on CRAN packages' R documentation files.
#' @returns A data.frame with the links on CRAN's packages.
#' It has 4 columns: Package, Anchor, Target and Source.
#' @family links
#' @seealso [tools::CRAN_rdxrefs_db()]
#' @export
#' @examples
#' cl <- cran_links()
#' head(cl)
cran_links <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    cr <- save_state("cran_rdxrefs", xrefs2df(tools::CRAN_rdxrefs_db()))
    as.data.frame(cr[, c("Package", "Source", "Target", "Anchor")])
}

resolve_cran_links <- function() {

}


# Fill with CRAN targets
fill_xref_cran <- function(z, alias = cran_, duplicates = dup_cran[["Target"]]) {
    # No anchors assuming they are from CRAN
    no_anchor <- !nzchar(z$Anchor)
    no_anchor_no_dup <- no_anchor & is.na(z[["to_pkg"]]) & !z[["Target"]] %in% duplicates
    match_target <- match(z[["Target"]][no_anchor_no_dup], alias[["Target"]])

    # Adding values
    z[["to_pkg"]][no_anchor_no_dup] <- alias[["Package"]][match_target]
    z[["to_target"]][no_anchor_no_dup] <- alias[["Target"]][match_target]

    # Adding the package of those that have anchors
    missing_but_anchor <- is.na(z[["to_pkg"]]) & startsWith(z[["Anchor"]], "=")
    z[["to_pkg"]][missing_but_anchor] <- z[["Package"]][missing_but_anchor]

    # Adding duplicated Targets/topics at other packages but present on the package
    blank_target <- is.na(z$to_target)
    for (pkg in unique(z[["Package"]][blank_target])) {
        z_keep <- z[["Package"]] == pkg & blank_target
        alias_keep <- alias[["Package"]] == pkg
        m <- match(z[["Target"]][z_keep], alias[["Target"]][alias_keep])
        z[["to_target"]][z_keep] <- alias[["Target"]][alias_keep][m]
        z[["to_pkg"]][z_keep] <- alias[["Package"]][alias_keep][m]
    }
    z
}
