#' @title updateCheck
#' @description This function compares the package with the available version on
#' github, and prompts the user to update.
#' @param gitPkg default is \code{NULL}. This is the URL to the DESCRIPTION file
#' on github.
#'
#'
#' @importFrom utils packageDescription read.delim tail
#'
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
    #utils::read.delim(remURLdata)
    readLines(remURLdata)
  },
  warning = function(cond) {
  })
  # check local data

  remoteDataVer <- verCleaner(utils::tail(remoteData,1))
  if (length(remoteDataVer) == 0) remoteDataVer <- 0
 # localDataVerRaw <- utils::tail(utils::read.delim(system.file('extdata/', 'datadate.txt', package = 'azmpdata')),1)[,1]
  localDataVerRaw <- readLines(system.file('extdata/', 'datadate.txt', package = 'azmpdata'))
  localDataVer <- verCleaner(localDataVerRaw)

# User Messages: ----------------------------------------------------------

  message(paste(gitPkg, "status:"))

  if (localPkgVer == remotePkgVer){
    message(paste0("\t(Package ver:",remotePkgVerRaw,") Up to date"))
  }else if (localPkgVer > remotePkgVer){
    message("\t(Package ver:",remotePkgVerRaw,") Push to Github")
  }else if (localPkgVer < remotePkgVer){
    message("\t(Package ver:",remotePkgVerRaw,") Old version detected. Please update using: ")
    message(paste("\t\tdevtools::install_github('",gitPkg,"')", sep=""))
  }

  if (localDataVer == remoteDataVer){
    message(paste0("\t(Data ver:",localDataVerRaw,") Up to date"))
  }else if (localDataVer > remoteDataVer){
    cat("\t(Data ver:",localDataVerRaw,") Push to Github")
  }else if (localDataVer < remoteDataVer){
    message("\t(Data ver:",localDataVerRaw,") Old version detected. Please update using: ")
    message(paste("\t\tdevtools::install_github('",gitPkg,"')", sep=""))
  }

}
