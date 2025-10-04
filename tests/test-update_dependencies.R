library("repo.data")
pkg <- "ggeasy"
pd <- package_dependencies(pkg)
repo.data:::no_internet(pd)
ud <- update_dependencies(pkg)
repo.data:::no_internet(ud)
stopifnot(as.logical(length(ud)))
stopifnot(NROW(ud) <= NROW(pd))

pkg <- "teal"
rd <- repos_dependencies(pkg)
repo.data:::no_internet(rd)
pd <- package_dependencies(pkg)
repo.data:::no_internet(pd)
diff <- merge(pd, rd, by = "Name")

ud <- suppressWarnings(update_dependencies(pkg))
repo.data:::no_internet(ud)
m <- merge(ud, pd, all = FALSE)
stopifnot("Packages that don't need updating show up on update_dependencies" = NROW(m) <= NROW(diff))
