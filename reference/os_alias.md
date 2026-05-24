# Base R OS specific alias

Data from the R source code of OS specific man help pages. This is to
complement
[`tools::base_aliases_db()`](https://rdrr.io/r/tools/basetools.html)
which only provides links for Unix.

## Usage

``` r
os_alias
```

## Format

An object of class `matrix` (inherits from `array`) with 33 rows and 5
columns.

## Value

A matrix with 33 rows and 5 columns:

- Package:

  Package name

- os:

  OS system where this applies

- file:

  Name of the Rd file.

- Source:

  Path to the file.

- Target:

  Name of the Target

## Examples

``` r
os_alias
#>       Package     os        file            Source                 
#>  [1,] "base"      "unix"    "Signals.Rd"    "unix/Signals.Rd"      
#>  [2,] "grDevices" "unix"    "png.Rd"        "unix/png.Rd"          
#>  [3,] "grDevices" "unix"    "png.Rd"        "unix/png.Rd"          
#>  [4,] "grDevices" "unix"    "png.Rd"        "unix/png.Rd"          
#>  [5,] "grDevices" "unix"    "png.Rd"        "unix/png.Rd"          
#>  [6,] "grDevices" "unix"    "savePlot.Rd"   "unix/savePlot.Rd"     
#>  [7,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#>  [8,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#>  [9,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#> [10,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#> [11,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#> [12,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#> [13,] "parallel"  "unix"    "children.Rd"   "unix/children.Rd"     
#> [14,] "parallel"  "unix"    "mcaffinity.Rd" "unix/mcaffinity.Rd"   
#> [15,] "parallel"  "unix"    "mcfork.Rd"     "unix/mcfork.Rd"       
#> [16,] "parallel"  "unix"    "mcfork.Rd"     "unix/mcfork.Rd"       
#> [17,] "parallel"  "unix"    "mclapply.Rd"   "unix/mclapply.Rd"     
#> [18,] "parallel"  "unix"    "mclapply.Rd"   "unix/mclapply.Rd"     
#> [19,] "parallel"  "unix"    "mclapply.Rd"   "unix/mclapply.Rd"     
#> [20,] "parallel"  "unix"    "mcparallel.Rd" "unix/mcparallel.Rd"   
#> [21,] "parallel"  "unix"    "mcparallel.Rd" "unix/mcparallel.Rd"   
#> [22,] "parallel"  "unix"    "pvec.Rd"       "unix/pvec.Rd"         
#> [23,] "base"      "windows" "shell.exec.Rd" "windows/shell.exec.Rd"
#> [24,] "base"      "windows" "shell.Rd"      "windows/shell.Rd"     
#> [25,] "grDevices" "windows" "png.Rd"        "windows/png.Rd"       
#> [26,] "grDevices" "windows" "png.Rd"        "windows/png.Rd"       
#> [27,] "grDevices" "windows" "png.Rd"        "windows/png.Rd"       
#> [28,] "grDevices" "windows" "png.Rd"        "windows/png.Rd"       
#> [29,] "grDevices" "windows" "savePlot.Rd"   "windows/savePlot.Rd"  
#> [30,] "parallel"  "windows" "mcdummies.Rd"  "windows/mcdummies.Rd" 
#> [31,] "parallel"  "windows" "mcdummies.Rd"  "windows/mcdummies.Rd" 
#> [32,] "parallel"  "windows" "mcdummies.Rd"  "windows/mcdummies.Rd" 
#> [33,] "parallel"  "windows" "mcdummies.Rd"  "windows/mcdummies.Rd" 
#>       Target          
#>  [1,] "Signals"       
#>  [2,] "png"           
#>  [3,] "jpeg"          
#>  [4,] "tiff"          
#>  [5,] "bmp"           
#>  [6,] "savePlot"      
#>  [7,] "children"      
#>  [8,] "readChild"     
#>  [9,] "readChildren"  
#> [10,] "selectChildren"
#> [11,] "sendChildStdin"
#> [12,] "sendMaster"    
#> [13,] "mckill"        
#> [14,] "mcaffinity"    
#> [15,] "mcfork"        
#> [16,] "mcexit"        
#> [17,] "mclapply"      
#> [18,] "mcmapply"      
#> [19,] "mcMap"         
#> [20,] "mccollect"     
#> [21,] "mcparallel"    
#> [22,] "pvec"          
#> [23,] "shell.exec"    
#> [24,] "shell"         
#> [25,] "png"           
#> [26,] "jpeg"          
#> [27,] "tiff"          
#> [28,] "bmp"           
#> [29,] "savePlot"      
#> [30,] "mclapply"      
#> [31,] "pvec"          
#> [32,] "mcmapply"      
#> [33,] "mcMap"         
```
