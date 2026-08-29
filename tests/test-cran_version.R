library("repo.data")
chooseCRANmirror(ind = 1)
cv <- cran_version("repo.data", "0.1.5", lib = tempdir())
stopifnot(is.null(cv))
