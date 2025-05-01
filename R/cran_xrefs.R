#' CRAN's links
#'
#' Retrieve links on CRAN packages' R documentation files.
#' @inheritParams base_alias
#' @returns A data.frame with the links on CRAN's packages.
#' It has 4 columns: Package, Anchor, Target and Source.
#' @family links
#' @seealso The raw source of the data is: `tools::CRAN_rdxrefs_db()`
#' @export
#' @examples
#' cl <- cran_links()
#' head(cl)
cran_links <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    first <- check_env("cran_rdxrefs") && is.null(packages)
    save_state("cran_rdxrefs", xrefs2df(tools::CRAN_rdxrefs_db()))
    cr <- get_package_subset("cran_rdxrefs", packages)
    if (first) {
        # check_links(cr)
    }
    as.data.frame(cr[, c("Package", "Source", "Target", "Anchor")])
}

#' Links between help pages by target
#'
#' Explore the relationship between CRAN packages and other help pages by the target they use.
#' @inheritParams base_alias
#' @family links
#' @returns A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_target, to_Rd, n (Number of links).
#' @export
#' @examples
#' ctl <- cran_targets_links()
#' head(ctl)
cran_targets_links <- function(packages = NULL) {
    out <- NULL
    out <- save_state("cran_targets_links", out, verbose = FALSE)
    if (is.null(out)) {
        bal <- base_alias()
        cal <- cran_alias()
        cl <- cran_links()
        cl2 <- split_anchor(cl)

        t2b2 <- targets2files(cl2, rbind(bal, cal))
        # browser() # FIXME: Verify output is not just 1 or fails.
        out <- add_uniq_count(t2b2)
        out <- save_state("cran_targets_links", out, verbose = FALSE)
    }
    if (!is.null(packages)) {
        out <- out[out$from_pkg %in% packages | out$to_pkg %in% packages, ]
        rownames(out) <- NULL
        out
    } else {
        out
    }
}

#' Links between help pages by page
#'
#' Explore the relationship between CRAN packages and other help pages.
#' If the target help page is ambiguous it is omitted.
#' @inheritParams base_alias
#' @family links
#' @returns A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_Rd, n (Number of links).
#' @export
#' @examples
#' cpl <- cran_pages_links()
#' head(cpl)
cran_pages_links <- function(packages = NULL) {
    target_links <- save_state("cran_targets_links", cran_targets_links(packages))
    w <- which(colnames(target_links) %in% "to_target")
    keep_rows <- nzchar(target_links$to_pkg)
    if (!is.null(packages)) {
        keep_rows <- keep_rows & target_links %in% packages
    }
    add_uniq_count(target_links[keep_rows, -w])
}

#' Links between help pages by package
#'
#' Explore the relationship between CRAN packages and other packages.
#' If the target package is ambiguous it is omitted.
#' @inheritParams base_alias
#' @family links
#' @returns A data.frame with 6 columns: from_pkg, to_pkg, n (Number of links).
#' @export
#' @examples
#' cpkl <- cran_pkges_links()
#' head(cpkl)
cran_pkges_links <- function(packages = NULL) {
    target_links <- save_state("cran_pages_links", base_targets_links())
    w <- which(!colnames(target_links) %in% c("from_pkg", "to_pkg"))
    keep_rows <- nzchar(target_links$to_pkg)
    if (!is.null(packages)) {
        keep_rows <- keep_rows & target_links %in% packages
    }
    add_uniq_count(target_links[keep_rows, -w])
}
