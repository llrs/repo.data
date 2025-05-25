# Raw testing without using any package (testthat or tinytest) as described on WRE

library("repo.data")
options(repos = "https://CRAN.R-project.org")
# cran archive ####
pkges <- c("BaseSet", "dplyr")
cpk <- cran_archive(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
length(pkgs_out) == 0
cpk2 <- cran_archive(pkges)
identical(cpk, cpk2)

# cran alias ####
pkges <- c("BaseSet", "dplyr")
cpk <- cran_alias(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
length(pkgs_out) == 0
cpk2 <- cran_alias(pkges)
identical(cpk, cpk2)

# cran links ####
pkges <- c("BaseSet", "dplyr")
cpk <- cran_links(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
length(pkgs_out) == 0
cpk2 <- cran_links(pkges)
identical(cpk, cpk2)


# dependencies ####
pkges <- c("BaseSet")
cpk <- package_dependencies(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
length(pkgs_out) == 0
cpk2 <- package_dependencies(pkges)
identical(cpk, cpk2)
