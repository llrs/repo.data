library("repo.data")
pkgs <- c("BaseSet", "experDesign")

st <- system.time(ca <- cran_actions(pkgs))
repo.data:::no_internet(ca)
st2 <- system.time(ca2 <- cran_actions(pkgs))
stopifnot("Cache didn't work" = any(st2 < st))
stopifnot("Cache didn't work" = identical(ca, ca2))
