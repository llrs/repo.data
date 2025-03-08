
#' Help pages without links
#'
#' Help pages without links to other help pages.
#' This makes harder to navigate to related help pages.
#' @returns A data.frame with two columns: Package and Source
#' @export
#' @family base_help_pages
#' @examples
#' bhnl <- base_help_pages_not_linked()
#' head(bhnl)
base_help_pages_not_linked <- function() {
    bal <- base_alias()
    bl <- base_links()
    rbl <- resolve_base_links(bl, bal)
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "Rd_origin")
    ubal <- unique(bal[, alias_cols])

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
#' @family base_help_pages
#' @examples
#' bhwl <- base_help_pages_wo_links()
#' head(bhwl)
base_help_pages_wo_links <- function() {

    bal <- base_alias()
    bl <- base_links()
    rbl <- resolve_base_links(bl, bal)
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
#' @family base_help_pages
#' @export
#' @examples
#' base_help_cliques()
base_help_cliques <- function() {
    if (!requireNamespace("igraph", quietly = TRUE)) {
        stop("This function requires igraph to find closed networks.")
    }
    bal <- base_alias()
    bl <- base_links()
    rbl <- resolve_base_links(bl, bal)
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
