
<!-- README.md is generated from README.Rmd. Please edit that file -->

# repo.data

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/repo.data)](https://CRAN.R-project.org/package=repo.data)
[![R-CMD-check](https://github.com/llrs/repo.data/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/llrs/repo.data/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of repo.data is to make repository data accessible. Mainly it
consumes existing data but the idea is to also generate it.

When a function is specific of a repository it will start with its name:
`cran_` or `bioc_`.

## Installation

You can install the development version of repo.data like so:

``` r
remotes::install_github("llrs/repo.data")
```

## Example

We can get a data.frame of all packages on CRAN archive:

``` r
library(repo.data)
#> Warning: Altering install.packages behavior!
ca <- cran_archive()
#> Warning: There are 5 packages both archived and published
#> This indicate manual CRAN intervention.
head(ca)
#> [1] Package  Datetime Version  User     Size     Status  
#> <0 rows> (or 0-length row.names)
```

We can also check CRAN comments about the packages on its archive:

``` r
cc <- cran_comments()
#> Retrieving comments, this might take a bit.
#> Caching results to be faster next call in this session.
head(cc)
#>    package
#> 1       A3
#> 2    aaSEA
#> 3      aba
#> 4   abbyyR
#> 5   abcADM
#> 6 abcdeFBA
#>                                                                          comment
#> 1         Archived on 2025-06-13 as issues were not corrected despite reminders.
#> 2 Archived on 2022-06-21 as check problems were not corrected despite reminders.
#> 3           Archived on 2022-03-27 as check problems were not corrected in time.
#> 4                            Archived on 2023-11-03 at the maintainer's request.
#> 5                   Archived on 2023-03-02 as issues were not corrected in time.
#> 6           Archived on 2022-03-07 as check problems were not corrected in time.
#>         date   action
#> 1 2025-06-13 archived
#> 2 2022-06-21 archived
#> 3 2022-03-27 archived
#> 4 2023-11-03 archived
#> 5 2023-03-02 archived
#> 6 2022-03-07 archived
```

Or estimate the last date of update of our packages, by the information
on the session info or a data.frame:

``` r
cran_session(session = sessionInfo())
#> Warning in cran_archive(versions[, "Package"]): Omitting packages repo.data.
#> Maybe they were not on CRAN?
#> [1] "2025-06-18"
ip <- installed.packages()
cran_date(ip)
#> Warning in cran_archive(versions[, "Package"]): Omitting packages repo.data, airway, alabaster.base, alabaster.matrix, alabaster.ranges, alabaster.sce, alabaster.schemas, alabaster.se, annotate, AnnotationDbi, AnnotationFilter, AnnotationHub, assorthead, Biobase, BiocFileCache, BiocGenerics, BiocIO, BioCor, BiocParallel, BiocPkgTools, BiocStyle, BiocVersion, biocViews, biomformat, Biostrings, cransays, DelayedArray, DESeq2, ensembldb, ExperimentHub, fgsea, GenomeInfoDb, GenomeInfoDbData, GenomicAlignments, GenomicFeatures, GenomicRanges, GO.db, GOSemSim, GSEABase, gypsum, h5mread, HDF5Array, IRanges, KEGGREST, MatrixGenerics, microshades, org.Hs.eg.db, phyloseq, preprocessCore, ProtGenerics, reactome.db, resios, rhdf5, rhdf5filters, Rhdf5lib, Rhtslib, rostemplate, rotemplate, Rsamtools, rtracklayer, rutils, S4Arrays, S4Vectors, scRNAseq, SingleCellExperiment, SparseArray, SummarizedExperiment, UCSC.utils, XVector.
#> Maybe they were not on CRAN?
#> [1] "2025-06-21"
```

## Related packages

Other packages and related analysis :

- Task views: <https://github.com/epiverse-connect/ctv-analysis/>
- static packages: [pkgstats](https://docs.ropensci.org/pkgstats/)
- Bioconductor: biopkgtools
- R-universe: universe
- [cranly](https://cran.r-project.org/package=cranly): About package
  dependencies and authors of packages.
- [versions](https://github.com/goldingn/versions): A package about
  installing packages versions. `install.dates()` requires a CRAN date,
  if you are unsure you can use `cran_date()` to estimate it given a
  `library()` or a `sessionInfo` report.
- [checkpoint](https://cran.r-project.org/package=checkpoint) provides
  tools to ensure the results of R code are repeatable over time.

## History

This package comes from the analysis on CRAN data on <https://llrs.dev>
