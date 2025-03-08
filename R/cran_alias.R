#' CRAN's alias
#'
#' Retrieve alias available on CRAN.
#' @returns A data.frame with three columns: Package, Source and Target.
#' @export
#' @family alias
#' @seealso [tools::CRAN_aliases_db()]
#' @examples
#' ca <- cran_alias()
#' head(ca)
cran_alias <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    ca <- save_state("cran_aliases", alias2df(tools::CRAN_aliases_db()))
    as.data.frame(ca[, c("Package", "Source", "Target")])
}

dup_alias <- function(alias) {
        df <- duplicated(alias[, "Target"])
        dup_targets <- unique(alias[df, "Target"])
        pkg_df <- alias[alias[, "Target"] %in% dup_targets, ]
        s <- split(pkg_df$Package, pkg_df$Target)
        v <- vapply(s, paste, collapse = ", ", FUN.VALUE = character(1L))
        df <- data.frame(Alias = names(s), Packages = v)
        rownames(df) <- NULL
        df
    }
