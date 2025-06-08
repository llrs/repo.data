cran_tz <- "Europe/Vienna"

pkg_state <- new.env(parent = emptyenv())

PACKAGE_FIELDS <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")

BASE <- tools::standard_package_names()$base

.onAttach <- function(libname, pkgname) {
    opts <- options(repos = c("@CRAN@" = "https://CRAN.R-project.org"),
            available_packages_filters = c("CRAN", "duplicates"))
    pkg_state$opts <- opts
}

.onDetach <- function(libpath) {
    options(pkg_state$opts)
}
