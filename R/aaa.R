pkg_state <- new.env(parent = emptyenv())

package_fields <- c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")

BASE <- rownames(installed.packages(priority = "base"))
