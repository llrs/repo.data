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
[`cran_help_pages_not_linked()`](https://repo.data.llrs.dev/reference/cran_help_pages_not_linked.md),
[`cran_help_pages_wo_links()`](https://repo.data.llrs.dev/reference/cran_help_pages_wo_links.md)

## Examples

``` r
chc <- cran_help_cliques("BaseSet")
#> Downloading and caching CRAN's packages xrefs for this session.
#> Downloading and caching base R's aliases for this session.
#> Warning: Packages with targets not present in a OS:
#> ‘base’, ‘grDevices’, ‘parallel’
#> Warning: Packages with targets not present in a OS:
#> ‘sfsmisc’
#> Warning: Some links are distinct depending on the OS.
if (!is.null(dim(chc))) {
   table(chc$clique)
}
#> 
#>    1    2 
#> 1938    2 
chc[chc$clique != 1L, ]
#>      from_pkg        from_Rd clique  to_pkg          to_Rd n
#> 1939  BaseSet cardinality.Rd      2 BaseSet        size.Rd 1
#> 1940  BaseSet        size.Rd      2 BaseSet cardinality.Rd 1
```
