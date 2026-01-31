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
#> Warning: Some links are distinct depending on the OS.
#>      from_pkg                  from_Rd clique    to_pkg                 to_Rd n
#> 1        base            Arithmetic.Rd      1      base       groupGeneric.Rd 1
#> 2        base            Comparison.Rd      1      base       groupGeneric.Rd 1
#> 3        base            Comparison.Rd      1      base              Logic.Rd 1
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
#> 26       base                 class.Rd      7   methods                 is.Rd 1
#> 27       base                 class.Rd      7   methods       Introduction.Rd 1
#> 28       base                  isS4.Rd      7   methods       Introduction.Rd 1
#> 29       base                  isS4.Rd      7   methods    Classes_Details.Rd 1
#> 30    methods       Classes_Details.Rd      7      <NA>                  <NA> 0
#> 31    methods          Introduction.Rd      7      <NA>                  <NA> 0
#> 32    methods                    is.Rd      7      <NA>                  <NA> 0
#> 33      utils               methods.Rd      7   methods       Introduction.Rd 1
#> 34       base                 debug.Rd      8   methods       RMethodUtils.Rd 1
#> 35    methods          RMethodUtils.Rd      8      <NA>                  <NA> 0
#> 36       base                  dots.Rd      9   methods        dotsMethods.Rd 1
#> 37    methods           dotsMethods.Rd      9      <NA>                  <NA> 0
#> 38       base                   get.Rd     10     utils   getFromNamespace.Rd 1
#> 39       base                   get.Rd     10     utils        getAnywhere.Rd 1
#> 40      utils           getAnywhere.Rd     10      <NA>                  <NA> 0
#> 41      utils      getFromNamespace.Rd     10      <NA>                  <NA> 0
#> 42       base                  mode.Rd     11     utils       type.convert.Rd 1
#> 43      utils          type.convert.Rd     11      <NA>                  <NA> 0
#> 44       base                 print.Rd     12     tools   print.via.format.Rd 1
#> 45      tools      print.via.format.Rd     12      <NA>                  <NA> 0
#> 46       base               shQuote.Rd     13      base      windows/shell.Rd 1
#> 47       base               shQuote.Rd     13      base             system.Rd 1
#> 48       base                system.Rd     13      <NA>                  <NA> 0
#> 49       base         windows/shell.Rd     13      <NA>                  <NA> 0
#> 50  grDevices             axisTicks.Rd     14  graphics                par.Rd 2
#> 51  grDevices             axisTicks.Rd     14  graphics            axTicks.Rd 1
#> 52  grDevices             axisTicks.Rd     14  graphics               axis.Rd 2
#> 53   graphics               axTicks.Rd     14 grDevices          axisTicks.Rd 1
#> 54   graphics                  axis.Rd     14      <NA>                  <NA> 0
#> 55   graphics                   par.Rd     14      <NA>                  <NA> 0
#> 56  grDevices            dev2bitmap.Rd     15 grDevices           savePlot.Rd 1
#> 57  grDevices              savePlot.Rd     15      <NA>                  <NA> 0
#> 58  grDevices                   pdf.Rd     16      grid        stringWidth.Rd 1
#> 59       grid           stringWidth.Rd     16      <NA>                  <NA> 0
#> 60  grDevices                   png.Rd     17      <NA>                  <NA> 0
#> 61  grDevices                   x11.Rd     17 grDevices                png.Rd 1
#> 62  grDevices           pretty.Date.Rd     18      <NA>                  <NA> 0
#> 63   graphics          axis.POSIXct.Rd     18 grDevices        pretty.Date.Rd 1
#> 64  grDevices               Hershey.Rd     19      <NA>                  <NA> 0
#> 65   graphics                  text.Rd     19 grDevices            Hershey.Rd 1
#> 66    methods        S4groupGeneric.Rd     20      <NA>                  <NA> 0
#> 67    methods    nonStructure-class.Rd     20   methods     S4groupGeneric.Rd 2
#> 68    methods             setMethod.Rd     20   methods     S4groupGeneric.Rd 1
#> 69   parallel             RngStream.Rd     21  parallel               pvec.Rd 1
#> 70   parallel                  pvec.Rd     21      <NA>                  <NA> 0
#> 71       base             proc.time.Rd     22      <NA>                  <NA> 0
#> 72       base           system.time.Rd     22      <NA>                  <NA> 0
#> 73   parallel              sendData.Rd     22      base          proc.time.Rd 1
#> 74   parallel              sendData.Rd     22      base        system.time.Rd 1
#> 75   parallel         unix/mclapply.Rd     23  parallel          unix/pvec.Rd 1
#> 76   parallel       unix/mcparallel.Rd     23  parallel          unix/pvec.Rd 1
#> 77   parallel       unix/mcparallel.Rd     23  parallel      unix/mclapply.Rd 1
#> 78   parallel             unix/pvec.Rd     23  parallel      unix/mclapply.Rd 3
#> 79      stats    influence.measures.Rd     24      <NA>                  <NA> 0
#> 80      stats          lm.influence.Rd     24     stats influence.measures.Rd 1
#> 81      stats               ls.diag.Rd     24     stats influence.measures.Rd 1
#> 82      stats               plot.lm.Rd     24     stats influence.measures.Rd 1
#> 83    splines                    bs.Rd     25      <NA>                  <NA> 0
#> 84      stats           model.frame.Rd     25   splines                 bs.Rd 1
#> 85    splines          interpSpline.Rd     26      <NA>                  <NA> 0
#> 86    splines        periodicSpline.Rd     26      <NA>                  <NA> 0
#> 87      stats             splinefun.Rd     26   splines       interpSpline.Rd 1
#> 88      stats             splinefun.Rd     26   splines     periodicSpline.Rd 1
#> 89      stats                  coef.Rd     27      <NA>                  <NA> 0
#> 90     stats4          coef-methods.Rd     27     stats               coef.Rd 1
#> 91      stats               confint.Rd     28      <NA>                  <NA> 0
#> 92     stats4       confint-methods.Rd     28     stats            confint.Rd 1
#> 93      stats                logLik.Rd     29      <NA>                  <NA> 0
#> 94     stats4        logLik-methods.Rd     29     stats             logLik.Rd 1
#> 95      stats               profile.Rd     30      <NA>                  <NA> 0
#> 96     stats4       profile-methods.Rd     30     stats            profile.Rd 1
#> 97      stats                update.Rd     31      <NA>                  <NA> 0
#> 98     stats4        update-methods.Rd     31     stats             update.Rd 1
#> 99      stats                  vcov.Rd     32      <NA>                  <NA> 0
#> 100    stats4          vcov-methods.Rd     32     stats               vcov.Rd 1
#> 101  parallel          clusterApply.Rd     33      <NA>                  <NA> 0
#> 102  parallel             mcdummies.Rd     33      <NA>                  <NA> 0
#> 103  parallel              mclapply.Rd     33      <NA>                  <NA> 0
#> 104     tools check_packages_in_dir.Rd     33  parallel          mcdummies.Rd 2
#> 105     tools check_packages_in_dir.Rd     33  parallel           mclapply.Rd 2
#> 106     tools check_packages_in_dir.Rd     33  parallel       clusterApply.Rd 2
#> 107     tools         buildVignette.Rd     34      <NA>                  <NA> 0
#> 108     utils                Sweave.Rd     34     tools      buildVignette.Rd 1
#> 109     tools          RdTextFilter.Rd     35      <NA>                  <NA> 0
#> 110     utils          aspell-utils.Rd     35     tools       RdTextFilter.Rd 1
#> 111     tools               userdir.Rd     36      <NA>                  <NA> 0
#> 112     utils    available.packages.Rd     36     tools            userdir.Rd 1
#> 113     utils    installed.packages.Rd     36     tools            userdir.Rd 1
#> 114     tools              bibstyle.Rd     37      <NA>                  <NA> 0
#> 115     tools          loadRdMacros.Rd     37      <NA>                  <NA> 0
#> 116     utils              bibentry.Rd     37     tools       loadRdMacros.Rd 1
#> 117     utils              bibentry.Rd     37     tools           bibstyle.Rd 1
#> 118     stats                    ts.Rd     38      <NA>                  <NA> 0
#> 119     utils                  head.Rd     38     stats                 ts.Rd 1
#> 120   methods        getPackageName.Rd     39      <NA>                  <NA> 0
#> 121     utils           packageName.Rd     39   methods     getPackageName.Rd 1
# }
```
