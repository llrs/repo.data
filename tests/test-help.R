library("repo.data")

# Test that it works
bhpnl <- base_help_pages_not_linked()
repo.data:::no_internet(bhpnl)
bhpwl <- base_help_pages_wo_links()
repo.data:::no_internet(bhpwl)
bhc <- base_help_cliques()
repo.data:::no_internet(bhc)

chpnl <- cran_help_pages_not_linked()
repo.data:::no_internet(chpnl)
chpwl <- cran_help_pages_wo_links()
repo.data:::no_internet(chpwl)
chc <- cran_help_cliques()
repo.data:::no_internet(chc)
