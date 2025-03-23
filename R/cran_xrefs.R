#' CRAN's links
#'
#' Retrieve links on CRAN packages' R documentation files.
#' @inheritParams base_alias
#' @returns A data.frame with the links on CRAN's packages.
#' It has 4 columns: Package, Anchor, Target and Source.
#' @family links
#' @seealso The raw source of the data is: [tools::CRAN_rdxrefs_db()]
#' @export
#' @examples
#' cl <- cran_links()
#' head(cl)
cran_links <- function(package = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    save_state("cran_rdxrefs", xrefs2df(tools::CRAN_rdxrefs_db()))
    cr <- get_package_subset("cran_rdxrefs", package)
    as.data.frame(cr[, c("Package", "Source", "Target", "Anchor")])
}

cran_all_links <- function() {
    bal <- base_alias()
    cal <- cran_alias()
    cl <- cran_links()
    cl2 <- split_anchor(cl)

    t2b2 <- targets2files(cl2, rbind(bal, cal))
    out <- uniq_count(t2b2)
    save_state("cran_all_links", out, verbose = FALSE)
    # add_uniq_count
}

resolve_cran_links <- function(links = cran_links(), alias = cran_alias()) {
    c2 <- split_anchor(links)
    b2 <- split_anchor(base_links())
    bal <- base_alias()
    cal <- cran_alias()
    dab <- dup_alias(cal)
    cab <- dup_alias(cal)
    # b3 <- resolve_base_links(b2, bal)
    c3 <- fill_xref_base(c2, bal, dab$Alias)
    c3a <- fill_xref_cran(c2, bal, dab$Alias)
    c3b <- fill_xref_cran(c3a, cal, cab$Alias)
    c8 <- fill_xref_cran(as.matrix(c3), cal, cab$Alias)
    c4 <- fill_xref_base(c3, cal, cab$Alias)
    # TODO fix this
    # c4 <- merge(c4, cal,
    #             by.x = c("to_pkg", "to_target"),
    #             by.y = c("Package", "Target"),
    #             all.x = TRUE, sort = FALSE)

    colnames(c4)[c(1, 2, 6)] <- c("from_pkg", "Rd_origin", "Rd_linked")
    c4 <- c4[, c("from_pkg", "Rd_origin", "to_pkg",  "Rd_linked")]
    c6 <- sort_by(c4, ~from_pkg + Rd_origin)
    uc6 <- unique(c6[!is.na(c6$from_pkg), ])
    rownames(uc6) <- NULL
    uc6

}


# Fill with CRAN targets
fill_xref_cran <- function(z, alias, duplicates) {
    # No anchors assuming they are from CRAN
    no_anchor <- !nzchar(z[, "Anchor"])
    no_anchor_no_dup <- no_anchor & is.na(z[ , "to_pkg"]) & !z[ , "Target"] %in% duplicates
    match_target <- match(z[no_anchor_no_dup, "Target"], alias[ , "Target"])

    # Adding values
    z[no_anchor_no_dup, "to_pkg"] <- alias[match_target, "Package"]
    z[no_anchor_no_dup, "Rd_destiny"] <- alias[match_target, "Source"]

    # Adding the package of those that have anchors
    missing_but_anchor <- is.na(z[ , "to_pkg"]) & startsWith(z[ , "Anchor"], "=")
    z[missing_but_anchor, "to_pkg"] <- z[missing_but_anchor, "Package"]

    # Adding duplicated Targets/topics at other packages but present on the package
    blank_target_n_dup <- is.na(z[, "to_target"]) & z[, "Target"] %in% duplicates
    for (pkg in unique(z[blank_target_n_dup, "Package"])) {
        z_keep <- z[ , "Package"] == pkg & blank_target_n_dup
        alias_keep <- alias[ , "Package"] == pkg
        m <- match(z[z_keep, "Target"], alias[alias_keep, "Target"])
        z[z_keep, "Rd_destiny"] <- alias[alias_keep, "Source"][m]
        z[z_keep, "to_pkg"] <- alias[alias_keep, "Package"][m]
    }
    as.data.frame(z)
}
