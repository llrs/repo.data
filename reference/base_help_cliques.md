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
[`base_help_pages_not_linked()`](https://repo.data.llrs.dev/reference/base_help_pages_not_linked.md),
[`base_help_pages_wo_links()`](https://repo.data.llrs.dev/reference/base_help_pages_wo_links.md)

## Examples

``` r
# \donttest{
if (requireNamespace("igraph", quietly = TRUE)) {
  base_help_cliques()
}
#> Downloading and caching R's xrefs for this session.
#> Warning: Some links are distinct depending on the OS.
#>      from_pkg                  from_Rd clique    to_pkg                 to_Rd n
#> 1        base            Arithmetic.Rd      1      base       groupGeneric.Rd 1
#> 2        base            Comparison.Rd      1      base              Logic.Rd 1
#> 3        base            Comparison.Rd      1      base       groupGeneric.Rd 1
#> 4        base                 Logic.Rd      1      base       groupGeneric.Rd 1
#> 5        base                Syntax.Rd      1      base              Logic.Rd 1
#> 6        base          groupGeneric.Rd      1      <NA>                  <NA> 0
#> 7        base             identical.Rd      1      base              Logic.Rd 1
#> 8        base               logical.Rd      1      base              Logic.Rd 1
#> 9        base                   raw.Rd      1      base              Logic.Rd 1
#> 10       base                 which.Rd      1      base              Logic.Rd 1
#> 11       base                 Rhome.Rd      2     utils              RHOME.Rd 1
#> 12      utils                 RHOME.Rd      2      <NA>                  <NA> 0
#> 13       base               Special.Rd      3     utils              combn.Rd 1
#> 14       base           expand.grid.Rd      3     utils              combn.Rd 1
#> 15      utils                 combn.Rd      3      <NA>                  <NA> 0
#> 16       base               Version.Rd      4     utils        sessionInfo.Rd 1
#> 17      utils           sessionInfo.Rd      4      <NA>                  <NA> 0
#> 18       base            as.POSIXlt.Rd      5      base           strptime.Rd 1
#> 19       base              strptime.Rd      5      <NA>                  <NA> 0
#> 20       base                  attr.Rd      6      base               name.Rd 1
#> 21       base            attributes.Rd      6      base               name.Rd 1
#> 22       base                  body.Rd      6      base               name.Rd 1
#> 23       base                  call.Rd      6      base               name.Rd 1
#> 24       base                  name.Rd      6      <NA>                  <NA> 0
#> 25       base             structure.Rd      6      base               name.Rd 1
#> 26       base                 cbind.Rd      7   methods             cbind2.Rd 1
#> 27    methods                cbind2.Rd      7      <NA>                  <NA> 0
#> 28       base                 class.Rd      8   methods       Introduction.Rd 1
#> 29       base                 class.Rd      8   methods                 is.Rd 1
#> 30       base                  isS4.Rd      8   methods    Classes_Details.Rd 1
#> 31       base                  isS4.Rd      8   methods       Introduction.Rd 1
#> 32    methods       Classes_Details.Rd      8      <NA>                  <NA> 0
#> 33    methods          Introduction.Rd      8      <NA>                  <NA> 0
#> 34    methods                    is.Rd      8      <NA>                  <NA> 0
#> 35      utils               methods.Rd      8   methods       Introduction.Rd 1
#> 36       base                 debug.Rd      9   methods       RMethodUtils.Rd 1
#> 37    methods          RMethodUtils.Rd      9      <NA>                  <NA> 0
#> 38       base                  dots.Rd     10   methods        dotsMethods.Rd 1
#> 39    methods           dotsMethods.Rd     10      <NA>                  <NA> 0
#> 40       base                   get.Rd     11     utils        getAnywhere.Rd 1
#> 41       base                   get.Rd     11     utils   getFromNamespace.Rd 1
#> 42      utils           getAnywhere.Rd     11      <NA>                  <NA> 0
#> 43      utils      getFromNamespace.Rd     11      <NA>                  <NA> 0
#> 44       base                  mode.Rd     12     utils       type.convert.Rd 1
#> 45      utils          type.convert.Rd     12      <NA>                  <NA> 0
#> 46       base                 print.Rd     13     tools   print.via.format.Rd 1
#> 47      tools      print.via.format.Rd     13      <NA>                  <NA> 0
#> 48  grDevices             axisTicks.Rd     14  graphics               axis.Rd 2
#> 49  grDevices             axisTicks.Rd     14  graphics            axTicks.Rd 1
#> 50  grDevices             axisTicks.Rd     14  graphics                par.Rd 2
#> 51   graphics               axTicks.Rd     14 grDevices          axisTicks.Rd 1
#> 52   graphics                  axis.Rd     14      <NA>                  <NA> 0
#> 53   graphics                   par.Rd     14      <NA>                  <NA> 0
#> 54  grDevices                   pdf.Rd     15      grid        stringWidth.Rd 1
#> 55       grid           stringWidth.Rd     15      <NA>                  <NA> 0
#> 56  grDevices           pretty.Date.Rd     16      <NA>                  <NA> 0
#> 57   graphics          axis.POSIXct.Rd     16 grDevices        pretty.Date.Rd 1
#> 58  grDevices               Hershey.Rd     17      <NA>                  <NA> 0
#> 59   graphics                  text.Rd     17 grDevices            Hershey.Rd 1
#> 60    methods        S4groupGeneric.Rd     18      <NA>                  <NA> 0
#> 61    methods    nonStructure-class.Rd     18   methods     S4groupGeneric.Rd 2
#> 62    methods             setMethod.Rd     18   methods     S4groupGeneric.Rd 1
#> 63       base             proc.time.Rd     19      <NA>                  <NA> 0
#> 64       base           system.time.Rd     19      <NA>                  <NA> 0
#> 65   parallel              sendData.Rd     19      base        system.time.Rd 1
#> 66   parallel              sendData.Rd     19      base          proc.time.Rd 1
#> 67      stats    influence.measures.Rd     20      <NA>                  <NA> 0
#> 68      stats          lm.influence.Rd     20     stats influence.measures.Rd 1
#> 69      stats               ls.diag.Rd     20     stats influence.measures.Rd 1
#> 70      stats               plot.lm.Rd     20     stats influence.measures.Rd 1
#> 71    splines                    bs.Rd     21      <NA>                  <NA> 0
#> 72      stats           model.frame.Rd     21   splines                 bs.Rd 1
#> 73      stats   power.free1way.test.Rd     22     stats           simulate.Rd 1
#> 74      stats              simulate.Rd     22      <NA>                  <NA> 0
#> 75      stats              free1way.Rd     23      <NA>                  <NA> 0
#> 76      stats                ppplot.Rd     23     stats           free1way.Rd 2
#> 77    splines          interpSpline.Rd     24      <NA>                  <NA> 0
#> 78    splines        periodicSpline.Rd     24      <NA>                  <NA> 0
#> 79      stats             splinefun.Rd     24   splines       interpSpline.Rd 1
#> 80      stats             splinefun.Rd     24   splines     periodicSpline.Rd 1
#> 81      stats                  coef.Rd     25      <NA>                  <NA> 0
#> 82     stats4          coef-methods.Rd     25     stats               coef.Rd 1
#> 83      stats               confint.Rd     26      <NA>                  <NA> 0
#> 84     stats4       confint-methods.Rd     26     stats            confint.Rd 1
#> 85      stats                logLik.Rd     27      <NA>                  <NA> 0
#> 86     stats4        logLik-methods.Rd     27     stats             logLik.Rd 1
#> 87      stats               profile.Rd     28      <NA>                  <NA> 0
#> 88     stats4       profile-methods.Rd     28     stats            profile.Rd 1
#> 89      stats                update.Rd     29      <NA>                  <NA> 0
#> 90     stats4        update-methods.Rd     29     stats             update.Rd 1
#> 91      stats                  vcov.Rd     30      <NA>                  <NA> 0
#> 92     stats4          vcov-methods.Rd     30     stats               vcov.Rd 1
#> 93   parallel          clusterApply.Rd     31      <NA>                  <NA> 0
#> 94   parallel         unix/mclapply.Rd     31      <NA>                  <NA> 0
#> 95      tools check_packages_in_dir.Rd     31  parallel      unix/mclapply.Rd 2
#> 96      tools check_packages_in_dir.Rd     31  parallel       clusterApply.Rd 2
#> 97      tools         buildVignette.Rd     32      <NA>                  <NA> 0
#> 98      utils                Sweave.Rd     32     tools      buildVignette.Rd 1
#> 99      utils   SweaveGetSourceName.Rd     32     utils             Sweave.Rd 1
#> 100     tools          RdTextFilter.Rd     33      <NA>                  <NA> 0
#> 101     utils          aspell-utils.Rd     33     tools       RdTextFilter.Rd 1
#> 102     tools               userdir.Rd     34      <NA>                  <NA> 0
#> 103     utils    available.packages.Rd     34     tools            userdir.Rd 1
#> 104     utils    installed.packages.Rd     34     tools            userdir.Rd 1
#> 105     tools              bibstyle.Rd     35      <NA>                  <NA> 0
#> 106     tools          loadRdMacros.Rd     35      <NA>                  <NA> 0
#> 107     utils              bibentry.Rd     35     tools       loadRdMacros.Rd 1
#> 108     utils              bibentry.Rd     35     tools           bibstyle.Rd 1
#> 109     stats                    ts.Rd     36      <NA>                  <NA> 0
#> 110     utils                  head.Rd     36     stats                 ts.Rd 1
#> 111   methods        getPackageName.Rd     37      <NA>                  <NA> 0
#> 112     utils           packageName.Rd     37   methods     getPackageName.Rd 1
# }
```
