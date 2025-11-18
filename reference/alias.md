# Links

Retrieve links of repository packages to other packages' documentation.

## Usage

``` r
alias(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with three columns: Package, Source and Target. NA if not
able to collect the data from the repository.

## See also

Other alias:
[`base_alias()`](https://llrs.github.io/repo.data/reference/base_alias.md),
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md)

## Examples

``` r
oldrepos <- getOption("repos")
setRepositories(ind = c(1, 2), addURLs = "https://cran.r-project.org")
head(alias(c("ggplot2", "BiocCheck")))
#> Retrieving aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#>   Package   Source         Target
#> 1 ggplot2 Coord.Rd          Coord
#> 2 ggplot2 Coord.Rd CoordCartesian
#> 3 ggplot2 Coord.Rd     CoordFixed
#> 4 ggplot2 Coord.Rd      CoordFlip
#> 5 ggplot2 Coord.Rd       CoordMap
#> 6 ggplot2 Coord.Rd     CoordPolar

# Clean  up
options(repos = oldrepos)
```
