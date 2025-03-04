#' Bioconductor packages using CRAN archived packages
#'
#' Checks on the 4 Bioconductor repositories which packages depend on a CRAN
#' archived package.
#' @returns A character vector with the name of the Bioconductor packages
#' depending on CRAN packages that were archived.
#' @export
#' @examples
#' bioc_cran_archived()
bioc_cran_archived <- function(which = "strong") {
    fields_selected <- check_which(which)
    bioc <- bioc_available()
    db <- save_state("CRAN_db", tools::CRAN_package_db())
    columns <- intersect(colnames(bioc), colnames(db))
    db_all <- rbind(db[, columns], bioc[, columns])

    pkg_dep <- tools::package_dependencies(bioc[, "Package"], db = db_all, which = fields_selected)
    pkges <- c(db$Package, rownames(bioc))
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



bioc_available <- function(repos = c("/bioc", "/data/annotation", "/data/experiment", "/workflows", "/books")) {
    name_repos <- basename(repos)
    name_repos[1] <- "software"

    urls <- paste0("https://bioconductor.org/packages/", bioc_version(), repos)

    url_repos <- urls
    names(url_repos) <- name_repos

    bioc <- save_state("bioc_available",
                       available.packages(filters = c("CRAN", "duplicates"),
                                          repos = url_repos))
    bioc <- as.data.frame(bioc)
    bioc
}

bioc_views <- function(version = bioc_version()) {
    url <- paste0("https://bioconductor.org/packages/", version, "/bioc/VIEWS")
    read.dcf(url(url))
}

bioc_archive <- function() {
    v <- paste0(3, ".", 1:21)
    bv <- lapply(v, bioc_views)
    versions <- rep(v, vapply(bv, NROW, numeric(1L)))
    m1 <- do.call(merge, bv, all = TRUE)

    v2 <- paste0(2, ".", 1:14)
    bv2 <- lapply(v2, bioc_views)
    versions2 <- rep(v2, vapply(bv2, NROW, numeric(1L)))
    m2 <- do.call(merge, bv2, all = TRUE)
    m <- merge(m1, m2, all = TRUE)
}


