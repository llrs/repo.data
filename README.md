
<!-- README.md is generated from README.Rmd. Please edit that file -->

# repo.data

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/repo.data)](https://CRAN.R-project.org/package=repo.data)
<!-- badges: end -->

The goal of repo.data is to make repository data accessible. Mainly it
consumes existing data but the idea is to also generate it.

## Installation

You can install the development version of repo.data like so:

``` r
remotes::install_github("llrs/repo.data")
```

## Example

We can get a data.frame of all packages on CRAN archive:

``` r
library(repo.data)
ca <- cran_archive()
head(ca)
#>         package      published_date version cran_team   size   status
#> 1            A3 2013-02-07 09:00:29   0.9.1    hornik  45252 archived
#> 2            A3 2013-03-26 18:58:40   0.9.2    ligges  45907 archived
#> 3            A3 2015-08-16 21:05:54   1.0.0    hornik  42810  current
#> 4 AalenJohansen 2023-03-01 10:42:11     1.0    ligges 165057  current
#> 5          aaMI 2005-06-24 15:55:17   1.0-0      root   2968 archived
#> 6          aaMI 2005-10-17 19:24:18   1.0-1      root   3487 archived
```

We can also check CRAN comments about the packages on its archive:

``` r
cc <- cran_comments()
head(cc)
#>       package
#> 1       aaSEA
#> 2         aba
#> 3      abbyyR
#> 4      abcADM
#> 5    abcdeFBA
#> 6 ABCExtremes
#>                                                                                        comment
#> 1               Archived on 2022-06-21 as check problems were not corrected despite reminders.
#> 2                         Archived on 2022-03-27 as check problems were not corrected in time.
#> 3                                          Archived on 2023-11-03 at the maintainer's request.
#> 4                                 Archived on 2023-03-02 as issues were not corrected in time.
#> 5                         Archived on 2022-03-07 as check problems were not corrected in time.
#> 6 Archived on 2015-06-19 as incomplete maintainer address was not corrected despite reminders.
#>         date   action
#> 1 2022-06-21 archived
#> 2 2022-03-27 archived
#> 3 2023-11-03 archived
#> 4 2023-03-02 archived
#> 5 2022-03-07 archived
#> 6 2015-06-19 archived
```

Or estimate the last date of update of our packages, by the information
on the session info or a data.frame:

``` r
cran_session(session = sessionInfo())
#> [1] "2024-11-08"
ip <- installed.packages()
cran_date(ip)
#> [1] "2024-12-08"
```

## Related packages

Other packages and related analysis :

- Task views: <https://github.com/epiverse-connect/ctv-analysis/>
- static packages: [pkgstats](https://docs.ropensci.org/pkgstats)
- Bioconductor: biopkgtools
- R-universe: universe
- [cranly](https://cran.r-project.org/package=cranly): About package
  dependencies and authors of packages.

## History

This package comes from the analysis on CRAN data on <https://llrs.dev>
