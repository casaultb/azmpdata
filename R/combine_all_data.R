# combine all individual variable into proper organized dataframes

# get all dataframes

# library(azmpdata)

# test


#' Combine RDA files into package data tables
#'
#'  Step 3 of updating `azmpdata`, combines all `.rda` files from data-raw into organized package data tables based on temporal, spatial and categorical scales.
#'
#' @importFrom utils data read.csv
#' @author Emily Chisholm
#' @export
#'
#'
combine_all_data <- function(){
  # add functionality to specify updating only particular data frames?
# dd <- data(package = 'azmpdata')
# allpkgdata <- dd$results[,3]

  allpkgdata <- list.files(path = 'data-raw', pattern = '.rda', full.names = TRUE)
  pkgdata <- list.files(path = 'data-raw', pattern = '.rda')
  pkgdata <- gsub(pkgdata, pattern = '.rda', replacement = '')
dat <- list()
for(i in 1:length(allpkgdata)){
   eval(parse(text = paste0('load("',allpkgdata[[i]],'")')))
}

# get all variable names

varnames <- list()
for(i in 1:length(pkgdata)){
  varnames[[i]] <- eval(parse(text = paste('names(',pkgdata[[i]],')')))
}
names(varnames) <- pkgdata

# remove metadata names
metanames <- c('year', 'month', 'day', 'area_name', 'section_name', 'station_name' )

datnames <- unlist(varnames)[!unlist(varnames) %in% metanames]


# check that all variable names are valid

varlookup <- read.csv('inst/extdata/lookup/variable_look_up.csv')

nonames <- datnames[!datnames %in% varlookup$variable_name]

if(length(nonames) > 0 ){
  stop(paste('Invalid variable name detected:', nonames,'\n'))
}

# find where each variable belongs

# datfiles <- varlookup$file_name[varlookup$variable_name %in% datnames]

filelist <- list()
for(i in 1:length(datnames)){
  varindex <- grep(datnames[[i]], x = varnames)

  varlist <- list()
  for(ii in 1:length(varindex)){
  ogdatfile <- names(varnames)[varindex[[ii]]]

  newdatfile <- unique(varlookup$file_name[varlookup$variable_name == datnames[[i]]])

  if(length(newdatfile) > 1){
    v2 <- varnames[varindex][[ii]]
    metacol <- v2[v2 %in% metanames]

    # get temporal scale narrowed down

    if('year' %in% metacol ){
      ndf2 <- grep(newdatfile, pattern = 'Annual', value = TRUE)
    }

    if('year' %in% metacol && 'month' %in% metacol){
      ndf2 <- grep(newdatfile, pattern = 'Monthly', value = TRUE)
    }

    if('year' %in% metacol && 'month' %in% metacol && 'day' %in% metacol){
      ndf2 <- grep(newdatfile, pattern = 'Occupations', value = TRUE)
    }

    if(!exists('ndf2')){
      stop('Could not find appropriate file to insert variable [', datnames[[i]], '] \n')
    }
    newdatfile <- ndf2
    remove(ndf2)

    # narrow down geographic scale

    if(length(newdatfile) > 1){
      if('station_name' %in% metacol){
        ndf3 <- grep(newdatfile, pattern = 'Station', value = TRUE)
      }
      if('section_name' %in% metacol){
        ndf3 <- grep(newdatfile, pattern = 'Section', value = TRUE)
      }
      if('area_name' %in% metacol){
        ndf3 <- grep(newdatfile, pattern = 'Broadscale', value = TRUE)
      }
      if(!exists('ndf3') | length(ndf3) == 0){
        stop('Could not find appropriate file to insert variable [', datnames[[i]], '] \n')
      }
      newdatfile <- ndf3
      remove(ndf3)
    }



  }
  varlist[[ii]] <- c(orig = ogdatfile, new = newdatfile)
  names(varlist)[[ii]] <- datnames[[i]]
  }
  filelist[[i]] <- varlist

}


# need to update if Benoit's data is already in formatted data files

# load package data
 dd <- data(package = 'azmpdata')
 offdata <- dd$results[,3]

 for (i in 1:length(filelist)){
   # find which file data belongs in
   original <- filelist[[i]]
   varname <- names(original)

   # catch for some varaibles which are in seperate files
   for(ii in 1:length(original)){
     ogfilename <- original[[ii]][['orig']]
     newfilename <- original[[ii]][['new']]

     # try to load in existing dataframe
     eval(parse(text = paste("data(", newfilename, ")")))

     # grab just one variable and all meta
     eval(parse(text = paste("metacols <- names(",ogfilename,")[names(", ogfilename, ") %in% metanames]")))
     eval(parse(text = paste("newdataframe <-", ogfilename," %>% select(c(all_of(metacols), all_of(varname)))")))

     # if data is not already formatted, create new data frame
     if(!exists(newfilename)){
       eval(parse(text = paste(newfilename, "<- newdataframe")))
     } else{ # else add data to existing df
       eval(parse(text = paste(newfilename," <- ", newfilename , "%>% dplyr::full_join(newdataframe)")))
     }


   }

 }


# combine data into new files
#
# for (i in 1:length(filelist)){
#   original <- filelist[[i]]
#   varname <- names(original)
#
#   for(ii in 1:length(original)){
#     ogfilename <- original[[ii]][['orig']]
#
#     eval(parse(text = paste("metacols <- names(",ogfilename,")[names(", ogfilename, ") %in% metanames]")))
#
#
#     eval(parse(text = paste("newdataframe <-", ogfilename," %>% select(c(all_of(metacols), all_of(varname)))")))
#
#     newfilename <- original[[ii]][['new']]
#
#     # eval(parse(text = paste("data(", newfilename, ")")))
#
#     # check for existing data frame
#
#     #TODO change this system so that the same data is not added multiple times
#     # maybe combine all data for particular frame first then write to RDA?
#     # alldat <- data(package = 'azmpdata')
#     # alldat <- alldat$results[,3]
#
#     if( exists(newfilename)){ # newfilename %in% alldat |
#       # eval(parse(text = paste("data(", newfilename, ")")))
#
#       eval(parse(text = paste(newfilename," <- ", newfilename , "%>% dplyr::full_join(newdataframe)"))) # TODO untested check that we are not overwriting data and that join happens properly
#
#     }else{ # if we are creating the data frame for the first time
#       eval(parse(text = paste(newfilename, "<- newdataframe")))
#     }
#
#
#   }
#
# }
#


# GET ALL NEW DATA NAMES

alldd <- unlist(filelist)
ind <- grep(names(alldd), pattern = 'new')

allnewdd <- unique(alldd[ind])

 for (i in 1:length(allnewdd)){
# save as RDA (move?)
   eval(parse(text = paste("usethis::use_data(", allnewdd[[i]], ", overwrite = TRUE)")))

# save as csv files as well
   eval(parse(text = paste("write.csv(",allnewdd[[i]],", file = paste0('inst/extdata/', allnewdd[[i]], '.csv'), quote = FALSE, row.names = FALSE)")))

 }






}
