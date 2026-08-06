empty_env <- function(name) {
    is.null(pkg_state[[name]])
}

save_state <- function(name, out, verbose = TRUE) {
    # Use CRAN mirror if not set a default
    CRAN_baseurl()

    if (empty_env(name)) {
        if (verbose) {
            name_msg <- if (!is.null(names(name))) names(name) else name
            message("Downloading and caching ", name_msg, " for this session.")
        }
        m <- tryCatch(out, warning = function(w) {NA}, error = function(e) {NA})
        if (is_not_data(m)) {
            warning("Failed to download ", name_msg)
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
