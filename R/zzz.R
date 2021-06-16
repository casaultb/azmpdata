# automatically runs update check when package is loaded
# From Mike McMahon

# avoid warnings in check() from dplyr syntax
utils::globalVariables(c('year', 'value', 'month', 'day', 'year_dec', 'xmin', 'xmax', 'ymin', 'ymax', '.', 'ls_data', 'variable', 'tmp_variable', 'keyword', 'dataframe'))


.onAttach <- function(libname, pkgname) {

  update_check(gitPkg = 'casaultb/azmpdata')
  # localVer = utils::packageDescription('azmpdata')$Version
  # packageStartupMessage(paste0("Version: ", localVer))

}
