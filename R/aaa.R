pkg_state <- new.env(parent = emptyenv())

PACKAGE_FIELDS <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")

BASE <- rownames(installed.packages(priority = "base"))
