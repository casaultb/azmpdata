# data update
# updates txt file verytime data is loaded, should be called by all data loading functions (not yet fully implemented)
# E. Chisholm, Sept. 2020


data_update <- function(date = NULL){
  # datefn <- system.file('extdata/', 'datadate.txt', package = 'azmpdata')

    fnpath <- system.file('extdata/', package = 'azmpdata')
    # create file
    sink(file = file.path(fnpath, 'datadate.txt'))
      cat(format(Sys.time(), format = '%Y-%m-%d'))
    sink()

}


