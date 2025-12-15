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
    out <- get_package_subset(env, pkges = packages)
    targets_packages <- out$from_pkg
    if (!is.null(packages) && !is.null(out)) {
        return(packages_in_links(out, packages))
    } else if (!first_call && !is.null(packages) && all(packages %in% targets_packages)) {
        return(packages_in_links(out, packages))
    } else if (!first_call && all(targets_packages %in% current_cran_packages())) {
        return(out)
    }

    cl <- cran_links(packages)
    bal <- base_alias()
    cal <- cran_alias(packages)
    bl2 <- split_anchor(cl)

    t2b2 <- targets2files(bl2, rbind(bal, cal))
    out <- uniq_count(t2b2)
    save_state(env, out, verbose = FALSE)
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
    target_links <- cran_targets_links()
    if (is_not_data(target_links)) {
        return(NA)
    }
    check_pkg_names(packages, NA)
    w <- which(!colnames(target_links) %in% c("from_pkg", "to_pkg"))
    keep_rows <- nzchar(target_links$to_pkg)
    if (!is.null(packages)) {
        keep_rows <- keep_rows & target_links %in% packages
    }
    add_uniq_count(target_links[keep_rows, -w])
}
