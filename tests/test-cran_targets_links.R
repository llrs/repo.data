library("repo.data")
pkges <- c("BaseSet", "experDesign")

# Test that it works
st1 <- system.time(ctl <- cran_targets_links(pkges))
repo.data:::no_internet(ctl)
stopifnot(colnames(ctl) == c("from_pkg", "from_Rd", "to_pkg", "to_target", "to_Rd", "n"))
stopifnot("CRAN has documentation pages" = as.logical(NROW(ctl)))
stopifnot("Returns more than from the packages requested" = all(ctl$from_pkg %in% pkges))

# Cache
st2 <- system.time(ctl2 <- cran_targets_links(pkges))
repo.data:::no_internet(ctl2)
stopifnot(identical(ctl, ctl2))
stopifnot("Second call is not faster than first one" = st2["elapsed"] < st1["elapsed"])

st3 <- system.time(ctl3 <- cran_targets_links())
repo.data:::no_internet(ctl3)
stopifnot("Requests for all packages failed" = nrow(ctl3) > nrow(ctl))
# stopifnot("Cache doesn't work for requested packages" = any(st1 < st3)): Faster process all than just some?

# Page links
st1 <- system.time(cpl <- cran_pages_links(pkges))
repo.data:::no_internet(cpl)
st2 <- system.time(cpl2 <- cran_pages_links(pkges))
repo.data:::no_internet(cpl2)
stopifnot("Cache doesn't work for requested packages" = st1["elapsed"] < st3["elapsed"])
stopifnot(identical(cpl, cpl2))
st3 <- system.time(cpl <- cran_pages_links())
repo.data:::no_internet(cpl)
stopifnot("Didn't return all packages" = nrow(cpl) > nrow(cpl2))

# Packages links
st2 <- system.time(cpl <- cran_pkges_links(pkges))
repo.data:::no_internet(cpl)
st2 <- system.time(cpl <- cran_pkges_links(pkges))
repo.data:::no_internet(cpl2)
stopifnot("Cache doesn't work for requested packages" = st1["elapsed"] < st3["elapsed"])
stopifnot(identical(cpl, cpl2))
st3 <- system.time(cpl <- cran_pkges_links())
repo.data:::no_internet(cpl)
stopifnot("Didn't return all packages" = nrow(cpl) > nrow(cpl2))