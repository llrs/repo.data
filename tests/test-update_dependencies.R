library("repo.data")
pkg <- "ggeasy"
pd <- package_dependencies(pkg)
ud <- update_dependencies(pkg)
stopifnot(as.logical(length(ud)))
stopifnot(NROW(ud) <= NROW(pd))
