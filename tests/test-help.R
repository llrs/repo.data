library("repo.data")
pkgs <- c("tools", "utils")

# Test that it works
bhpnl <- base_help_pages_not_linked()
repo.data:::no_internet(bhpnl)
stopifnot("Column names not matching" = colnames(bhpnl) == c("Package", "Source"))
stopifnot("No data on base_help_pages_not_linked" = as.logical(NROW(bhpnl)))

bhpwl <- base_help_pages_wo_links()
repo.data:::no_internet(bhpwl)
stopifnot("No data on base_help_pages_wo_links" = as.logical(NROW(bhpwl)))
stopifnot("Column names not matching" = colnames(bhpwl) == c("Package", "Source"))

bhc <- base_help_cliques()
repo.data:::no_internet(bhc)
stopifnot("Column names not matching" = colnames(bhc) == c("from_pkg", "from_Rd", "clique", "to_pkg", "to_Rd", "n"))
stopifnot("No data on base_help_cliques" = as.logical(NROW(bhc)))
stopifnot("No links == 0L" = !anyNA(bhc$n))

# CRAN
pkgs <- c("BaseSet", "experDesign")
chpnl <- cran_help_pages_not_linked(pkgs)
repo.data:::no_internet(chpnl)
stopifnot("Column names not matching" = colnames(chpnl) == c("Package", "Source"))
stopifnot("No data on cran_help_pages_not_linked" = as.logical(NROW(chpnl)))

chpwl <- cran_help_pages_wo_links(pkgs)
repo.data:::no_internet(chpwl)
stopifnot("Column names not matching" = colnames(chpwl) == c("Package", "Source"))
stopifnot("No data on cran_help_pages_wo_links" = as.logical(NROW(chpwl)))

chc <- cran_help_cliques(pkgs)
repo.data:::no_internet(chc)
stopifnot("Column names not matching" =
              colnames(chc) == c("from_pkg", "from_Rd", "clique", "to_pkg",
                                 "to_Rd", "n"))
stopifnot("No data on cran_help_cliques" = as.logical(NROW(chc)))


chc_BaseSet <- cran_help_cliques("BaseSet")
repo.data:::no_internet(chc_BaseSet)
stopifnot(unique(chc$clique) >= 1L)

# chc_pkgs <- cran_help_cliques(c("experDesign", "BaseSet"))
# repo.data:::no_internet(chc_pkgs)
# stopifnot(unique(chc$clique) >= 1L)
# stopifnot("More packages do not lead to more cliques" = nrow(chc_pkgs) > nrow(chc_BaseSet))

chplwd <- cran_help_pages_links_wo_deps(pkgs)
repo.data:::no_internet(chplwd)
stopifnot(colnames(chplwd) == c("Package", "Source", "Anchor", "Target"))

