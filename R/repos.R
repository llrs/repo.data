
#' Title
#'
#' @param repos
#'
#' @returns A data.frame with one line per package and at least one column per repository.
#' @export
#'
#' @examples
#' repos()
pkges_repos <- function(repos = getOption("repos")) {
    ap <- available.packages(repos = repos, filters = "duplicates")
    repositories <- gsub("/src/contrib", "", ap[, "Repository"], fixed = TRUE)
    repositories_names <- names(repos)[match(repositories, repos)]
    packages <- ap[, "Package"]
    pd <- packages_dependencies(ap = ap[, PACKAGE_FIELDS])
    pd2 <- pd[!pd$name %in% c(tools::standard_package_names()$base, "R"), c("name", "package")]
    position <- match(pd2$name, packages)
    repos_packages <- repositories_names[position]
    repos_packages[is.na(repos_packages)] <- "Other"
    s <- split(repos_packages, pd2$package)
    M <- matrix(0, ncol = length(repos) + 1L, nrow = nrow(ap))
    colnames(M) <- c(names(repos), "Other")
    rownames(M) <- packages

    l <- lapply(s, function(pkg) {
        tab <- table(factor(pkg, levels = c(names(repos), "Other")))
        as.matrix(tab)
    })
    deps_m <- do.call(cbind, l)
    deps_m <- t(deps_m)
    rownames(deps_m) <- names(s)
    M[rownames(deps_m), ] <- deps_m[, colnames(M)]

    repos_n <- apply(M, 1L, function(x){sum(x > 0L)})
    deps_n <- rowSums(M)
    M2 <- cbind(M, Packages_deps = deps_n, Repos = repos_n)
    df2 <- as.data.frame(M2)
    # bioc_deps <- rowSums(M2[, 2:6])
    cbind(Package = rownames(df2), Repository = repositories_names, df2)
}

repos <- c(getOption("repos"), bioc_repos())
