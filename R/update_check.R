#' @title updateCheck
#' @description This function compares the package with the available version on
#' github, and prompts the user to update.
#' @param gitPkg default is \code{NULL}. This is the URL to the DESCRIPTION file
#' on github.
#' @family general_use
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}, Emily Chisholm
#' @export
update_check<-function(gitPkg = NULL){

  verCleaner<-function(dirtyVer = NULL){
    if (length(dirtyVer)>1) dirtyVer = gsub(pattern = "Version: ",replacement = "", x = dirtyVer[grep(pattern = "Version:",x = dirtyVer)])
    cleanVer = gsub(pattern = "Version: ",replacement = "", x = dirtyVer)
    cleanVer = as.integer(gsub(pattern = "\\.|-",replacement = "",x = cleanVer))
    return(cleanVer)
  }

# Package Version ---------------------------------------------------------
  remotePkg  <- tryCatch({
    remURL = paste("https://raw.githubusercontent.com/",gitPkg,"/master/DESCRIPTION", sep = "")
    readLines(remURL)
  },
    warning = function(cond) {
  })
  if (is.null(remotePkg)){
    cat("\n",gitPkg,": Can't reach url to check version","\n")
    return(NULL)
  }
  remotePkgVerRaw <- remotePkg[3]
  remotePkgVer <- verCleaner(remotePkgVerRaw)
  remotePkgVerRaw <- gsub(pattern="Version:", replacement = "",remotePkgVerRaw)
  localPkgVer = verCleaner(utils::packageDescription(strsplit(gitPkg,"/")[[1]][2])$Version)

# Data Version ------------------------------------------------------------
  remoteData  <- tryCatch({
    remURLdata = paste("https://raw.githubusercontent.com/",gitPkg,"/master/inst/extdata/datadate.txt", sep = "")
    read.delim(remURLdata)
  },
  warning = function(cond) {
  })
  # check local data

  remoteDataVer <- verCleaner(tail(remoteData,1))
  if (length(remoteDataVer) == 0) remoteDataVer <- 0
  localDataVerRaw <- tail(read.delim(system.file('extdata/', 'datadate.txt', package = 'azmpdata')),1)[,1]
  localDataVer <- verCleaner(localDataVerRaw)

# User Messages: ----------------------------------------------------------

  cat(paste("\n", gitPkg, "status:"))

  if (localPkgVer == remotePkgVer){
    cat(paste0("\n\t(Package ver:",remotePkgVerRaw,") Up to date"))
  }else if (localPkgVer > remotePkgVer){
    cat("\n\t(Package ver:",remotePkgVerRaw,") Push to Github")
  }else if (localPkgVer < remotePkgVer){
    cat("\n\t(Package ver:",remotePkgVerRaw,") Old version detected. Please update using: ")
    cat(paste("\n\t\tdevtools::install_github('",gitPkg,"')", sep=""),"\n")
  }

  if (localDataVer == remoteDataVer){
    cat(paste0("\n\t(Data ver:",localDataVerRaw,") is up to date","\n"))
  }else if (localDataVer > remoteDataVer){
    cat("\n\t(Data ver:",localDataVerRaw,") Push to Github")
  }else if (localDataVer < remoteDataVer){
    cat("\n\t(Data ver:",localDataVerRaw,") Old version detected. Please update using: ")
    cat(paste("\n\t\tdevtools::install_github('",gitPkg,"')", sep=""))
  }

}
