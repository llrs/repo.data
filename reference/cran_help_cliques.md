# Help pages with cliques

Some help pages have links to other pages and they might be linked from
others but they are closed network: there is no link that leads to
different help pages. Each group of linked help pages is a clique.

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

The first clique is the biggest one. You might want to check if others
cliques can be connected to this one.

Requires igraph.

## See also

Other functions related to CRAN help pages:
[`cran_help_pages_not_linked()`](https://llrs.github.io/repo.data/reference/cran_help_pages_not_linked.md),
[`cran_help_pages_wo_links()`](https://llrs.github.io/repo.data/reference/cran_help_pages_wo_links.md)

## Examples

``` r
chc <- cran_help_cliques("BaseSet")
#> Retrieving cran_rdxrefs, this might take a bit.
#> Caching results to be faster next call in this session.
#> Retrieving base_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#> Warning: Packages with targets not present in a OS:
#> ‘base’, ‘parallel’
#> Warning: Package has targets not present in a OS:
#> ‘sfsmisc’
#> Warning: Some links are distinct depending on the OS.
table(chc$clique)
#> 
#>    1    2 
#> 1923    2 
chc[chc$clique != 1L, ]
#>      from_pkg        from_Rd clique  to_pkg          to_Rd n
#> 1924  BaseSet cardinality.Rd      2 BaseSet        size.Rd 1
#> 1925  BaseSet        size.Rd      2 BaseSet cardinality.Rd 1
```
