library("repo.data")

# Test that it works
st <- system.time(ca <- cran_archive(packages = c("BaseSet", "experDesign")))
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == c("Package", "Datetime", "Version", "User", "Size", "Status"))
st1 <- system.time(ca2 <- cran_archive(packages = c("BaseSet", "experDesign")))
stopifnot("Cache didn't worked" = st1[[3]] < st[[3]])
stopifnot("Cache was not the same" = all.equal(ca, ca2))

clean_cache()
st2 <- system.time(ca3 <- cran_archive(packages = c("BaseSet", "experDesign")))
repo.data:::no_internet(ca3)
stopifnot("Clean cache restores initial" = st2[[3]] > st[[3]])
stopifnot("Still same result" = all.equal(ca, ca3))

ca <- cran_archive()
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == c("Package", "Datetime", "Version", "User", "Size", "Status"))
ca2 <- cran_archive()
stopifnot("Cache returns the same for all packages" = all.equal(ca, ca2))
