library("repo.data")

# Test that it works
st1 <- system.time(ctl <- cran_targets_links())
repo.data:::no_internet(ctl)
stopifnot(colnames(ctl) == c("from_pkg", "from_Rd", "to_pkg", "to_target", "to_Rd", "n"))
stopifnot("CRAN has documentation pages" = as.logical(NROW(ctl)))

# Cache
st2 <- system.time(ctl2 <- cran_targets_links())
stopifnot(identical(ctl, ctl2))
stopifnot(st2["elapsed"] < st["elapsed"])

# Subsetting
st3 <- system.time(ctl3 <- cran_targets_links("BaseSet"))
stopifnot(identical(ctl, ctl3))
stopifnot(st3["elapsed"] < st["elapsed"])
