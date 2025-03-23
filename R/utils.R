save_state <- function(name, out, verbose = TRUE) {
    if (is.null(pkg_state[[name]])) {
        if (verbose) {
        message("Retrieving ", name, ", this might take a bit. ",
                "Next call will be faster.")
        }
        pkg_state[[name]] <- out
    }
    pkg_state[[name]]
}

funlist <- function(x){unlist(x, FALSE, FALSE)}

get_package_subset <- function(name, pkges) {
    stopifnot(is.character(name) && length(name) == 1L)
    stopifnot(is.null(pkges) || (is.character(pkges) && length(pkges)))

    if (!is.null(pkg_state[[name]])) {
        df <- pkg_state[[name]]

        if (is.null(pkges)) {
            return(df)
        }
        if ("package" %in% colnames(df)) {
            df[df$package %in% pkges, , drop = FALSE]
        } else {
            df[df$Package %in% pkges, , drop = FALSE]
        }
    } else {
        NULL
    }
}

check_subset <- function(obj, pkges) {
    if ("package" %in% colnames(obj)) {
        all(pkges %in% obj$package)
    } else {
        all(pkges %in% obj$Package)
    }
}

check_installed <- function(x) {
    requireNamespace(x, quietly = TRUE)
}

# tools:::CRAN_baseurl_for_src_area but with fixed mirror
CRAN_baseurl <- function() {
    Sys.getenv("R_CRAN_SRC", "https://CRAN.R-project.org")
}

# tools:::read_CRAN_object but for several types
read_CRAN <- function(path, cran = CRAN_baseurl()) {
    con <- gzcon(url(sprintf("%s/%s", cran, path), open = "rb"))
    on.exit(close(con))
    if (endsWith(path, "rds") || endsWith(path, "RDS")) {
        readRDS(con)
    } else {
        read.dcf(con)
    }
}

check_r_version <- function() {
    ver <- paste0(R.Version()[c("major","minor")], collapse = ".")
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

datetime2POSIXct <- function(date, time, tz = "Europe/Vienna") {
    moment <- paste(date, time)
    moment[is.na(date) & is.na(time)] <- NA
    moment <- as.POSIXct(moment, tz = tz)
    moment
}


uniq_count <- function(x, name = "n") {
    id <- apply(x, 1, paste0, collapse = "")
    ids <- table(id)
    names(ids) <- NULL
    uid <- unique(x)
    rownames(uid) <- NULL
    uid[, name] <- ids
    uid
}

add_uniq_count <- function(x, name = "n", old_name = "n") {
    w <- which(colnames(x) %in% old_name)
    id <- apply(x[, -w], 1, paste0, collapse = ";")
    dup_f <- duplicated(id)
    dup_r <- duplicated(id, fromLast = TRUE)
    dup <- dup_f | dup_r

    y <- x[!dup, ]
    x_dup <- split()
    df <- tapply(x[dup, ], id[dup], function(xy, column_to_add) {
        y <- unique(xy[, -column_to_add])
        y[, old_name] <- sum(xy[, column_to_add])
        y
    }, column_to_add = w)
    dff <- do.call(rbind, df)
    out <- rbind(y, dff)
}
