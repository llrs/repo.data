funlist <- function(x) {unlist(x, FALSE, FALSE)}

pkg_in_x <- function(x, packages) {
    cols <- c("package", "Package", "from_pkg", "to_pkg")
    w <- which(cols %in% colnames(x))
    if (!length(w)) {
        return(x)
    }
    column <- cols[min(w)]
    x[, column] %in% packages
}

check_installed <- function(x) {
    requireNamespace(x, quietly = TRUE)
}

check_local <- function(x) {
    desc_pkg <- file.path(x, "DESCRIPTION")
    vapply(desc_pkg, file.exists, FUN.VALUE = logical(1L))
}

get_from_local_pkg <- function(x, fields = "Package") {
    if (!length(x)) {
        return(NULL)
    }
    desc_pkg <- file.path(x, "DESCRIPTION")
    desc <- lapply(desc_pkg, read.dcf, fields = fields)
    names(desc) <- if (is.null(names(x))) x else names(x)
    do.call(rbind, desc)
}

# tools:::CRAN_baseurl_for_src_area but with fixed mirror
CRAN_baseurl <- function() {
    url <- "https://CRAN.R-project.org"
    out <- Sys.setenv(R_CRAN_SRC = Sys.getenv("R_CRAN_SRC", url))
    if (isTRUE(out)) {
        url
    } else {
        NULL
    }
}

# tools:::read_CRAN_object but for several types
read_CRAN <- function(path, cran = CRAN_baseurl()) {
    read_repo(path, cran)
}

check_r_version <- function() {
    ver <- paste(R.Version()[c("major","minor")], collapse = ".")
    r_ver <- package_version(ver)
    target <- package_version("4.5.0")
    r_ver >= target
}


.cran_archive <- function() {
    if (check_r_version()) {
        return(tools::CRAN_archive_db())
    }
    read_CRAN(CRAN_baseurl(), "src/contrib/Meta/archive.rds")
}

datetime2POSIXct <- function(date, time, tz = cran_tz) {
    moment <- paste(date, time)
    moment[is.na(date) & is.na(time)] <- NA
    moment <- as.POSIXct(moment, tz = cran_tz)
    moment
}


uniq_count <- function(x, name = "n") {
    x <- as.matrix(x)
    id <- apply(x, 1L, paste0, collapse = "")
    
    # Return if no duplicates
    if (!anyDuplicated(id)) {
        if (!NROW(x)) {
            return(cbind(x, n = numeric(0L)))
        }
        n <- matrix(1L, nrow = NROW(x),
        dimnames = list(seq_len(NROW(x)), name))
        return(cbind(x, n))
    }
    ids <- table(factor(id, levels = unique(id)))
    names(ids) <- NULL
    uid <- unique(x)
    rownames(uid) <- NULL
    cbind(uid, matrix(as.numeric(ids), ncol = 1, dimnames = list(NULL, name)))
}

add_uniq_count <- function(x, name = "n", old_name = "n") {
    # Input checks
    if (length(dim(x)) < 2) {
        return(x)
    } 
    stopifnot(length(name) == 1L)
    stopifnot(length(old_name) == 1L)
    
    # Nothing to add up:
    w <- which(colnames(x) %in% old_name)
    if (!length(w)) {
        return(uniq_count(x, name))
    }
    
    if (!NROW(x)) {
        m <- cbind(x[, -w, drop = FALSE], n = numeric(0L))
        colnames(m)[colnames(m) == "n"] <- name
        return(m)
    }
    
    id <- apply(as.matrix(x[, -w, drop = FALSE]), 1, paste0, collapse = ";")
    dup_f <- duplicated(id)
    dup_r <- duplicated(id, fromLast = TRUE)
    dup <- dup_f | dup_r
    
    # Return if no duplicates
    if (!any(dup) & !length(w)) {
        n_matrix <- matrix(1L, nrow = NROW(x),
        dimnames = list(seq_len(NROW(x)), name))
        return(cbind(x[, -w, drop = FALSE], n_matrix))
    } else if (!any(dup) & length(w)) {
        return(x)
    }
    
    # Calculate duplicates count while keeping the data
    y <- as.data.frame(x[!dup, ])
    df <- tapply(as.data.frame(x[dup, , drop = FALSE]), id[dup], function(xy) {
        y <- unique(as.matrix(xy[, -w, drop = FALSE]))
        y <- cbind(y, name = sum(as.numeric(xy[, w, drop = TRUE]), na.rm = TRUE))
        colnames(y)[ncol(y)] <- name
        y
    })
    dff <- do.call(rbind, df)
    out <- rbind(y, dff)
    out <- as.data.frame(out)
    out[[name]] <- as.numeric(out[[name]])
    out <- sort_by(out, out[, setdiff(colnames(out), name)])
    rownames(out) <- NULL
    out
}


