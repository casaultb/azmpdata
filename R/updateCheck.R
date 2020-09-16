# update check
# checks for latest version of package on github and compares to local version
# code inspired from Mike MacMahon (Mar.Utils)
# requires version numbers to be in YYYY.MM.DD format
# only checks master branch
# TODO: might need update to version number system to allow multiple updates on one day



#' @title updateCheck
#' @description This function compares the package with the available version on
#' github, and prompts the user to update.
#' @param gitPkg default is \code{NULL}. This is the URL to the DESCRIPTION file
#' on github.
#' @family general_use
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @export
updateCheck<-function(gitPkg = NULL){

  verCleaner<-function(dirtyVer = NULL){
    #cleans up version information - can handle:
    #1) the contents of the DESCRIPTION
    #2) "Version: YYYY.MM.DD
    #3) "YYYY.MM.DD"
    if (length(dirtyVer)>1) dirtyVer = gsub(pattern = "Version: ",replacement = "", x = dirtyVer[grep(pattern = "Version:",x = dirtyVer)])
    cleanVer = gsub(pattern = "Version: ",replacement = "", x = dirtyVer)
    cleanVer = gsub(pattern = "\\.",replacement = "",x = cleanVer)
    return(cleanVer)
  }

  # clean remote date
  cleanDate <- function(remoteData){
    split1 <- stringr::str_split(remoteData, pattern = '"')
    cleanDate <- split1[[1]][2] # clean date
    posixdate <- as.POSIXct(cleanDate)
    if(is.na(posixdate)){
      stop('Incorrect date format in datadate.txt!')
    }else{
      return(posixdate)
    }
  }

  remote  <- tryCatch({
    remURL = paste("https://raw.githubusercontent.com/",gitPkg,"/master/DESCRIPTION", sep = "")
    # try checking for data txt file as well as description?
    remURLdata = paste("https://raw.githubusercontent.com/",gitPkg,"/master/inst/extdata/datadate.txt", sep = "")

    readLines(remURL)
    readLines(remURLdata)

  },
  warning = function(cond) {
  })

  remoteData  <- tryCatch({

    remURLdata = paste("https://raw.githubusercontent.com/",gitPkg,"/master/inst/extdata/datadate.txt", sep = "")

    readLines(remURLdata)

  },
  warning = function(cond) {
  })

  if (is.null(remote)){
    cat("\n",gitPkg,": Can't reach url to check version","\n")
    return(NULL)
  }

  localVer = utils::packageDescription(strsplit(gitPkg,"/")[[1]][2])$Version
  localVer = verCleaner(localVer)
  remoteVer = verCleaner(remote)

  if (localVer == remoteVer){
    cat(paste0("\n", gitPkg,": Latest and greatest version confirmed","\n"))
  }else if (localVer > remoteVer){
    cat("\n","Push to Github!")
  }else if (localVer < remoteVer){
    cat(paste0("\n", gitPkg, ": Old version detected -- v.",gsub('^([0-9]{4})([0-9]{2})([0-9]{2})$','\\1\\.\\2\\.\\3',remoteVer)," is now available")) # specifically formatted for YYYY.MM.DD version numbers
    cat("\n","You can run the following code to update this package:")
    cat(paste("\n","devtools::install_github('",gitPkg,"')", sep=""),"\n")
  }

  # check local data
  localData <- system.file('extdata/', 'datadate.txt', package = 'azmpdata')
  localdate <- cleanDate(readLines(localData))

  remotedate <- cleanDate(remoteData)

  # compare local to remote
  if(localdate == remotedate){
    cat("\n All data is up-to-date!")
  }else if (localdate > remotedate){
    cat("\n Push to GitHub!")
  }else if (localdate < remotedate){
    cat("\n Old data version detected! Please update using: ")
    cat(paste("\n","devtools::install_github('",gitPkg,"')", sep=""),"\n")

  }


}
