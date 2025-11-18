# CRAN's alias

Retrieve alias available on CRAN.

## Usage

``` r
cran_alias(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with three columns: Package, Source and Target. `NA` if not
able to collect the data from CRAN.

## See also

The raw source of the data is:
[`CRAN_aliases_db()`](https://rdrr.io/r/tools/CRANtools.html).

Other alias:
[`alias()`](https://llrs.github.io/repo.data/reference/alias.md),
[`base_alias()`](https://llrs.github.io/repo.data/reference/base_alias.md)

Other meta info from CRAN:
[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md),
[`cran_history()`](https://llrs.github.io/repo.data/reference/cran_history.md),
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
ca <- cran_alias("BWStest")
#> Retrieving cran_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
head(ca)
#>   Package             Source          Target
#> 1 BWStest BWStest-package.Rd BWStest-package
#> 2 BWStest            NEWS.Rd    BWStest-NEWS
#> 3 BWStest         bws_cdf.Rd         bws_cdf
#> 4 BWStest        bws_stat.Rd        bws_stat
#> 5 BWStest        bws_test.Rd        bws_test
#> 6 BWStest    murakami_cdf.Rd    murakami_cdf
```
