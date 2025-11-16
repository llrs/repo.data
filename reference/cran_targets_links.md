# Links between help pages by target

Explore the relationship between CRAN packages and other help pages by
the target they use.

## Usage

``` r
cran_targets_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_target,
to_Rd, n (Number of links).

## See also

Other links from CRAN:
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`cran_pages_links()`](https://llrs.github.io/repo.data/reference/cran_pages_links.md),
[`cran_pkges_links()`](https://llrs.github.io/repo.data/reference/cran_pkges_links.md)

## Examples

``` r
ctl <- cran_targets_links("BaseSet")
head(ctl)
#>   from_pkg            from_Rd  to_pkg       to_target            to_Rd n
#> 1  BaseSet BaseSet-package.Rd BaseSet         TidySet TidySet-class.Rd 1
#> 2  BaseSet   TidySet-class.Rd BaseSet        activate      activate.Rd 1
#> 3  BaseSet   TidySet-class.Rd BaseSet      add_column    add_column.Rd 1
#> 4  BaseSet   TidySet-class.Rd BaseSet    add_relation  add_relation.Rd 1
#> 5  BaseSet   TidySet-class.Rd BaseSet arrange.TidySet      arrange_.Rd 1
#> 6  BaseSet   TidySet-class.Rd BaseSet       cartesian     cartesian.Rd 1
```
