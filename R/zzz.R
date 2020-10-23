# automatically runs update check when package is loaded
# From Mike MacMahon

.onAttach <- function(libname, pkgname) {

  update_check(gitPkg = 'casaultb/azmpdata')
  # localVer = utils::packageDescription('azmpdata')$Version
  # packageStartupMessage(paste0("Version: ", localVer))

}
