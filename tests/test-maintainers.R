library("repo.data")
cm <- cran_maintainers()
repo.data:::no_internet(cm)
stopifnot(colnames(cm) == c("Package", "Maintainer", "user", "maintainer_date", "packaged_date",
                            "published_date", "Name", "email", "direction", "domain"))
stopifnot("There is data" = as.logical(NROW(cm)))
