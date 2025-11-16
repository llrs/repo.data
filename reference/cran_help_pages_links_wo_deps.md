# Links without dependencies

On [WRE section "2.5
Cross-references"](https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Cross_002dreferences)
explains that packages shouldn't link to help pages outside the
dependency.

## Usage

``` r
cran_help_pages_links_wo_deps(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame of help pages and links. `NA` if not able to collect the
data from CRAN.

## References

<https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Cross_002dreferences>

## Examples

``` r
evmix <- cran_help_pages_links_wo_deps("evmix")
```