valid_package_name <- function(packages) {
    
    #  - at least two characters
    #  - start with a letter
    #  - not end in a dot
    validity <- nchar(packages) >= 2L & grepl("^[[:alpha:]]", packages) & !endsWith(packages, ".")
    if (!all(validity)) {
        stop("Packages names should have at least two characters and start",
        " with a letter and not end in a dot.", call. = FALSE)
    }
    TRUE
}

check_pkg_names <- function(packages, length = 1L) {
    char_packages <- is.character(packages) && length(na.omit(packages))
    
    if (isFALSE(char_packages) && !is.na(length)) {
        if (length <= length(packages)) {
            msg <- "Use NULL or a character vector with some packages."
        } else {
            msg <- sprintf("Use NULL or a character vector (without NA) of length %d.", length)
        }
        stop(msg, call. = FALSE)
    }
    
    # If length = NA it can be NULL
    if (is.null(packages)) {
        return(TRUE)
    }
    local_packages <- dir.exists(packages)
    
    valid_names <- valid_package_name(packages)
    
    # Don't trigger error on local packages
    if (!any(local_packages) && !any(valid_names[!local_packages])) {
        stop("Packages names should have at least two characters and start",
        " with a letter and not end in a dot.", call. = FALSE)
    }
    
    TRUE
}



is_logical <- function(x) {
    isTRUE(x) || isFALSE(x)
}


is_not_data <- function(x) {
    !as.logical(NROW(x)) || (length(x) == 1L && is.na(x))
}

no_internet <- function(x) {
    if (length(x) == 1L && is.na(x)) q("no")
}

omitting_packages <- function(packages) {
    if (length(packages)) {
        warning("Some packages are not currently available. Omitting packages:\n",
        toString(sQuote(packages)), ".", immediate. = TRUE, call. = FALSE)
    }
}

check_current_pkg <- function(packages, current) {
    warn <- empty_env("current_packages")
    current_packages <- save_state("current_packages", current, verbose = FALSE)
    omit_pkg <- setdiff(packages, current_packages)
    if (warn && anyNA(current_packages) && any(current_packages != current)) {
        omitting_packages(omit_pkg)
    }
    omit_pkg
}


strcapture_m <- function(pattern, x, proto, perl = FALSE, useBytes = FALSE) {
    m <- regexec(pattern, x, perl = perl, useBytes = useBytes)
    str <- regmatches(x, m)
    ntokens <- length(proto) + 1L
    nomatch <- lengths(str) == 0L
    str[nomatch] <- list(rep.int(NA_character_, ntokens))
    if (length(str) > 0L && length(str[[1L]]) != ntokens) {
        stop("The number of captures in 'pattern' != 'length(proto)'")
    }
    m <- matrix(as.character(unlist(str)), ncol = ntokens, 
        byrow = TRUE)[, -1L, drop = FALSE]
    colnames(m) <- colnames(proto) %||% names(proto) %||% proto
    m
}