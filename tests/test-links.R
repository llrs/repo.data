library("repo.data")

# Test that it works
cl <- cran_links()
repo.data:::no_internet(cl)
stopifnot(colnames(cl) == c("Package", "Source", "Anchor", "Target"))

l <- links()
repo.data:::no_internet(l)
stopifnot(colnames(l) == c("Package", "Source", "Anchor", "Target"))

btl <- base_targets_links()
repo.data:::no_internet(btl)
stopifnot(colnames(btl) == c("from_pkg", "from_Rd", "to_pkg", "to_target", "to_Rd", "n"))

bpl <- base_pages_links()
repo.data:::no_internet(bpl)
stopifnot(colnames(bpl) == c("from_pkg", "from_Rd", "to_pkg", "to_Rd", "n"))

bpkgl <- base_pkges_links()
repo.data:::no_internet(bpkgl)
stopifnot(colnames(bpkgl) == c("from_pkg", "to_pkg", "n"))
