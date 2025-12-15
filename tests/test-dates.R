library("repo.data")

ip <- data.frame(Package = c("A3", "AER"), Version = c("1.0.0", "1.2-15"))
repo.data:::no_internet(ip)
cd <- cran_date(ip)
stopifnot(is(cd, "POSIXt"))
cs <- cran_session()
repo.data:::no_internet(cs)
stopifnot(is(cs, "POSIXt"))
