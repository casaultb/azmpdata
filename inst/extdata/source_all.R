# source all data processing scripts to recreate dataframes
# warning this script should only be run by developers or data managers when updating data
library(azmpdata) # need it for read.physical
# get all .R processing files
files <- list.files('inst/extdata', pattern = '*.R$', ignore.case = TRUE, recursive = TRUE, full.names = TRUE)
files <- setdiff(files, c("inst/extdata/source_all.R",
                          # "inst/extdata/derived/Derived_Monthly_Broadscale.R",   # error html connection to be fixed
                          "inst/extdata/derived/Derived_Monthly_Stations.R",   # problem with read_physical for seaLevelHeight files
                          "inst/extdata/remote_sensing/RemoteSensing_Annual_Broadscale.R",  # data removed from package
                          "inst/extdata/remote_sensing/RemoteSensing_Weekly_Broadscale.R",  # data removed from package
                          "inst/extdata/ice/Ice_Annual_Broadscale.R"))    # input data need to be updated
cat(paste(files, collapse = '\n'))

# source all files to create data products
lapply(files, source)
cat(paste(files, collapse = '\n')) # how come after the above line is ran, the variable 'files' gets removed ?


# update datadate.txt to reflect latest data update
fnpath <- system.file('extdata/', package = 'azmpdata')
# create file
sink(file = file.path(fnpath, 'datadate.txt'))
cat(format(Sys.time(), format = '%Y-%m-%d'), '\n')
sink()
