str2mat <- function(pattern, x, columns, perl = FALSE, useBytes = FALSE){
    m <- regexec(pattern, x, perl = perl, useBytes = useBytes)
    str <- regmatches(x, m)
    ntokens <- length(columns) + 1L
    nomatch <- lengths(str) == 0L
    str[nomatch] <- list(rep.int(NA_character_, ntokens))
    if (length(str) > 0L && length(str[[1L]]) != ntokens) {
        stop("The number of captures in 'pattern' != 'length(proto)'")
    }
    mat <- matrix(as.character(unlist(str)), ncol = ntokens,
        byrow = TRUE)[, -1L, drop = FALSE]
    colnames(mat) <- columns
    mat
}

curr2m <- function(pkges) {
    curr <- as.matrix(pkges[, c("mtime", "size", "uname")])
    # dse packages has unorthodox version number
    pkg_v <- str2mat(pattern = "(.+)_(.+)\\.tar\\.gz",
                     x = rownames(pkges),
                     columns = c("package", "version"))
    x <- cbind(curr, pkg_v, status = "current")

    keep_columns <- c("package", "mtime", "version", "uname", "size", "status")
    x[, keep_columns]
    rownames(x) <- NULL
    x
}

arch2m <- function(arch){
    if (!length(arch)) {
        return(NULL)
    }

    l <- lapply(arch, function(x){
        as.matrix(x[, c("mtime", "size", "uname")])
    })
    mat <- do.call(rbind, l)
    pkg_v <- str2mat(pattern = "(.+)_(.+)\\.tar\\.gz",
                     x = rownames(mat),
                     columns = c("package", "version"))
    # cleaning captures
    pkg_v[, "package"] <- basename(pkg_v[, "package"])

    x <- cbind(mat, pkg_v, status = "archived")

    keep_columns <- c("package", "mtime", "version", "uname", "size", "status")
    x[, keep_columns]
    rownames(x) <- NULL
    x
}

arch2df <- function(x) {
    x <- as.data.frame(x)
    x$size <- as.numeric(x$size)
    x$mtime <- as.POSIXct(x$mtime, tz = cran_tz)

    # Arrange dates and data
    keep_columns <- c("package", "mtime", "version", "uname", "size", "status")
    x <- sort_by(x[, keep_columns, drop = FALSE], x[, c("package", "status", "mtime")])
    colnames(x) <- c("Package", "Datetime", "Version", "User", "Size", "Status")
    rownames(x) <- NULL
    x
}

warnings_archive <- function(all_packages) {
    # Rely on order of all_packages by date
    dup_arch <- duplicated(all_packages[, c("package", "version")])
    if (any(dup_arch)) {
        warning("There are ", sum(dup_arch, na.rm = TRUE),
                " packages both archived and published\n",
                "This indicate manual CRAN intervention.",
                call. = FALSE, immediate. = TRUE)
    }
    all_packages
}
