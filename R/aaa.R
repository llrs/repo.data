cran_tz <- "Europe/Vienna"

pkg_state <- new.env(parent = emptyenv())

PACKAGE_FIELDS <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")

BASE <- tools::standard_package_names()$base

options(repos = "https://CRAN.R-project.org")
