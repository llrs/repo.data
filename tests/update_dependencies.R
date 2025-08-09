pd <- package_dependencies("ggeasy")
ud <- update_dependencies(pd)
stopifnot(NROW(ud))
