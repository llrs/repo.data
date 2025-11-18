# Links

Retrieve links of repository packages to other packages' documentation.

## Usage

``` r
links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with the links on packages. It has 4 columns: Package,
Anchor, Target and Source. NA if not able to collect the data from the
repository.

## See also

Other links from CRAN:
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`cran_pages_links()`](https://llrs.github.io/repo.data/reference/cran_pages_links.md),
[`cran_pkges_links()`](https://llrs.github.io/repo.data/reference/cran_pkges_links.md),
[`cran_targets_links()`](https://llrs.github.io/repo.data/reference/cran_targets_links.md)

Other meta info from CRAN:
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md),
[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md),
[`cran_history()`](https://llrs.github.io/repo.data/reference/cran_history.md),
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md)

## Examples

``` r
oldrepos <- getOption("repos")
setRepositories(ind = c(1, 2), addURLs = "https://cran.r-project.org")
head(links(c("ggplot2", "BiocCheck")))
#>   Package   Source          Anchor         Target
#> 1 ggplot2 Coord.Rd        =ggproto      ggproto()
#> 2 ggplot2 Coord.Rd                         Layout
#> 3 ggplot2 Coord.Rd =complete_theme complete theme
#> 4 ggplot2 Coord.Rd =complete_theme complete theme
#> 5 ggplot2 Coord.Rd =complete_theme complete theme
#> 6 ggplot2 Coord.Rd =complete_theme complete theme

# Clean  up
options(repos = oldrepos)
```
