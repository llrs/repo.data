# repo.data

This vignette is written for concerned package maintainers or users that
want to check their package in relationship with other packages. For
general usage of the other functions check the manual or package index
(a vignette might come too).

## Keeping up with the repositories

Packages required by a package might have their own dependencies with
minimal versions requirements. The maintainers or developers might
wonder what is the oldest version of each recursive package their users
are required to have. This is useful for developing packages that should
remain compatible with old versions of R and packages.

``` r
pd <- package_dependencies("ggeasy")
head(pd)
#>        Name Version    Type   Op Package
#> 1       cli   3.4.0 Imports   >=    <NA>
#> 2 lifecycle   1.0.3 Imports   >=    <NA>
#> 3         R   4.1.0 Depends   >=    <NA>
#> 4     rlang   1.1.7 Imports   >=    <NA>
#> 5     utils    <NA> Imports <NA>    <NA>
#> 6   ggplot2    <NA> Imports <NA>  ggeasy
```

[`package_dependencies()`](https://llrs.github.io/repo.data/reference/package_dependencies.md)
identify the minimal version required for each dependency. If no version
is required by any dependencies `NA` is used.

We can identify packages that are required on a lower version than one
of the dependencies with

``` r
# Discover the requirements that can be upgraded
update_dependencies("ggeasy")
#>       Name Version
#> 1 testthat   3.2.0
```

Increasing these version requirements on
[ggeasy](https://github.com/jonocarroll/ggeasy) won’t affect users as
they already should have these versions installed as required by other
dependencies.

We can also be interested on since when can users install a package.
There can be two possible answers: - Since it was published/release on
the repositories - If the maintainer developers are careful the
requirements might be available earlier.

We can use
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md)
to get those answers:

``` r
package_date("ggeasy")
#>                 Published            deps_available 
#> "2025-06-15 04:40:04 UTC" "2021-05-18 07:05:22 UTC"
```

Why are they important? The first one is important to know if it hasn’t
been updated in a long time. The second one helps estimate if it can be
installed on old systems without updating anything else. If the date the
dependencies are available is closer to the published date, the users
will need to have updated systems and dependencies.

## Improving packages

Help pages are found via alias, when a user press `?word` it searches
for alias. Checking for existing alias might help you to find packages
and reduce the confusion on the help pages.

``` r
alias <- cran_alias(c("fect", "gsynth"))
dup_alias <- duplicated_alias(alias)
head(dup_alias)
#>                     Target Package             Source
#> 1        _gsynth_beta_iter    fect   fect-internal.Rd
#> 2        _gsynth_beta_iter  gsynth gsynth-internal.Rd
#> 3      _gsynth_data_ub_adj    fect   fect-internal.Rd
#> 4      _gsynth_data_ub_adj  gsynth gsynth-internal.Rd
#> 5 _gsynth_fe_ad_covar_iter    fect   fect-internal.Rd
#> 6 _gsynth_fe_ad_covar_iter  gsynth gsynth-internal.Rd
```

For example these two packages have the same alias for the internal
functions but most of them point to the same file.

### Connecting help pages

Often it is helpful to link help pages so that the user can navigate
through the help pages easily. For that we need: - Pages linking to
other pages (`pages_wo_links()`). - Pages are linked from other pages
(`pages_not_linked()`).

``` r
pkg <- "BaseSet"
head(cran_help_pages_wo_links(pkg))
#> Retrieving cran_rdxrefs, this might take a bit.
#> Caching results to be faster next call in this session.
#> Retrieving base_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#> [1] NA
head(cran_help_pages_not_linked(pkg))
#> Warning: Package has targets not present in a OS:
#> 'sfsmisc'
#> Warning: Some links are distinct depending on the OS.
#>   Package      Source
#> 1 BaseSet activate.Rd
#> 2 BaseSet activate.Rd
#> 3 BaseSet activate.Rd
#> 4 BaseSet activate.Rd
#> 5 BaseSet activate.Rd
#> 6 BaseSet activate.Rd
```

In addition to those help pages that are not well connected it could be
that some pages are linked between them without connecting with other
help pages of the package or other packages creating a closed group of
pages. This is know as clique.

To retrieve these help pages forming a clique there is a function to
find them (requires the suggested package igraph).

``` r
cliques <- cran_help_cliques(pkg)
# Number of help pages connected
if (length(cliques) != 1L) {
    table(cliques$n)
}
#> 
#>    1    2    3    4    5    6    7    8    9 
#> 1570  174   34   15   11    7    4    1    1
```

If there is more than one length this would mean some pages not linked
to the rest of the package.

Sometimes even if links exists they might not resolve correctly on the
html version. For example if they link to a help page of a package that
is not on the strong dependency list.

``` r
cran_help_pages_links_wo_deps(pkg)
#> [1] Package Source  Anchor  Target 
#> <0 rows> (or 0-length row.names)
```

If there is some output then the link cannot be resolved correctly if
the other package is not independently installed on the same machine.

## Reproducibility

If you wish to know what packages were available on CRAN on any given
date you can use:

``` r
cs <- cran_snapshot(as.Date("2020-01-31"))
#> Warning: There are 5 packages both archived and published
#> This indicate manual CRAN intervention.
#> Retrieving comments, this might take a bit.
#> Caching results to be faster next call in this session.
nrow(cs)
#> [1] 108453
```

This might be helpful to know what was available on old project and why
some feature of a given package wasn’t used. Maybe it wasn’t available
on a given date!

#### Local versions

While working it might be good to update packages. To decide if it is
needed maybe you’d like to know when were packages last updated on the
system?

``` r
cran_session()
#> [1] "2026-01-26 08:10:10 CET"
```

This uses the
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html) output to
find the date of last installation. Under the hood it uses a function
that given packages and their versions find a date where this was
possible. This is also exported:

