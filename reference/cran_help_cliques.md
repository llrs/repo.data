# Help pages with cliques

Some help pages have links to other pages and they might be linked from
others but they are closed network: there is no link that leads to
different help pages.

## Usage

``` r
cran_help_cliques(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

Return a data.frame of help pages not connected to the network of help
pages. Or NULL if nothing are found. `NA` if not able to collect the
data from CRAN.

## Details

Requires igraph

## See also

Other functions related to CRAN help pages:
[`cran_help_pages_not_linked()`](https://llrs.github.io/repo.data/reference/cran_help_pages_not_linked.md),
[`cran_help_pages_wo_links()`](https://llrs.github.io/repo.data/reference/cran_help_pages_wo_links.md)

## Examples

``` r
chc <- cran_help_cliques("BaseSet")
#> Retrieving base_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#> Retrieving cran_rdxrefs, this might take a bit.
#> Caching results to be faster next call in this session.
#> Warning: Some links are distinct depending on the OS.
head(chc)
#>   from_pkg            from_Rd clique  to_pkg       to_target            to_Rd n
#> 1  BaseSet BaseSet-package.Rd      1 BaseSet         TidySet TidySet-class.Rd 1
#> 2  BaseSet   TidySet-class.Rd      1 BaseSet        activate      activate.Rd 1
#> 3  BaseSet   TidySet-class.Rd      1 BaseSet      add_column    add_column.Rd 1
#> 4  BaseSet   TidySet-class.Rd      1 BaseSet    add_relation  add_relation.Rd 1
#> 5  BaseSet   TidySet-class.Rd      1 BaseSet arrange.TidySet      arrange_.Rd 1
#> 6  BaseSet   TidySet-class.Rd      1 BaseSet       cartesian     cartesian.Rd 1
```
