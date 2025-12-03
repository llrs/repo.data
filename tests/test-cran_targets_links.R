library("repo.data")

# Test that it works
ctl <- cran_targets_links()
repo.data:::no_internet(ctl)
stopifnot(colnames(ctl) == c("from_pkg", "from_Rd", "to_pkg", "to_target", "to_Rd", "n"))
