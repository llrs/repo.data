#' Base R's alias
#'
#' Retrieve alias available on R.
#' @returns A data.frame with three columns: Package, Source and Target.
#' @export
#' @family alias
#' @seealso [tools::base_aliases_db()]
#' @examples
#' ba <- base_alias()
#' head(ba)
base_alias <- function() {
    stopifnot("Requires at least R 4.5.0" = check_r_version())
    base_aliases <- save_state("base_aliases", alias2df(tools::base_aliases_db()))
    as.data.frame(base_aliases[, c("Package", "Source", "Target")])
}

alias2df <- function(x){
    l <- lapply(x, function(x) {
        cbind(Source = rep(names(x), lengths(x)),
              Target = unlist(x, FALSE, FALSE))
    })
    aliasesDF <- do.call(rbind, l)
    aliasesDF <- cbind(aliasesDF, Package = rep(names(l), vapply(l, NROW, numeric(1L))))
    aliasesDF
}
