#' @title area_indexer
#' @description This function assemble a dataframe consisting of the years and areas where the azmpdata
#' packages\'s data has been collected, as well as the associated file where the data can be found.
#' @param years default is \code{NULL}.  If you want to restrict the available data by one or more
#' years, a vector of desired years can be provided (e.g. \code{area_indexer(years=c(2017,2018))})
#' @param areanames default is \code{NULL}.  If you want to restrict the available data by one or
#' more specific named areas, a vector of them can be provided (e.g. \code{area_indexer(areanames=c("HL","HL2"))})
#' @param areaTypes default is \code{NULL}.  If you want to restrict the available data by one or more
#' area "types", a vector of desired types can be provided.  Valid values for areaTypes are:
#' "area", "section", and "station".  (e.g. \code{area_indexer(areaTypes=c("section"))})
#' @param datafiles default is \code{NULL}.  If you want to restrict the available data to just that
#' contained by one or more particular azmpdata data files, a vector of the files to check can be
#' provided.  .  (e.g. \code{area_indexer(datafiles=c("Ice_Annual_Broadscale"))})  A complete list
#' of the available files can be seen by checking \code{data(package="azmpdata")}
#' @param quiet default is \code{F}.  If invalid parameters are sent, this function will alert the user
#' of  the available valid values.  If set to T, the message will be hidden.
#' @return a data.frame
#' @family general_use
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @note This is a duplicate of what exists in https://github.com/Maritimes/Mar.utils/blob/master/R/df2sf.R.
#' It is copied, rather than added as a dependency to reduce the number of packages necessary.
#' @export
area_indexer <- function(years = NULL, areanames = NULL, areaTypes = NULL, datafiles = NULL, quiet = F){
  area <- areaType <- areaname <- section <- station <- NA
  areanames <- toupper(areanames)
  areaTypes <- toupper(areaTypes)
  datafiles <- toupper(datafiles)

  area_index_chk <- function(param = NULL, fail=F){
    allValidVals <- paste(sort(unique(area_year_df_o[,param])), collapse=",")
    res<- paste0("Valid values for ",param, " include:\n",allValidVals)
    if (fail) {
      stop("None of your value(s) for ",param, " was not found in the data, ",paste(res))
    }else{
      if (!quiet) message("One or more of value(s) for ",param, " was not found in the data, ",paste(res))
    }
  }
  area_year_df <- data.frame(year = integer(), dataframe = character(), area=character(), section=character(), station=character() )
  area_year_fields <- c("year", "area","section", "station")
  res <- data(package = 'azmpdata')
  file_names <- res$results[,3]
  for(i_file in file_names){
    df <- get(i_file)
    var_names <- names(df)
    if (area_year_fields[1] %in% var_names & any(area_year_fields[2:length(area_year_fields)] %in% var_names)){
      this_df <- df[,names(df) %in% area_year_fields]
      this_df$dataframe <- i_file
      this_df[setdiff(names(area_year_df), names(this_df))]<-NA
      this_df <- this_df[,c("year", "dataframe","area","section", "station")]
      area_year_df <- rbind.data.frame(area_year_df,this_df)
      rm(list = c("var_names","this_df"))
    }
    remove(i_file)
  }
  area_year_df= tidyr::gather(area_year_df, areaType, areaname, area, section, station)
  area_year_df <- unique(area_year_df[!is.na(area_year_df$areaname),])
  area_year_df_o <- area_year_df

  if(length(years)>0){
    if (!any(years %in% area_year_df$year)) area_index_chk("year", fail = T)
    if (!all(years %in% area_year_df$year)) area_index_chk("year", fail = F)
    area_year_df <- area_year_df[area_year_df$year %in% years,]
  }

  if(length(areanames)>0){
    if (!any(areanames %in% toupper(area_year_df$areaname))) area_index_chk("areaname", fail = T)
    if (!all(areanames %in% toupper(area_year_df$areaname))) area_index_chk("areaname", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$areaname) %in% areanames,]
  }

  if(length(areaTypes)>0){
    if (!any(areaTypes %in% toupper(area_year_df$areaType))) area_index_chk("areaType", fail = T)
    if (!all(areaTypes %in% toupper(area_year_df$areaType))) area_index_chk("areaType", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$areaType) %in% areaTypes,]
  }

  if(length(datafiles)>0){
    if (!any(datafiles %in% toupper(area_year_df$dataframe))) area_index_chk("dataframe", fail = T)
    if (!all(datafiles %in% toupper(area_year_df$dataframe))) area_index_chk("dataframe", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$dataframe) %in% datafiles,]
  }

  area_year_df = area_year_df[with(area_year_df, order(year, dataframe, areaname)), ]
  return(area_year_df)
}
