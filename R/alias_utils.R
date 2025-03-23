
alias2df <- function(x){
    l <- lapply(x, function(x) {
        out <- cbind(Source = rep(names(x), lengths(x)),
                     Target = funlist(x))
    })
    aliasesDF <- do.call(rbind, l)
    aliasesDF <- cbind(aliasesDF, Package = rep(names(l), vapply(l, NROW, numeric(1L))))

    aliasesDF
}


check_alias <- function(alias) {

    if (length(unique(alias[, "Package"])) > 1) {
        s <- split(as.data.frame(alias), alias[, "Package"])
        more_alias <- vapply(s, check_alias, logical(1L))
        names(more_alias) <- names(s)
    } else {
        paths <- grepl("/", alias[, "Source"], fixed = TRUE)
        dup_targets <- duplicated(alias[, "Target"])
        more_alias <- sum(paths) > sum(dup_targets) * 2L
        return(more_alias)
    }
    # Recursive call
    if (sum(more_alias) > 1L) {
        warning("Packages ", paste0(sQuote(names(more_alias)[more_alias]), collapse = ", "),
                " have targets not present in some OS.", call. = FALSE)
        return(FALSE)
    } else if (sum(more_alias) == 1L) {
        warning("Package ", unique(alias[, "Package"]),
                " has targets not present in some OS.", call. = FALSE)
        return(FALSE)
    }
    TRUE
}

# Add alias using the data from the R source code to fix/clean it
r_os_alias <- function(alias) {
    data(os_alias, package = "repo.data")
    current_os <- .Platform$OS.type
    missing_alias <- os_alias[, "os"] != current_os
    rbind(alias, os_alias[missing_alias, colnames(alias)])
}

# Internal function to find duplicate alias (and which packages they are in)
dup_alias <- function(alias) {
    df <- duplicated(alias[, "Target"])
    dup_targets <- unique(alias[df, "Target"])
    pkg_df <- alias[alias[, "Target"] %in% dup_targets, ]
    pkg_df <- sort_by(pkg_df, ~Target+Package+Source)
    rownames(pkg_df) <- NULL
    pkg_df
}

# Join duplicate alias
count_dups <- function(dups) {
    s <- split(dups$Package, dups$Target)
    v <- vapply(s, paste, collapse = ",", FUN.VALUE = character(1L))
    df <- data.frame(Alias = names(s), Packages = v, Times = lengths(s))
    rownames(df) <- NULL
    df
}
