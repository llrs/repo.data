library("repo.data")

# Test that it works
ca <- cran_archive()
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == c("Package", "Datetime", "Version", "User", "Size", "Status"))

