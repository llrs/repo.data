# Raw testing without using any package as described on WRE

library("repo.data")
pkges <- c("BaseSet", "dplyr")
cpk <- cran_pkges_archive(pkges)
pkgs_out <- setdiff(pkges, cpk$package)
length(pkgs_out) == 0
