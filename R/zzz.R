# automatically runs update check when package is loaded
# From Mike McMahon

# avoid warnings in check() from dplyr syntax
utils::globalVariables(c('year', 'value', 'month', 'day', 'year_dec', 'xmin', 'xmax', 'ymin', 'ymax', '.', 'ls_data', 'variable', 'tmp_variable', 'keyword', 'dataframe'))


.onAttach <- function(libname, pkgname) {
  update_check(gitPkg = 'casaultb/azmpdata')
  message("azmpdata:: Indexing all available monthly azmpdata...")
  assign("azmpMonthlyParams", area_indexer(doMonths=T, doParameters = T), envir = .GlobalEnv)
}

