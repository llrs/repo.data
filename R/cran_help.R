
#' Help pages without links
#'
#' Help pages without links to other help pages.
#' This makes harder to navigate to related help pages.
#' @inheritParams cran_links
#' @returns A data.frame with two columns: Package and Source
#' `NA` if not able to collect the data from CRAN.
#' @export
#' @family functions related to CRAN help pages
#' @examples
#' \donttest{
#' ap <- available.packages()
#' if (NROW(ap)) {
#'     a_package <- rownames(ap)[startsWith(rownames(ap), "A")][1]
#'     chnl <- cran_help_pages_not_linked(a_package)
#'     head(chnl)
#' }
#' }
cran_help_pages_not_linked <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    cal <-  cran_alias(packages)
    if (!NROW(cal)) {
        stop("Package not found", call. = FALSE)
    }
    rbl <- cran_targets_links()
    if (is_not_data(rbl)) {
        return(NA)
    }
    if (!is.null(packages)) {
        rbl <- packages_in_links(rbl, packages)
    }
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "from_Rd")
    ubal <- unique(cal[, alias_cols])

    links_cols2 <- c("to_pkg", "to_Rd")
    pages <- merge(ubal, unique(rbl[, c(links_cols2, links_cols)]),
                   by.x = alias_cols, by.y = links_cols2,
                   all.x = TRUE, all.y = FALSE, sort = FALSE)
    keep <- is.na(pages$from_pkg)
    if (!is.null(keep)) {
        keep <-  keep & pages$to_pkg %in% packages
    }
    pages2 <- pages[, alias_cols, drop = FALSE]
    p <- sort_by(pages2, pages2[, c("Package", "Source")] )
    rownames(p) <- NULL
    p
}

#' Help pages not linked
#'
#' Help pages without links from other help pages.
#' This makes harder to find them.
#' @inheritParams base_alias
#' @returns A data.frame with two columns: Package and Source
#' `NA` if not able to collect the data from CRAN.
#' @export
#' @family functions related to CRAN help pages
#' @examples
#' \donttest{
#' ap <- available.packages()
#' if (NROW(ap)) {
#'     a_package <- rownames(ap)[startsWith(rownames(ap), "a")][1]
#'     chwl <- cran_help_pages_wo_links(a_package)
#'     head(chwl)
#' }
#' }
cran_help_pages_wo_links <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    cal <- cran_alias(packages)
    # cl <- cran_links()
    rbl <- save_state("cran_targets_links", cran_targets_links(), verbose = FALSE)
    if (is_not_data(rbl)) {
        return(NA)
    }
    if (!is.null(packages)) {
        rbl <- packages_in_links(rbl, packages)
    }
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "from_Rd")
    ubal <- unique(cal[, alias_cols])

    pages2 <- merge(ubal, unique(rbl[, c(links_cols, "to_pkg", "to_Rd")]),
                    by.x = alias_cols, by.y = links_cols,
                    all.x = TRUE, all.y = FALSE, sort = FALSE)
    p <- pages2[is.na(pages2$to_pkg), alias_cols, drop = FALSE]
    p <- sort_by(p, p[, c("Package", "Source")])
    rownames(p) <- NULL
    p
}