``` r
versions <- data.frame(Package = c("dplyr", "Rcpp", "rlang"),
                       Version = c("1.1.4", "0.8.9", NA))
cran_date(versions)
#> [1] "2023-11-17 16:50:03 CET"
```

This is the first date were these packages were at the requested version
number (or available). Currently these packages can have a release with
higher version numbers (this can be easily checked with
[`old.packages()`](https://rdrr.io/r/utils/update.packages.html)).

To answer the original question of this section we can use:

``` r
cran_date(installed.packages())
```

We can be sure that the library was updated on that date or later (if no
local package has been updated since then on CRAN).

#### Risk of being archived

If you ever wonder which packages are at risk of being archived you can
use
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md):

``` r
cd <- cran_doom(bioc = TRUE)
#> Retrieving CRAN_db, this might take a bit.
#> Caching results to be faster next call in this session.
#> Retrieving bioc_available_release, this might take a bit.
#> Caching results to be faster next call in this session.
if (length(cd) != 1L) {
    cd[c("time_till_last", "last_archived", "npackages")]
    knitr::kable(head(cd$details))
}
```

| Package    | Deadline   | type   | repo | n_affected |
|:-----------|:-----------|:-------|:-----|-----------:|
| PMAPscore  | 2026-01-31 | direct | CRAN |         14 |
| scPipeline | 2026-01-31 | direct | CRAN |         12 |
| dGAselID   | 2026-01-31 | direct | CRAN |         11 |
| AutoPipe   | 2026-01-31 | direct | CRAN |         10 |
| cinaR      | 2026-01-31 | direct | CRAN |         10 |
| scRNAtools | 2026-01-31 | direct | CRAN |         10 |

There are website dedicated to track those and provide information about
new version submissions to CRAN to fix those. I participate on the
[cranhaven.org
dashboard](https://www.cranhaven.org/dashboard-at-risk.html) (and
project).

Note that if a package is archived it can be brought back to the
repository.

## Reproducibility

For reproducibility here is the session info:

``` r
sessionInfo()
#> R Under development (unstable) (2026-01-30 r89357)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] repo.data_0.1.5.9000
#> 
#> loaded via a namespace (and not attached):
#>  [1] cli_3.6.5         knitr_1.51        rlang_1.1.7       xfun_0.56        
#>  [5] rversions_3.0.0   textshaping_1.0.4 jsonlite_2.0.0    litedown_0.9     
#>  [9] markdown_2.0      htmltools_0.5.9   ragg_1.5.0        sass_0.4.10      
#> [13] rmarkdown_2.30    evaluate_1.0.5    jquerylib_0.1.4   fastmap_1.2.0    
#> [17] yaml_2.3.12       lifecycle_1.0.5   compiler_4.6.0    igraph_2.2.1     
#> [21] fs_1.6.6          pkgconfig_2.0.3   systemfonts_1.3.1 digest_0.6.39    
#> [25] R6_2.6.1          curl_7.0.0        commonmark_2.0.0  magrittr_2.0.4   
#> [29] bslib_0.10.0      tools_4.6.0       pkgdown_2.2.0     cachem_1.1.0     
#> [33] desc_1.4.3
```
