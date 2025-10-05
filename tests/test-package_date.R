library("repo.data")

# Test deps without version number
pd <- package_date("ggeasy")
repo.data:::no_internet(pd)
stopifnot(length(pd) == 2L)
stopifnot(names(pd) == c("Published", "deps_available"))
# Test with a mix of version numbers and no versions
ud <- package_date("usethis")
repo.data:::no_internet(ud)
stopifnot(as.logical(length(ud)))
