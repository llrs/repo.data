empty_env <- function(name) {
    is.null(pkg_state[[name]])
}

save_state <- function(name, out, verbose = TRUE) {
    # Use CRAN mirror if not set a default
    CRAN_baseurl()
    if (empty_env(name)) {
        if (verbose) {
            message("Retrieving ", name, ", this might take a bit.\n",
            "Caching results to be faster next call in this session.")
        }
        m <- tryCatch(out, warning = function(w) {NA}, error = function(e) {NA})
        if (is_not_data(m)) {
            return(NA)
        }
        pkg_state[[name]] <- m
    }
    pkg_state[[name]]
}

get_package_subset <- function(name, pkges) {
    stopifnot(is.character(name) && length(name) == 1L,
    "NULL or character vector" = is.null(pkges) || (is.character(pkges) && length(pkges)))
    
    if (empty_env(name)) {
        return(NULL)
    }
    
    df <- pkg_state[[name]]
    
    if (is.null(pkges)) {
        return(df)
    }
    
    df[pkg_in_x(df, pkges), , drop = FALSE]
}