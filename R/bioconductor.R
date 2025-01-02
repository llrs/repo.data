#' Bioconductor packages using CRAN archived packages
#'
#' Checks on the 4 Bioconductor repositories which packages depend on a CRAN
#' archived package.
#' @returns A character vector with the name of the Bioconductor packages
#' depending on CRAN packages that were archived.
#' @export
#' @examples
#' bioc_cran_archived()
bioc_cran_archived <- function() {
    repos <- c("/bioc", "/data/annotation", "/data/experiment", "/workflows", "/books")
    name_repos <- basename(repos)
    name_repos[1] <- "software"

    urls <- paste0("https://bioconductor.org/packages/",
                   bioc_version(),
                   repos)

    url_repos <- urls
    names(url_repos) <- name_repos
    bioc <- available.packages(repos = url_repos)

    pkg_dep <- tools::package_dependencies(bioc[, "Package"], db <- tools::CRAN_package_db(), which = "all")
    pkges <- c(db$Package, bioc[, "Package"])
    missing_dep <- lapply(pkg_dep, setdiff, y = pkges)
    lmissing_dep <- lengths(missing_dep)
    names(lmissing_dep)[lmissing_dep >= 1L]
}

#' @importFrom utils read.csv
bioc_version <- function() {
    bioc_config <- "https://bioconductor.org/config.yaml"
    rl <- readLines(con = url(bioc_config))
    version <- which(startsWith(rl, "release_version"))
    rv <- read.csv(text = rl[version], sep = ":", header = FALSE, colClasses = c("character", "character"))
    trimws(rv$V2)
}
