# Raw testing without using any package (testthat or tinytest) as described on WRE

library("repo.data")
options(repos = "https://CRAN.R-project.org")
# cran archive ####
rtweet <- cran_archive("rtweet")
stopifnot(nrow(rtweet) >= 15L)
# Repeat search for a different package to test for accessing the cache with a package currently on CRAN
BaseSet <- cran_archive("BaseSet")
stopifnot(nrow(BaseSet) > 1L && nrow(BaseSet) < 200)
# Test on a package without archive
ABACUS <- cran_archive("ABACUS")
stopifnot(nrow(ABACUS) == 1L)

pkges <- c("BaseSet", "dplyr")
cpk <- cran_archive(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
stopifnot(identical(pkgs_out, pkges))
cpk2 <- cran_archive(pkges)
stopifnot(identical(cpk, cpk2))

# cran alias ####
pkges <- c("BaseSet", "dplyr")
cpk <- cran_alias(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
stopifnot(identical(pkgs_out, pkges))
cpk2 <- cran_alias(pkges)
stopifnot(identical(cpk, cpk2))

# cran links ####
pkges <- c("BaseSet", "dplyr")
cpk <- cran_links(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
stopifnot(identical(pkgs_out, pkges))
cpk2 <- cran_links(pkges)
stopifnot(identical(cpk, cpk2))


# dependencies ####
pkges <- c("BaseSet")
suppressWarnings(cpk <- package_dependencies(pkges))
stopifnot(ncol(cpk) == 6L)
pkgs_out <- setdiff(pkges, cpk$package)
stopifnot(identical(pkgs_out, pkges))
suppressWarnings(cpk2 <- package_dependencies(pkges))
stopifnot(identical(cpk, cpk2))

suppressWarnings(pd <- package_dependencies(c("ggeasy", "BaseSet")))
stopifnot(ncol(pd) == 2L)

# Snapshot ####
cs <- cran_snapshot(Sys.Date() -2 )
stopifnot(NROW(cs) > 1000)

# check_packages
stopifnot(isTRUE((tryCatch(suppressWarnings(package_dependencies(character())), error = function(e){TRUE}))))
