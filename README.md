
<!-- README.md is generated from README.Rmd. Please edit that file -->

# repo.data

<!-- badges: start -->

[![R-CMD-check](https://github.com/llrs/repo.data/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/llrs/repo.data/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/llrs/repo.data/graph/badge.svg)](https://app.codecov.io/gh/llrs/repo.data)
<!-- badges: end -->

The goal of repo.data is to make repository data accessible. Mainly it
consumes existing data but the idea is to also generate it.

When a function is specific of a repository it will start with its name:
`cran_` or `bioc_`. Some functions have their equivalent for all
repositories that provide this information (CRAN and Bioconductor that
I’m aware of).

## Installation

From CRAN:

``` r
install.packages("repo.data")
```

You can install the development version of repo.data like so:

``` r
remotes::install_github("llrs/repo.data")
```

## Example

We can get a data.frame of all packages on CRAN archive:

``` r
library(repo.data)
#> 
#> Attaching package: 'repo.data'
#> The following object is masked from 'package:stats':
#> 
#>     alias
ca <- cran_archive()
#> Warning: There are 4 packages both archived and published
#> This indicate manual CRAN intervention.
head(ca)
#>     Package            Datetime Version   User    Size   Status
#> 1 a11yShiny 2026-03-30 21:20:21   0.1.3 ligges   71907  current
#> 2        A3 2013-02-07 10:00:29   0.9.1 hornik   45252 archived
#> 3        A3 2013-03-26 19:58:40   0.9.2 ligges   45907 archived
#> 4        A3 2015-08-16 23:05:54   1.0.0 hornik   42810 archived
#> 5       a5R 2026-03-16 20:10:23   0.2.0 ligges 3685016 archived
#> 6       a5R 2026-03-26 13:30:08   0.3.1 ligges 3706043  current
```

We can also check CRAN comments about the packages on its archive:

``` r
cc <- cran_comments()
#> Downloading and caching CRAN's comments for this session.
head(cc)
#>    package
#> 1       A3
#> 2    aaSEA
#> 3      aba
#> 4   abbyyR
#> 5   abcADM
#> 6 abcdeFBA
#>                                                                          comment
#> 1         Archived on 2025-06-13 as issues were not corrected despite reminders.
#> 2 Archived on 2022-06-21 as check problems were not corrected despite reminders.
#> 3           Archived on 2022-03-27 as check problems were not corrected in time.
#> 4                            Archived on 2023-11-03 at the maintainer's request.
#> 5                   Archived on 2023-03-02 as issues were not corrected in time.
#> 6           Archived on 2022-03-07 as check problems were not corrected in time.
#>         date   action
#> 1 2025-06-13 archived
#> 2 2022-06-21 archived
#> 3 2022-03-27 archived
#> 4 2023-11-03 archived
#> 5 2023-03-02 archived
#> 6 2022-03-07 archived
```

Or estimate the last date of update of our packages, by the information
on the session info or a data.frame:

``` r
cran_session(session = sessionInfo())
#> [1] "2026-03-26 17:30:10 CET"
ip <- installed.packages()
cran_date(ip)
#> Warning: Some packages are not currently available. Omitting packages:
#> 'annotate', 'AnnotationDbi', 'Biobase', 'BiocGenerics', 'BioCor', 'BiocParallel', 'BiocVersion', 'Biostrings', 'cransays', 'GSEABase', 'IRanges', 'KEGGREST', 'rotemplate', 'rutils', 'S4Vectors', 'Seqinfo', 'XVector'.
#> [1] "2026-04-04 10:00:06 CEST"
```

## Related packages

Other packages and related analysis :

- Task views: <https://github.com/epiverse-connect/ctv-analysis/>
- static packages: [pkgstats](https://docs.ropensci.org/pkgstats/)
- Bioconductor: biopkgtools
- R-universe: universe
- [cranly](https://cran.r-project.org/package=cranly): About package
  dependencies and authors of packages.
- [versions](https://github.com/goldingn/versions): A package about
  installing packages versions. `install.dates()` requires a CRAN date,
  if you are unsure you can use `cran_date()` to estimate it given a
  `library()` or a `sessionInfo` report.
- [checkpoint](https://cran.r-project.org/package=checkpoint) provides
  tools to ensure the results of R code are repeatable over time.

## History

This package comes from the analysis on CRAN data on <https://llrs.dev>
