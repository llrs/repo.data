#' CRAN's links
#'
#' Retrieve links on CRAN packages' R documentation files.
#' @inheritParams base_alias
#' @returns A data.frame with the links on CRAN's packages.
#' It has 4 columns: Package, Anchor, Target and Source.
#' `NA` if not able to collect the data from CRAN.
#' @family links from CRAN
#' @family meta info from CRAN
#' @seealso The raw source of the data is: \code{\link[tools:CRAN_rdxrefs_db]{CRAN_rdxrefs_db()}}.
#' @export
#' @examples
#' cl <- cran_links("CytoSimplex")
#' head(cl)
cran_links <- function(packages = NULL) {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    raw_xrefs <- save_state("cran_rdxrefs", tools::CRAN_rdxrefs_db())
    if (is_not_data(raw_xrefs)) {
        return(NA)
    }
    check_pkg_names(packages, NA)
    env <- "full_cran_rdxrefs"
    
    # Check for missing packages
    current_packages <- names(raw_xrefs)
    omit_pkg <- check_current_pkg(packages, current_packages)
    
    # Keep only packages that can be processed
    packages <- setdiff(packages, omit_pkg)
    if (!is.null(packages) && !length(packages)) {
        return(NULL)
    }
    
    # Check if there is already data
    first_xrefs <- empty_env(env)
    if (first_xrefs) {
        xrefs <- NULL
    } else {
        xrefs <- pkg_state[[env]]
    }
    
    # Decide which packages are to be added to the data
    if (!is.null(packages) && !first_xrefs) {
        new_packages <- setdiff(packages, xrefs[, "Package"])
    } else if (!is.null(packages) && first_xrefs) {
        new_packages <- intersect(packages, current_packages)
    } else if (is.null(packages) && first_xrefs) {
        new_packages <- current_packages
    } else if (is.null(packages) && !first_xrefs) {
        new_packages <- setdiff(current_packages, xrefs[, "Package"])
    }
    
    # Add new package's data
    if (length(new_packages)) {
        new_xrefs <- xrefs2df(raw_xrefs[new_packages])
        # warnings_links(new_xrefs)
        xrefs <- rbind(xrefs, new_xrefs)
        pkg_state[[env]] <- xrefs[, c("Package", "Source", "Anchor", "Target")]
    }
    if (is.null(packages)) {
        as.data.frame(xrefs)
    } else {
        as.data.frame(xrefs[xrefs[, "Package"] %in% packages, , drop = FALSE])
    }
}

#' Links between help pages by target
#'
#' Explore the relationship between CRAN packages and other help pages by the target they use.
#' @inheritParams base_alias
#' @family links from CRAN
#' @returns A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_target, to_Rd, n (Number of links).
#' @export
#' @examples
#' ctl <- cran_targets_links("BaseSet")
#' head(ctl)
cran_targets_links <- function(packages = NULL) {
    out <- NULL
    env <- "cran_targets_links"
    first_call <- empty_env(env)
    check_pkg_names(packages, NA)
    current_env <- get_package_subset(env, pkges = packages)
    targets_packages <- current_env$from_pkg
    subset_pkg <- !first_call && !is.null(packages) && all(packages %in% targets_packages)      
    
    if ((!is.null(packages) && !is.null(current_env)) || subset_pkg) {
        out <- packages_in_links(current_env, packages)
        rownames(out) <- NULL
        return(out)
    }
    
    current_packages <- current_cran_packages()
    new_packages <- setdiff(current_packages, out$from_pkg)
    
    cl <- cran_links(new_packages)
    bal <- base_alias()
    cal <- cran_alias(new_packages)
    bl2 <- split_anchor(cl)
    
    t2b2 <- targets2files(bl2, rbind(as.matrix(bal), as.matrix(cal)))
    out <- add_uniq_count(t2b2)
    
    pkg_state[[env]] <- rbind(current_env, out)
    out <- get_package_subset(env, packages)
    rownames(out) <- NULL
    out
}

#' Links between help pages by page
#'
#' Explore the relationship between CRAN packages and other help pages.
#' If the target help page is ambiguous it is omitted.
#' @inheritParams base_alias
#' @family links from CRAN
#' @returns A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_Rd, n (Number of links).
#' @export
#' @examples
#' cpl <- cran_pages_links("Matrix")
#' head(cpl)
cran_pages_links <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    
    target_links <- cran_targets_links(packages)
    if (is_not_data(target_links)) {
        return(NA)
    }
    
    w <- which(colnames(target_links) == "to_target")
    keep_rows <- nzchar(target_links$to_pkg)
    if (!is.null(packages)) {
        keep_rows <- keep_rows & (target_links$from_pkg %in% packages | target_links$to_pkg %in% packages)
    }
    add_uniq_count(target_links[keep_rows, -w])
}

#' Links between help pages by package
#'
#' Explore the relationship between CRAN packages and other packages.
#' If the target package is ambiguous it is omitted.
#' @inheritParams base_alias
#' @family links from CRAN
#' @returns A data.frame with 6 columns: from_pkg, to_pkg, n (Number of links).
#' `NA` if not able to collect the data from CRAN.
#' @export
#' @examples
#' \donttest{
#' cpkl <- cran_pkges_links()
#' head(cpkl)
#' }
cran_pkges_links <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    target_links <- cran_targets_links(packages)
    if (is_not_data(target_links)) {
        return(NA)
    }
    w <- which(!colnames(target_links) %in% c("from_pkg", "to_pkg"))
    keep_rows <- nzchar(target_links$to_pkg)
    if (!is.null(packages)) {
        keep_rows <- keep_rows & target_links$from_pkg %in% packages
    }
    add_uniq_count(target_links[keep_rows, -w])
}
