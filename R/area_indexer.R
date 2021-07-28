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
#' @param parameters default is \code{NULL}.  Many parameters exist - any named parameter found in
#' any data file should work.  (e.g. \code{area_indexer(parameters=c("Arctic_Calanus_species",
#' "integrated_phosphate_50"))})
#' @param datafiles default is \code{NULL}.  If you want to restrict the available data to just that
#' contained by one or more particular azmpdata data files, a vector of the files to check can be
#' provided.  .  (e.g. \code{area_indexer(datafiles=c("Ice_Annual_Broadscale"))})  A complete list
#' of the available files can be seen by checking \code{data(package="azmpdata")}
#' @param months default is \code{NULL}.  If you want to restrict the available data by one or more
#' months, a vector of desired months can be provided (e.g. \code{area_indexer(months=c(1,2,3,4))})
#' @param doParameters default is \code{F}.  Identifying all of the parameters that were collected
#' at each combination of area/site/year is a bit more intensive than leaving them out.  To force
#' this function to do this, set this parameter to \code{doParameters=T}.  If one or more parameters
#' are provided, the function will override this default value and set \code{doParameters=F}
#' @param doMonths default is \code{F}. If this is set to \code{TRUE}, the results will include
#' information about what month the data was collected (when available).
#' @param quiet default is \code{F}.  If invalid parameters are sent, this function will alert the user
#' of  the available valid values.  If set to T, the message will be hidden.
#' @return a data.frame
#' @examples \dontrun{
#' allAreas <- area_indexer()
#'
#' allAreas_w_Parameters <- area_indexer(doParameters =T)
#'
#' areaAreas_2018_2020 <- area_indexer(years=c(2018,2019,2020))
#'
#' some_HLData <- area_indexer(areanames=c("HL","HL2"))
#'
#' sections_2017 <- area_indexer(areaTypes=c("section"), year = 2017)
#'
#' specificParameters_2000s <- area_indexer(parameters=c("Arctic_Calanus_species",
#'                                          "integrated_phosphate_50"), year=c(2000:2009))
#' februaryParameters <-area_indexer(doMonths = T, months = 2, doParameters = T)
#' }
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @export
area_indexer <- function(years = NULL, areanames = NULL, areaTypes = NULL, datafiles = NULL, months = NULL, doMonths = F, quiet = F, doParameters =F, parameters = NULL){
  area <- areaType <- areaname <- section <- station <- parameter <- month <- NA

  areanames <- toupper(areanames)
  areaTypes <- toupper(areaTypes)
  datafiles <- toupper(datafiles)
  parameters <- toupper(parameters)
  if (length(months)>0 & !doMonths){
    doMonths <- T
    message("Because months were provided as a filter, the function has set doMonths = T.\n
            To avoid seeing this message, please include 'doMonths=T'")
  }

  if (length(parameters)>0 & !doParameters){
    doParameters <- T
    message("Because parameters were provided as a filter, the function has set doParameters = T.\n
            To avoid seeing this message, please include 'doParameters=T'")
  }

  res <- data(package = 'azmpdata')
  file_names <- res$results[,3]
  if (length(datafiles)>0) file_names <- file_names[tolower(file_names) %in% tolower(datafiles)]
  area_index_chk <- function(param = NULL, fail=F){
    allValidVals <- paste(sort(unique(area_year_df_o[,param])), collapse=",")
    res<- paste0("Valid values for ",param, " include:\n",allValidVals)
    if (fail) {
      stop("None of your value(s) for ",param, " was not found in the data, ",paste(res))
    }else{
      if (!quiet) message("One or more of value(s) for ",param, " was not found in the data, ",paste(res))
    }
  }

  if (!doParameters){
    area_year_df <- data.frame(year = integer(), dataframe = character(), area=character(), section=character(), station=character() )
    area_year_fields <- c("year", "dataframe", "area","section", "station")
    coord_fields <- c("latitude","longitude")

    if (doMonths){
      area_year_df$month <- character()
      area_year_fields <- c(area_year_fields, "month")
    }
    for(i_file in file_names){
      df <- get(i_file)
      var_names <- names(df)
      if (area_year_fields[1] %in% var_names & any(area_year_fields[2:length(area_year_fields)] %in% var_names)){
        this_df <- df[,names(df) %in% area_year_fields]
        this_df[setdiff(names(area_year_df), names(this_df))]<-NA
        this_df$dataframe <- i_file
        if (!doMonths){
          this_df <- this_df[,c("year","dataframe","area","section", "station")]
        }else{
          this_df <- this_df[,c("year","dataframe","area","section", "station", "month")]
        }
        area_year_df <- rbind.data.frame(area_year_df,this_df)
        rm(list = c("this_df"))
      }
      if (all(coord_fields %in% var_names)){

        this_df1 <- df[!is.na(df$latitude) & !is.na(df$longitude),]
        if ("station" %in% names(this_df1)) this_df1<-this_df1[is.na(this_df1$station),]

        if (nrow(this_df1)>0) {
          if (!quiet) message(paste0("\n",i_file ,": contains coordinates that are not associated with any named stations"))
        }
        rm(list = c("this_df1"))
      }
      rm(list = c("var_names","i_file"))
    }
    area_year_df_yr <- tidyr::gather(area_year_df, areaType, areaname, area, section, station, dataframe)
    area_year_df_yr <- unique(area_year_df_yr[!is.na(area_year_df_yr$areaname),])

    if (doMonths){
      # area_year_df_yr$month <- NULL
      area_year_df_mo <- area_year_df
      area_year_df_mo$year <- NULL
      area_year_df_mo$month <- as.integer(area_year_df_mo$month)
      area_year_df_mo <-  tidyr::gather(area_year_df_mo, areaType, areaname, area, section, station)
      area_year_df_mo <- unique(area_year_df_mo[!is.na(area_year_df_mo$areaname) & !is.na(area_year_df_mo$month),])
      area_year_df <- unique(merge(area_year_df_yr, area_year_df_mo, all.x = T))
    }else{
      area_year_df <- area_year_df_yr
    }
  }else{
    area_year_df <- data.frame(year = integer(), dataframe = character(), area=character(), section=character(), station=character(), parameter=character())
    area_year_fields <- c("year", "area","section", "station", "parameter")
    non_param_fields <- c(area_year_fields, "dataframe","latitude","longitude", "cruisenumber","month", "day", "event_id", "depth", "standard_depth","sample_id","nominal_depth","doy", "season" )

    if (doMonths){
      area_year_df$month <- character()
      area_year_fields <- c(area_year_fields, "month")
    }


    for(i_file in file_names){
      message(i_file)
      df <- get(i_file)
      df[setdiff(names(area_year_df), names(df))]<- NA
      theseAreaFields <- names(df)[names(df) %in% area_year_fields]
      theseParamsFields <- names(df)[!tolower(names(df)) %in% non_param_fields]
      if (length(parameters)>0) theseParamsFields <- tolower(parameters)

      if (!any(theseParamsFields %in% colnames(df))){
        next
      }
      if (doMonths & "month" %in% colnames(df)){
        df<- unique(df[which(!is.na(df$month)),])

      }else{
        next
      }
      df <- df[,c(theseAreaFields, theseParamsFields)]
      for (p in 1:length(theseParamsFields)){
        df_p <- unique(df[!is.na(df[theseParamsFields[p]]),area_year_fields])
        if (length(areaTypes)>0) df_p <- unique(df[df$areaType== areaTypes,area_year_fields])
        if (nrow(df_p)>0){
          df_p$parameter <- theseParamsFields[p]
          df_p$dataframe <- i_file
          message(theseParamsFields[p])
          area_year_df <- rbind.data.frame(area_year_df,df_p)
        }
        rm(list = c( "df_p"))
      }
      rm(list = c( "theseAreaFields", "theseParamsFields","df"))
    }

    if (nrow(area_year_df)<1){
      message("No data matches your filters")
      return(NULL)
    }else{
      message(colnames(area_year_df))
    }
    area_year_df_yr= tidyr::gather(area_year_df, areaType, areaname, area, section, station, -dataframe, -parameter)
    area_year_df_yr <- unique(area_year_df_yr)
    if (doMonths){
      area_year_df_yr$month <- NULL
      area_year_df_mo <- area_year_df
      area_year_df_mo$year <- NULL
      area_year_df_mo$month <- as.integer(area_year_df_mo$month)
      area_year_df_mo <-  tidyr::gather(area_year_df_mo, areaType, areaname, area, section, station)
      area_year_df_mo <- unique(area_year_df_mo[!is.na(area_year_df_mo$areaname) & !is.na(area_year_df_mo$month),])
      area_year_df = merge(area_year_df_yr, area_year_df_mo, all.x = T)
      area_year_df = unique(area_year_df[which(!is.na(area_year_df$month)),])
    }else{
      area_year_df <- area_year_df_yr
      area_year_df = unique(area_year_df[which(!is.na(area_year_df$month)),])
    }
  }
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

  if(doParameters & length(parameters)>0){
    if (!any(parameters %in% toupper(area_year_df$parameter))) area_index_chk("parameter", fail = T)
    if (!all(parameters %in% toupper(area_year_df$parameter))) area_index_chk("parameter", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$parameter) %in% parameters,]
  }

  if(length(datafiles)>0){
    if (!any(datafiles %in% toupper(area_year_df$dataframe))) area_index_chk("dataframe", fail = T)
    if (!all(datafiles %in% toupper(area_year_df$dataframe))) area_index_chk("dataframe", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$dataframe) %in% datafiles,]
  }

  if(doMonths & length(months)>0){
    if (!any(months %in% toupper(area_year_df$month))) area_index_chk("month", fail = T)
    if (!all(months %in% toupper(area_year_df$month))) area_index_chk("month", fail = F)
    area_year_df <- area_year_df[toupper(area_year_df$month) %in% months,]
  }

  area_year_df = area_year_df[with(area_year_df, order(year, dataframe, areaname)), ]
  return(area_year_df)
}
