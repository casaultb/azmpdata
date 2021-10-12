# avoid warnings in check() from dplyr syntax
utils::globalVariables(c('year', 'value', 'month', 'day', 'year_dec', 'xmin', 'xmax', 'ymin', 'ymax', '.', 'ls_data', 'variable', 'tmp_variable', 'keyword', 'dataframe'))

.onAttach <- function(libname, pkgname) {
  # check if updates are available
  update_check(gitPkg = 'casaultb/azmpdata')
  message("\tazmpdata:: Indexing all available monthly azmpdata...")
  assign("azmpMonthlyParams", area_indexer(doMonths=T, doParameters = T), envir = .GlobalEnv)
}

