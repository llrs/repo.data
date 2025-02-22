
#' Tidy dependencies
#'
#' Extract the packages dependencies, name of the dependency, operator and version
#'  for each type and package of current repositories (`getOptions("repos")`).
#' @inheritParams tools::package_dependencies
#'
#' @returns A data.frame with 5 columns: the name of the dependency,
#' the operator (op), the version it depends the type of dependency and the package.
#' @export
#' @examples
#' rd <- repos_dependencies()
#' head(rd)
repos_dependencies <- function(which = "all") {
    fields_selected <- check_which(which)
    ap <- available.packages(filters = c("CRAN", "duplicates"))
    packages_dependencies(ap[, fields_selected])
}


#' Find current installations
#'
#' Despite the description minimal requirements find which versions are
#' required due to dependencies.
#' @param pkg Path to a file with
#' @inheritParams repos_dependencies
#'
#' @returns A data.frame with the name, version required and version used.
#' @export
#'
#' @examples
#' pd <- package_dependencies("ggeasy")
package_dependencies <- function(pkg = ".", which = "strong") {
    fields <- check_which(which)
    desc_pack <- file.path(pkg, "DESCRIPTION")
    local_pkg <- file.exists(desc_pack)

    ap <- available.packages(filters = c("CRAN", "duplicates"))
    # Get package dependencies recursively
    if (local_pkg) {
        desc <- read.dcf(desc_pack, fields = c(package_fields, "Package"))
        deps <- desc[, intersect(fields, colnames(desc)), drop = FALSE]
        rownames(deps) <- desc[, "Package"]
        deps_df <- packages_dependencies(deps)
    } else {
        deps_df <- packages_dependencies(ap[pkg, fields, drop = FALSE])
    }
    all_deps <- tools::package_dependencies(deps_df$name, recursive = TRUE, which = which,
                                            db = ap[, c(fields, "Package"), drop = FALSE])
    rd <- packages_dependencies(ap[intersect(funlist(all_deps), rownames(ap)), fields, drop = FALSE])

    rd2 <- sort_by(unique(rd[, c(1, 3)]), ~name + version)
    s <- split(rd2$version, rd2$name)
    v <- lapply(s, function(x){
        y <- x[!is.na(x)]
        if (length(y) == 0L) {
            return(NA)
        }
        as.character(y[length(y)])
    })
    df <- data.frame(name = names(v), required = package_version(funlist(v)))
    m <- merge(deps_df, df, all = TRUE, sort = FALSE)
    m <- sort_by(m, ~package+name+!is.na(version))
    rownames(m) <- NULL
    m
}

packages_dependencies <- function(ap) {
    # Split by Ops and version
    deps <- apply(ap, 1, strsplit, split = ",[[:space:]]*")
    names(deps) <- rownames(ap)

    with_deps <- lengths(deps) > 0
    pkg_with_deps <- names(deps)[with_deps]
    deps <- deps[with_deps]
    packages <- rep(names(deps), lengths(deps))

    l <- lapply(deps, function(x){
        l <- lapply(x, function(y){
            if (length(y) == 1 && anyNA(y)) return(NULL)
            split_op_version(y)
        })

        df <- do.call(rbind, l)
        if (!is.null(df)) {
            df <- cbind(df, type = rep(names(l), vapply(l, NROW, numeric(1L))))
        }
        df
    })
    big_df <- do.call(rbind, l)
    mbd <- cbind(big_df, package = rep(names(l), vapply(l, NROW, numeric(1L))))
    df <- as.data.frame(mbd)
    # Conversion to package_version class because currently we can do it.
    df$version <- package_version(df$version)
    df <- sort_by(df, ~package + type + name)
    rownames(df) <- NULL
    df
}

# Originally from tools:::.split_op_version
split_op_version <- function(x) {
    # No dependency
    if (anyNA(x)) {
        return(NULL)
    }

    # No version
    thereis_op <- grepl("(", x, fixed = TRUE)
    nas <- rep(NA_character_, length(thereis_op))
    if (!any(thereis_op)) {
        return(cbind(name = x, op = nas, version = nas))
    }

    pat <- "^([^\\([:space:]]+)[[:space:]]*\\(([^\\)]+)\\).*"
    version <- op <- nas
    package <- sub(pat, "\\1", x)
    w <- which(thereis_op)
    x2 <- sub(pat, "\\2", x[w])
    pat <- "[[:space:]]*([[<>=!]+)[[:space:]]+(.*)"
    version[w] <- sub(pat, "\\2", x2)
    op[w] <- sub(pat, "\\1", x2)
    cbind(name = package, op = op, version = version)
}



check_which <- function(x){
    if (x %in% c("all", "strong", "most")) {
        fields_selected <- switch(x,
                                  all = package_fields,
                                  most = head(package_fields, -1),
                                  strong = head(package_fields, 3))
    } else {
        fields_selected <- intersect(package_fields, x)
    }
    fields_selected
}
