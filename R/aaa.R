cran_tz <- "Europe/Vienna"

pkg_state <- new.env(parent = emptyenv())

#' Clean cache
#'
#' Clean cache to download repository data again.
#' @details
#' Cleans the package's environment used for caching the data.
#' @returns Returns `NULL`.
#' @examples
#' clean_cache()
#'
#' @export
clean_cache <- function() {
    lapply(names(pkg_state), function(x) {
        pkg_state[[x]] <- NULL
    })
    invisible(NULL)
}

PACKAGE_FIELDS <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")

BASE <- tools::standard_package_names()$base
