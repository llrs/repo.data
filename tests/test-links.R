library("repo.data")

# Test that it works
cl <- cran_links()
repo.data:::no_internet(cl)
stopifnot(colnames(cl) == c("Package", "Source", "Anchor", "Target"))

l <- links()
repo.data:::no_internet(l)
stopifnot(colnames(l) == c("Package", "Source", "Anchor", "Target"))

base_targets_links()
base_pages_links()
base_pkges_links()
