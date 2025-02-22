
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
    package_dependencies(ap[, fields_selected])
}

package_dependencies <- function(ap) {
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
            out <- split_op_version(y)
        }
        )

        df <- do.call(rbind, l)
        if (!is.null(df)) {
            df <- cbind(df, type = rep(names(l), vapply(l, NROW, numeric(1L))))
        }
        df
    }
    )
    big_df <- do.call(rbind, l)
    mbd <- cbind(big_df, package = rep(names(l), vapply(l, NROW, numeric(1L))))
    rownames(mbd) <- NULL
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
    pat <- "[[:space:]]*([[<>=!]+)[[:space:]]+"
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
