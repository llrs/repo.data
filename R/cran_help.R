
#' Help pages without links
#'
#' Help pages without links to other help pages.
#' This makes harder to navigate to related help pages.
#' @returns A data.frame with two columns: Package and Source
#' @export
#' @family cran_help_pages
#' @examples
#' bhnl <- cran_help_pages_not_linked()
#' head(bhnl)
cran_help_pages_not_linked <- function() {
    cal <- cran_alias()
    cl <- cran_links()
    rbl <- resolve_cran_links(bl, cal)
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "Rd_origin")
    ubal <- unique(cal[, alias_cols])

    links_cols2 <- c("to_pkg", "Rd_linked")
    pages <- merge(ubal, unique(rbl[, c(links_cols2, links_cols)]),
                   by.x = alias_cols, by.y = links_cols2,
                   all.x = TRUE, all.y = FALSE, sort = FALSE)
    p <- sort_by(pages[is.na(pages$from_pkg), alias_cols, drop = FALSE], ~Package + Source )
    rownames(p) <- NULL
    p
}

#' Help pages not linked from base R.
#'
#' Help pages without links from other help pages.
#' This makes harder to find them.
#' @returns A data.frame with two columns: Package and Source
#' @export
#' @family cran_help_pages
#' @examples
#' bhwl <- cran_help_pages_wo_links()
#' head(bhwl)
cran_help_pages_wo_links <- function() {

    bal <- cran_alias()
    bl <- cran_links()
    rbl <- resolve_cran_links(bl, bal)
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "Rd_origin")
    ubal <- unique(bal[, alias_cols])

    pages2 <- merge(ubal, unique(rbl[, c(links_cols, "to_pkg", "Rd_linked")]),
                    by.x = alias_cols, by.y = links_cols,
                    all.x = TRUE, all.y = FALSE, sort = FALSE)
    p <- sort_by(pages2[is.na(pages2$to_pkg), alias_cols, drop = FALSE], ~Package + Source )
    rownames(p) <- NULL
    p
}

#' Help pages with cliques
#'
#' Some help pages have links to and from but they are closed networks.
#'
#' Requires igraph
#' @returns Return a data.frame of help pages not connected to the network of help pages.
#' @family cran_help_pages
#' @export
#' @examples
#' cran_help_cliques()
cran_help_cliques <- function() {
    if (!requireNamespace("igraph", quietly = TRUE)) {
        stop("This function requires igraph to find closed networks.")
    }
    bal <- cran_alias()
    bl <- cran_links()
    rbl <- resolve_cran_links(bl, bal)
    df_links <- data.frame(from = paste0(rbl$from_pkg, ":", rbl$Rd_origin),
                           to = paste0(rbl$to_pkg, ":", rbl$Rd_linked))
    df_links <- unique(df_links)

    graph <- igraph::graph_from_edgelist(as.matrix(df_links))

    graph_decomposed <- igraph::decompose(graph)
    lengths_graph <- lengths(graph_decomposed)
    isolated_help <- sapply(graph_decomposed[-which.max(lengths_graph)], igraph::vertex_attr)

    l <- strsplit(unlist(isolated_help, FALSE, FALSE), ":", fixed = TRUE)
    df <- as.data.frame(t(list2DF(l)))
    colnames(df) <- c("from_pkg", "Rd_origin")
    lengths_graph2 <- lengths_graph[-which.max(lengths_graph)]
    df$clique <- rep(seq_len(length(lengths_graph2)), times = lengths_graph2)
    m <- merge(df, unique(rbl), all.x = TRUE, by = c("from_pkg", "Rd_origin"))
    msorted <- sort_by(m, ~clique + from_pkg + Rd_origin)
    rownames(msorted) <- NULL
    msorted
}