#' Help pages with cliques
#'
#' Some help pages have links to other pages and they might be linked from others
#' but they are closed network: there is no link that leads to different help pages.
#' Each group of linked help pages is a clique.
#'
#' The first clique is the biggest one.
#' You might want to check if others cliques can be connected to this one.
#'
#' Requires igraph.
#'
#' @inheritParams base_alias
#' @returns Return a data.frame of help pages not connected to the network of help pages.
#' Or NULL if nothing are found.
#' `NA` if not able to collect the data from CRAN.
#' @family functions related to CRAN help pages
#' @export
#' @examplesIf requireNamespace("igraph", quietly = TRUE)
#' chc <- cran_help_cliques("BaseSet")
#' table(chc$clique)
#' chc[chc$clique != 1L, ]
cran_help_cliques <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    if (!check_installed("igraph")) {
        stop("This function requires igraph to find help pages not linked to the network.",
             call. = FALSE)
    }
    if (!is.null(packages)) {
        ap <- tryCatch(available.packages(filters = c("CRAN", "duplicates")), warning = function(w){NA})
        if (is_not_data(ap)) {
            return(NA)
        }
        pkges <- tools::package_dependencies(packages,
                                             recursive = TRUE,
                                             db = ap)
    } else {
        pkges <- NULL
    }

    pkges <- c(packages, funlist(pkges))
    # FIXME: We don't need to calculate the number of unique links targets 2 pages
    # Solution: create an internal version that omits counting them
    cpl <- cran_pages_links(pkges)
    if (is_not_data(cpl)) {
        return(NA)
    }
    if (!is.null(pkges)) {
        cpl <- packages_in_links(cpl, pkges)
        cpl <- cpl[cpl$from_pkg %in% pkges | (!is.na(cpl$to_pkg) & cpl$to_pkg %in% packages), , drop = FALSE]
    }
    # Filter out those links not resolved
    cpl <- cpl[nzchar(cpl$to_Rd) & nzchar(cpl$from_Rd), , drop = FALSE]

    if (!NROW(cpl)) {
        return(NULL)
    }
    df_links <- data.frame(from = paste0(cpl$from_pkg, ":", cpl$from_Rd),
                           to = paste0(cpl$to_pkg, ":", cpl$to_Rd))
    df_links <- unique(df_links)

    graph <- igraph::graph_from_edgelist(as.matrix(df_links))

    graph_decomposed <- igraph::decompose(graph)
    lengths_graph <- lengths(graph_decomposed)
    isolated_help <- lapply(graph_decomposed, function(x){igraph::vertex_attr(x)$name})

    l <- strsplit(funlist(isolated_help), ":", fixed = TRUE)
    df <- as.data.frame(t(list2DF(l)))
    colnames(df) <- c("from_pkg", "from_Rd")
    df$clique <- rep(seq_along(lengths_graph), times = lengths_graph)

    # Discard cliques not involving the requested packages
    if (!is.null(packages)) {
        valid_clique <- vapply(split(df, df$clique), function(x){any(packages %in% x$from_pkg | packages %in% x$to_pkg)}, logical(1L))
        df <- df[df$clique %in% names(valid_clique)[valid_clique], , drop = FALSE]
    }
    m <- merge(df, cpl, all.x = TRUE,
               by = c("from_pkg", "from_Rd"),
               sort = FALSE)

    msorted <- sort_by(m, m[, c("clique", "from_pkg", "from_Rd", "to_pkg", "to_Rd", "n")])
    rownames(msorted) <- NULL
    msorted
}

#' Links without dependencies
#'
#' On [WRE section "2.5 Cross-references"](https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Cross_002dreferences) explains that packages shouldn't link
#' to help pages outside the dependency.
#'
#' @inheritParams cran_links
#' @references <https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Cross_002dreferences>
#' @returns A data.frame of help pages and links.
#' `NA` if not able to collect the data from CRAN.
#' @export
#'
#' @examples
#' evmix <- cran_help_pages_links_wo_deps("evmix")
cran_help_pages_links_wo_deps <- function(packages = NULL) {
    check_pkg_names(packages, NA)
    ref_packages <- packages
    ap <- tryCatch(available.packages(filters = c("CRAN", "duplicates")), warning = function(w){NA})
    if (is_not_data(ap)) {
        return(NA)
    }
    if (!is.null(packages) && check_pkg_names(packages, NA)) {
        pkg <- tools::package_dependencies(packages, db = ap, recursive = TRUE)
        packages <- setdiff(funlist(pkg), BASE)
        ap <- ap[packages, c("Package", check_which("strong"))]
    } else {
        ap <- ap[, c("Package", check_which("strong"))]
    }

    links <- cran_links(ref_packages)
    if (is_not_data(links)) {
        return(NA)
    }
    xrefs_wo_deps(links, ap, ref = ref_packages)
}
