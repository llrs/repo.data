
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
#' rd <- repos_dependencies("BaseSet")
#' head(rd)
repos_dependencies <- function(packages = NULL, which = "all") {
    fields_selected <- check_which(which)
    check_packages(packages, 0)
    opts <- options(available_packages_filters = c("CRAN", "duplicates"))
    on.exit(options(opts), add = TRUE)
    env <- "repos_dependencies"
    
    first <- empty_env(env)
    ap <- available.packages()
    pd <- pkg_state[[env]]
    all_packages <- rownames(ap)

    omit_pkg <- setdiff(packages, all_packages)
    if (length(omit_pkg)) {
        warning("Omitting some packages, maybe they were not on CRAN?\n", 
        toString(omit_pkg), immediate. = TRUE)
    }

    new_pkgs <- if (first && is.null(packages)) {
        all_packages
    } else if (first && !is.null(packages)) {
        setdiff(packages, omit_pkg)
    } else if (!first) {
        setdiff(packages, pd$Package)
    }
    
    if  (length(new_pkgs)) {
        pd_new <- packages_dependencies(ap[new_pkgs, PACKAGE_FIELDS, drop = FALSE])
        pd <- rbind(pd, pd_new)
        pkg_state[[env]] <- pd
    }

    if (is.null(packages)) {
        which_pkgs <- pd$Package %in% all_packages
    } else {
        which_pkgs <- pd$Package %in% setdiff(packages, omit_pkg)
    }
    which_deps <- pd$Type %in% fields_selected
    pd <- pd[which_pkgs & which_deps, , drop = FALSE]
    rownames(pd) <- NULL
    pd
}


#' Find current installations
#'
#' Despite the description minimal requirements find which versions are
#' required due to dependencies.
#' @param pkg Path to a file with a DESCRIPTION file or package's names from a repository.
#' @inheritParams repos_dependencies
#'
#' @returns A data.frame with the name, version required, if only one package is provided it also show the version used.
#' @export
#'
#' @examples
#' pd <- package_dependencies("ggeasy")
#' head(pd)
package_dependencies <- function(pkg = ".", which = "strong") {
    fields_selected <- check_which(which)
    desc_pkg <- check_local(pkg)


    # Get packages dependencies recursively
    local_ap <- NULL
    local_pkgs <- NULL
    if (any(file.exists(desc_pkg))) {
        local_pkgs <- lapply(desc_pkg[file.exists(desc_pkg)], {
            desc <- read.dcf(desc_pkg, fields = c(PACKAGE_FIELDS, "Package"))
            deps <- desc[, intersect(fields_selected, colnames(desc)), drop = FALSE]
            rownames(deps) <- desc[, "Package"]
        })
        local_ap <- list2DF(local_pkgs)
        local_pkgs <- rownames(local_ap)
    } 

    pkges_names <- unique(c(local_pkgs, pkg[!file.exists(desc_pkg)]))

    ap <- available.packages(filters = c("CRAN", "duplicates"))
    new_ap <- rbind(ap[, c(fields_selected, "Package"), drop = FALSE], 
                    local_ap[, c(fields_selected, "Package"), drop = FALSE])
                    all_deps <- tools::package_dependencies(
                        pkges_names,
        recursive = TRUE,
        which = which,
        db = new_ap
    )
    # Extract recursive dependencies versions requirements
    unique_deps <- unique(funlist(all_deps))
    
    # Some package depend on Additional_repositories or Bioconductor
    # But some don't have dependencies!
    deps_available <- c(rownames(new_ap), BASE)
    missing_pkg <- setdiff(c(pkges_names, unique_deps), deps_available)
    packages_reported <- setdiff(c(pkges_names, unique_deps), missing_pkg)
    if (length(missing_pkg)) {
        warning(
            paste0(
                "Some dependencies are not on available repositories. ",
                "Check for 'Additional_repositories' or other repositories (Bioconductor.org?):\n",
                toString(missing_pkg)
            ),
            immediate. = TRUE
        )
    }
    rd <- repos_dependencies(setdiff(packages_reported, BASE), which = fields_selected)

    if (!anyDuplicated(rd$Name)){
        return(rd)
    }
    # Calculate the dependency path
    with_ver_n_dup <- !is.na(rd$Version) & rd$Name %in% rd$Name[duplicated(rd$Name)]
    t2n <- split(rd$Type[with_ver_n_dup], rd$Name[with_ver_n_dup])
    type_n <- vapply(t2n, function(x){length(unique(x))}, numeric(1L))
    type <- vector("character", length(t2n))
    type[type_n != 1] <- NA
    type[type_n == 1] <- vapply(t2n, function(x){x[1]}, character(1L))

    # Calculate the version required by the packages selected
    v2n <- split(rd$Version[with_ver_n_dup], rd$Name[with_ver_n_dup])
    required <- vapply(v2n, function(versions) {
        as.character(max(versions))
    }, character(1L))
    df <- data.frame(Name = names(v2n), Version = as.package_version(required), Type = type, Op = ">=")
    
    rd_no_ver <- rd[!rd$Name %in% df$Name, , drop = FALSE]
    # Replace Package by NA if Name is repeated.
    dup_name <- rd_no_ver$Name %in% rd_no_ver$Name[duplicated(rd_no_ver$Name)]
    rd_no_ver$Package[dup_name] <- NA
    # Replace Type by NA if multiple packages import it with different types
    t2n <- split(rd_no_ver$Type, rd_no_ver$Name)
    type_n <- vapply(t2n, function(x){length(unique(x))}, numeric(1L))
    multiple_types <- rd_no_ver$Name %in% names(type_n)[type_n > 1]
    rd_no_ver$Type[multiple_types] <- NA
    # Remove duplicated rows
    rd_no_ver <- unique(rd_no_ver)

    m <- merge(df, rd_no_ver, all = TRUE, sort = FALSE)
    rownames(m) <- NULL
    m
}


