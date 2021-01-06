# source all data processing scripts to recreate dataframes
# warning this script should only be run by developers or data managers when updating data

# get all .R processing files

files <- list.files('inst/extdata/', pattern = '*.R$', ignore.case = TRUE, recursive = TRUE, full.names = TRUE)

# source all files to create data products
lapply(files, source)

# update datadate.txt to reflect latest data update
data_update()
