library("repo.data")

# Test that it works
pr <- package_repos()
repo.data:::no_internet(pr)
# Expects at least one repository
cols <- ncol(pr)
stopifnot("At least 6 columns" = cols >= 6L)
# Expected colnames of first and last columns
stopifnot(all.equal(colnames(pr)[1:2], c("Package", "Repository")))
last_three_columns <- seq(from = cols - 2, to = cols)
stopifnot(all.equal(colnames(pr)[last_three_columns], c("Other", "Packages_deps", "Repos")))
stopifnot("No NA" = !anyNA(pr))

# Test that Bioconductor packages get their dependencies too
opts <- options()
repos <- c(getOption("repos"), repo.data:::bioc_repos())
pr <- package_repos(repos = repos)
opts2 <- options()
stopifnot("package_repos is messing with opts" = !identical(opts, opts2))
repo.data:::no_internet(pr)
cran <- grep("CRAN", names(repos), value = TRUE)
stopifnot("All packages have data" = sum(pr[, -c(1, 2)]) != 0L)
