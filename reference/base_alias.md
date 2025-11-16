# Base R's alias

Retrieve alias available on R.

## Usage

``` r
base_alias(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with three columns: Package, Source and Target. `NA` if not
able to collect the data from CRAN.

## See also

The raw source of the data is:
[`base_aliases_db()`](https://rdrr.io/r/tools/basetools.html).

Other alias:
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md)

## Examples

``` r
# \donttest{
ba <- base_alias()
#> Retrieving base_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#> Warning: Packages ‘base’, ‘parallel’ have targets not present in a OS.
head(ba)
#>   Package        Source Target
#> 1    base Arithmetic.Rd      +
#> 2    base Arithmetic.Rd      -
#> 3    base Arithmetic.Rd      *
#> 4    base Arithmetic.Rd     **
#> 5    base Arithmetic.Rd      /
#> 6    base Arithmetic.Rd      ^
# }
```
