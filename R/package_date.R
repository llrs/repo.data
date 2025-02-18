#' Find earliest date of compatibility
#'
#' Search the DESCRIPTION file for the release dates of dependencies and return the earliest date.
#' This is the date at which the package could be installed.
#' @param dir Path to the package folder
#'
#' @returns
#' @export
#'
#' @examples
package_date <- function(dir = ".") {
    desc <- read.dcf(file.path(".", "DESCRIPTION"))
    # Get package dependencies.
    fields <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")
    deps <- desc[, intersect(fields, colnames(desc))]

    l <- strsplit(deps, split = ",\s", fixed = TRUE)
    base <- rownames(installed.packages(priority = "base"))

    df <- data.frame(Package = unlist(l, use.names = FALSE),
                     Type = rep(names(l), lengths(l)), check.names = FALSE)

    # TODO: split by Ops and version

    # Check recursive dependencies.
    ap <- available.packages()
    ab <- ap[intersect(df$Package, rownames(ap)), intersect(fields, colnames(ap))]
    strsplit(ab, split = ",\\s", fixed = FALSE)
    rec_deps <- tools::package_dependencies(setdiff(df$Package, base), db = ap, recursive = TRUE)
    rec_deps <- funlist(rec_deps)
    extra_pkg <- setdiff(rec_deps, base)

    # Use cran_archive, to get the release dates of packages.
    archive <- cran_archive()
    # Check version required.
    #
    # TODO: Check R releases too.
    # Get the latest date.

    #
}