#' Check versions
#'
#' Helper function to detect which package have a required version on the
#' dependencies that could be upgraded.
#'
#' @param deps The output of [package_dependencies()] or any data.frame with a
#' version and required column.
#' @seealso [package_dependencies()]
#' @returns The data.frame filtered with some relevant rows
#' @export
#' @examples
#' pd <- package_dependencies("arrow")
#' update_dependencies(pd)
update_dependencies <- function(deps) {
    deps_higher_v <- (!is.na(deps$version) & package_version(deps$version) < package_version(deps$required))
    deps_req_v <- is.na(deps$version) & !is.na(deps$required)
    deps <- deps[which(deps_higher_v | deps_req_v), , drop = FALSE]
    rownames(deps) <- NULL

}

cache_pkg_dep <- function(package, which, keepR = TRUE) {
    which <- check_which(which)

}

packages_dependencies <- function(ap) {
    stopifnot(is.matrix(ap) || is.data.frame(ap))

    # Split by dependency, requires a matrix
    deps <- apply(ap, 1L, strsplit, split = "[[:space:]]*,[[:space:]]*")
    names(deps) <- trimws(rownames(ap))

    deps <- deps[lengths(deps) > 0L]
    # equivalent to .split_dependencies
    l <- lapply(deps, function(pkg){
        l_pkg <- lapply(pkg, function(dependency_f){
            if (length(dependency_f) == 1L && anyNA(dependency_f)) return(NULL)
            split_op_version(dependency_f)
        })

        df_pkg <- do.call(rbind, l_pkg)
        if (!is.null(df_pkg)) {
            df_pkg <- cbind(df_pkg,
                            Type = rep(names(l_pkg),
                                       vapply(l_pkg, NROW, numeric(1L))))
        }
        df_pkg
    })

    m_all <- cbind(do.call(rbind, l),
                   Package = rep(names(l),
                                 vapply(l, NROW, numeric(1L))))
    df <- as.data.frame(m_all)
    # Conversion to package_version class because currently we can do it.
    df$Version <- package_version(df$Version)
    df <- sort_by(df, df[, c("Package", "Type", "Name")])
    rownames(df) <- NULL
    df[, c("Package", "Type", "Name", "Op", "Version")]
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
        return(cbind(Name = x, Op = nas, Version = nas))
    }

    pat <- "^([^\\([:space:]]+)[[:space:]]*\\(([^\\)]+)\\).*"
    version <- op <- nas
    package <- sub(pat, "\\1", x)
    w <- which(thereis_op)
    x2 <- sub(pat, "\\2", x[w])
    pat <- "[[:space:]]*([[<>=!]+)[[:space:]]+(.*)"
    version[w] <- sub(pat, "\\2", x2)
    op[w] <- sub(pat, "\\1", x2)
    cbind(Name = package, Op = op, Version = version)
}



check_which <- function(x){
    if (all(x %in% c("all", "strong", "most"))) {
        fields_selected <- switch(x,
                                  all = PACKAGE_FIELDS,
                                  most = head(PACKAGE_FIELDS, -1L),
                                  strong = head(PACKAGE_FIELDS, 3L))
    } else {
        fields_selected <- intersect(PACKAGE_FIELDS, x)
    }

    if (!length(fields_selected)) {
        stop(sQuote("which"), " should be one of all, strong, most.\n",
             "Or several valid fields should be passed: ", toString(PACKAGE_FIELDS), ".")
    }
    fields_selected
}
