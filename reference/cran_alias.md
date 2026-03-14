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

Other alias: [`alias()`](https://repo.data.llrs.dev/reference/alias.md),
[`base_alias()`](https://repo.data.llrs.dev/reference/base_alias.md)

Other meta info from CRAN:
[`cran_archive()`](https://repo.data.llrs.dev/reference/cran_archive.md),
[`cran_comments()`](https://repo.data.llrs.dev/reference/cran_comments.md),
[`cran_history()`](https://repo.data.llrs.dev/reference/cran_history.md),
[`cran_links()`](https://repo.data.llrs.dev/reference/cran_links.md),
[`links()`](https://repo.data.llrs.dev/reference/links.md)

## Examples

``` r
ca <- cran_alias("BWStest")
#> Downloading and caching CRAN aliases for this session.
head(ca)
#>   Package             Source          Target
#> 1 BWStest BWStest-package.Rd BWStest-package
#> 2 BWStest            NEWS.Rd    BWStest-NEWS
#> 3 BWStest         bws_cdf.Rd         bws_cdf
#> 4 BWStest        bws_stat.Rd        bws_stat
#> 5 BWStest        bws_test.Rd        bws_test
#> 6 BWStest    murakami_cdf.Rd    murakami_cdf
```
