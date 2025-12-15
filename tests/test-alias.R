library("repo.data")

# Test that it works
ca <- cran_alias()
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == c("Package", "Source", "Target"))



ba <- base_alias()
repo.data:::no_internet(ba)
stopifnot(colnames(ba) == c("Package", "Source", "Target"))

a <- alias()
repo.data:::no_internet(a)
stopifnot(colnames(a) == c("Package", "Source", "Target"))