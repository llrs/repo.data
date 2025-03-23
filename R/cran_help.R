
#' Help pages without links
#'
#' Help pages without links to other help pages.
#' This makes harder to navigate to related help pages.
#' @returns A data.frame with two columns: Package and Source
#' @export
#' @family cran_help_pages
#' @examples
#' chnl <- cran_help_pages_not_linked()
#' head(chnl)
cran_help_pages_not_linked <- function() {
    cal <- cran_alias()
    cl <- cran_links()
    rbl <- save_state("cran_targets_links", cran_targets_links(), verbose = FALSE)
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "from_Rd")
    ubal <- unique(cal[, alias_cols])

    links_cols2 <- c("to_pkg", "to_Rd")
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
#' chwl <- cran_help_pages_wo_links()
#' head(chwl)
cran_help_pages_wo_links <- function() {

    cal <- cran_alias()
    cl <- cran_links()
    rbl <- save_state("cran_targets_links", cran_targets_links(), verbose = FALSE)
    alias_cols <- c("Package", "Source")
    links_cols <- c("from_pkg", "from_Rd")
    ubal <- unique(cal[, alias_cols])

    pages2 <- merge(ubal, unique(rbl[, c(links_cols, "to_pkg", "to_Rd")]),
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
#' chc <- cran_help_cliques()
cran_help_cliques <- function() {
    if (!check_installed("igraph")) {
        stop("This function requires igraph to find closed networks.")
    }
    cal <- save_state("cran_targets_links", cran_targets_links(), verbose = FALSE)
    df_links <- data.frame(from = paste0(cal$from_pkg, ":", cal$from_Rd),
                           to = paste0(cal$to_pkg, ":", cal$to_Rd))
    df_links <- unique(df_links)

    graph <- igraph::graph_from_edgelist(as.matrix(df_links))

    graph_decomposed <- igraph::decompose(graph)
    lengths_graph <- lengths(graph_decomposed)
    isolated_help <- sapply(graph_decomposed, igraph::vertex_attr)

    l <- strsplit(funlist(isolated_help), ":", fixed = TRUE)
    df <- as.data.frame(t(list2DF(l)))
    colnames(df) <- c("from_pkg", "from_Rd")
    df$clique <- rep(seq_len(length(lengths_graph)), times = lengths_graph)
    m <- merge(df, unique(cal), all.x = TRUE, by = c("from_pkg", "from_Rd"))
    msorted <- sort_by(m, ~clique + from_pkg + from_Rd)
    rownames(msorted) <- NULL
    msorted
}
