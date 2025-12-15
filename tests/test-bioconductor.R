library("repo.data")

bca <- bioc_cran_archived()
repo.data:::no_internet(bca)
stopifnot(colnames(bca) == c("Package", "Archived", "n"))
# Might be empty (hopefullly)
