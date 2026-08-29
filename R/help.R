  help_cliques <- function(packages = NULL) {
    valid_package_name(packages)
    ap <- tryCatch(available.packages(filters = c("CRAN", "duplicates")), warning = function(w) {NA})
    if (is_not_data(ap)) {
        return(NA)
    }
    repos <- getOption("repos")
    
    # Choose function
}


help_pages_links_wo_deps <- function(packages = NULL) {
    ref_packages <- packages
    ap <- tryCatch(available.packages(filters = c("CRAN", "duplicates")), warning = function(w){NA})
    if (is_not_data(ap)) {
        return(NA)
    }
    if (check_packages(packages)) {
        pkg <- tools::package_dependencies(packages, db = ap, recursive = TRUE)
        packages <- setdiff(funlist(pkg), BASE)
        ap <- ap[packages, c("Package", check_which("strong"))]
    } else {
        ap <- ap[, c("Package", check_which("strong"))]
    }
    
    links <- cran_links(ref_packages)
    if (is_not_data(links)) {
        return(NA)
    }
    xrefs_wo_deps(links, ap, ref = ref_packages)
}

