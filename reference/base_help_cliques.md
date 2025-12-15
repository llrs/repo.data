# Help pages with cliques

Some help pages have links to and from but they are closed networks.

## Usage

``` r
base_help_cliques()
```

## Value

Return a data.frame of help pages not connected to the network of help
pages. `NA` if not able to collect the data from CRAN.

## Details

Requires igraph

## See also

Other functions related to BASE help pages:
[`base_help_pages_not_linked()`](https://llrs.github.io/repo.data/reference/base_help_pages_not_linked.md),
[`base_help_pages_wo_links()`](https://llrs.github.io/repo.data/reference/base_help_pages_wo_links.md)

## Examples

``` r
# \donttest{
if (requireNamespace("igraph", quietly = TRUE)) {
    base_help_cliques()
}
#> Retrieving base_rdxrefs, this might take a bit.
#> Caching results to be faster next call in this session.
#> Warning: Some pages point to different places according to the OS.
#> Warning: Some links are distinct depending on the OS.
#>   from_pkg          from_Rd clique to_pkg            to_Rd n
#> 1     grid absolute.size.Rd      1   grid  widthDetails.Rd 1
#> 2     grid  widthDetails.Rd      1   grid absolute.size.Rd 1
#> 3     grid    gridCoords.Rd      2   grid    grobCoords.Rd 1
#> 4     grid    grobCoords.Rd      2   grid    gridCoords.Rd 1
#> 5    tools    HTMLheader.Rd      3   <NA>             <NA> 0
#> 6    tools        toHTML.Rd      3  tools    HTMLheader.Rd 2
# }
```
