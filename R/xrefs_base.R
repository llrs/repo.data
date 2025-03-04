#' R's links
#'
#' Retrieve links on R documentation files.
#' @returns A data.frame with the links on R's files.
#' It has 7 columns
#' @export
#' @examples
#' bl <- base_links()
#' head(bl)
base_links <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    br <- save_state("base_rdxrefs", xrefs2df(tools::base_rdxrefs_db()))

    s <- strcapture("([[:alnum:].]*{2,})?[:=]?(.*)",
               x = br[, "Anchor"],
               proto = data.frame(to_pkg = character(),
                                  to_target = character()))

    br2 <- cbind(br, as.matrix(s))
    ab <- alias_base()
    dab <- dup_base_alias()
    br3 <- fill_xref(br2, ab, dab$Alias)

    br4 <- merge(br3, ab,
                 by.x = c("to_pkg", "to_target"),
                 by.y = c("Package", "Target"),
                 all.x = TRUE, sort = FALSE)
    colnames(br4)[c(5, 6, 7)] <- c("Rd_origin", "from_pkg", "Rd_destiny")
    br4 <- br4[, c("Rd_origin", "from_pkg", "Anchor", "Target", "to_pkg", "to_target", "Rd_destiny")]

}

xrefs2df <- function(x) {
    rdxrefsDF <- do.call(rbind, x)
    rdxrefsDF <- cbind(rdxrefsDF, Package =rep(names(x), vapply(x, NROW, numeric(1L))))
    rownames(rdxrefsDF) <- NULL
    rdxrefsDF[, c("Source", "Target", "Anchor", "Package"), drop = FALSE]
    rdxrefsDF
}


fill_xref <- function(refs, alias, duplicate_alias) {

    # Anchors with packages
    anchor <- refs[, "Anchor"]
    missing_target <- nzchar(anchor) & !startsWith(anchor, "=") & !grepl(":", anchor, fixed = TRUE)
    refs[missing_target, "to_target"] <- refs[missing_target, "Target"]

    # Anchors with = to base packages with no duplicates
    anchors_nodup <- startsWith(anchor, "=") & !anchor %in% duplicate_alias
    match_target <- match(refs[anchors_nodup, "to_target"], alias[, "Target"])
    refs[anchors_nodup, "to_pkg"] <- alias[match_target, "Package"]

    # Anchors with = to packages with duplicates
    anchors_dup <- startsWith(anchor, "=") & anchor %in% duplicate_alias
    refs[anchors_dup, "to_pkg"] <- refs[anchors_dup, "Package"]

    # No anchors
    no_anchor <- !nzchar(anchor)
    match_target <- match(refs[no_anchor, "Target"], alias[, "Target"])
    refs[no_anchor, "to_pkg"] <- alias[match_target, "Package"]
    refs[no_anchor, "to_target"] <- alias[match_target, "Target"]
    refs
}

self_refs <- function(refs) {
    same <- refs$Rd_origin == refs$Rd_destiny & refs$from_pkg == refs$to_pkg
    unique(refs[same, c("Rd_origin", "from_pkg", "Target")])
}
