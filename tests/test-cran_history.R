library("repo.data")

# Test that it works
ch <- cran_history()
repo.data:::no_internet(ch)
