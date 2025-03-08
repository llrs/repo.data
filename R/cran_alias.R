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

cran_dup_alias <- function(alias) {
        df <- duplicated(alias[, "Target"])
        dup_targets <- alias[df, "Target"]
        pkg <- alias[alias[, "Target"] %in% dup_targets, "Package"]
        v <- vapply(split(pkg, dup_targets), paste, collapse = ", ", FUN.VALUE = character(1L))
        df <- data.frame(Alias = dup_targets, Packages = v)
        rownames(df) <- NULL
        df
    }
