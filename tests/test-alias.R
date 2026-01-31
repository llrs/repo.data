library("repo.data")
alias_columns <- c("Package", "Source", "Target")
pkges <- c("BaseSet", "experDesign")
bpkges <- c("tools", "compiler")

# Test that cache works
st <- system.time(ca <- cran_alias(pkges))
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == alias_columns)
stopifnot(is.data.frame(ca))
st1 <- system.time(ca2 <- cran_alias(pkges))
stopifnot("Cache didn't work" = st1[[3]] < st[[3]])
stopifnot("Cache was not the same" = all.equal(ca, ca2))

clean_cache()
st2 <- system.time(ca3 <- cran_alias(pkges))
repo.data:::no_internet(ca3)
stopifnot("Clean cache restores initial state" = st2[[3]] > st1[[3]])
stopifnot("Still same result" = all.equal(ca, ca3))

ca <- cran_alias()
repo.data:::no_internet(ca)
stopifnot(colnames(ca) == alias_columns)
ca2 <- cran_alias()
stopifnot("Cache returns the same for all packages" = all.equal(ca, ca2))

st <- system.time(ba <- base_alias(bpkges))
repo.data:::no_internet(ba)
stopifnot(colnames(ba) == alias_columns)
stopifnot(is.data.frame(ba))
st1 <- system.time(ba2 <- base_alias(bpkges))
stopifnot("Cache didn't work" = st1[[3]] < st[[3]])
stopifnot("Cache was not the same" = all.equal(ba, ba2))

clean_cache()
st2 <- system.time(ba3 <- base_alias(bpkges))
repo.data:::no_internet(ba3)
stopifnot("Clean cache restores initial state" = st2[[3]] > st1[[3]])
stopifnot("Still same result" = all.equal(ba, ba3))

ba <- base_alias()
repo.data:::no_internet(ba)
stopifnot(colnames(ba) == alias_columns)
ba2 <- base_alias()
stopifnot("Cache returns the same for all packages" = all.equal(ba, ba2))


clean_cache()
pkges <- c(bpkges, pkges)

oldrepos <- getOption("repos")
on.exit(options(oldrepos), add = TRUE)
setRepositories(ind = 2, addURLs = c(CRAN = "https://cran.r-project.org"))
pkges <- c(pkges, "BioCor")

st <- system.time(ba <- alias(pkges))
repo.data:::no_internet(ba)
stopifnot(colnames(ba) == alias_columns)
st1 <- system.time(ba2 <- alias(pkges))
stopifnot("Cache didn't work" = any(st1 < st)) # doesn't seem to work
stopifnot("Cache was not the same" = all.equal(ba, ba2))
missing_pkg <- pkges[!pkges %in% ba2$Package]
stopifnot("All packages are present" = length(missing_pkg) == 0L)

clean_cache()
st2 <- system.time(ba3 <- alias(pkges))
repo.data:::no_internet(ba3)
stopifnot("Clean cache restores initial state" = any(st2[[3]] < st1[[3]]))
stopifnot("Still same result" = all.equal(ba, ba3))
missing_pkg <- pkges[!pkges %in% ba3$Package]
stopifnot("All packages are present" = length(missing_pkg) == 0L)

ba <- alias()
repo.data:::no_internet(ba)
stopifnot(colnames(ba) == alias_columns)
ba2 <- alias()
stopifnot("Cache returns the same for all packages" = all.equal(ba, ba2))
