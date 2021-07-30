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
#' @param qcMode default is \code{F}. Information about unexpected values will be shown.
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
#'
area_indexer <- function(years = NULL, areanames = NULL, areaTypes = NULL, datafiles = NULL, months = NULL, doMonths = F, doParameters =F, parameters = NULL, qcMode = F){
  area <- areaType <- areaname <- section <- station <- parameter <- month <- NA

  areanames <- tolower(areanames)
  areaTypes <- tolower(areaTypes)
  datafiles <- tolower(datafiles)
  parameters <- tolower(parameters)
  if (length(months)>0){
    months <- as.integer(months)
    if (!doMonths) doMonths <- T
  }
  if (length(parameters)>0 & !doParameters){
    doParameters <- T
  }

  result_df <- data.frame(year = integer(), area=character(), section=character(), station=character(), datafile = character() )
  core_fields <- c("year", "area","section", "station")
  # area_year_fields <- core_fields
  coord_fields <- c("latitude","longitude")
  non_param_fields <- c(core_fields, "datafile","latitude","longitude", "cruisenumber","month",
                        "day", "event_id", "depth", "standard_depth","sample_id","nominal_depth",
                        "doy", "season" )

  if (doParameters) {
    result_df$parameter <- character()
    core_fields <- c(core_fields, "parameter")
  }
  if (doMonths) {
    result_df$month <- integer()
    core_fields <- c(core_fields, "month")
  }

  res <- data(package = 'azmpdata')
  file_names <- res$results[,3]

  if (length(datafiles)>0) file_names <- file_names[tolower(file_names) %in% tolower(datafiles)]

  for(i_file in file_names){
    proceed <- TRUE
    df <- get(i_file)
    var_names <- names(df)
    if (qcMode & all(coord_fields %in% var_names)){
      #this bit just checks for specific cases of coordinates with no associated stations.
      this_df1 <- df[!is.na(df$latitude) & !is.na(df$longitude),]
      if ("station" %in% names(this_df1)) this_df1<-this_df1[is.na(this_df1$station),]
      if (nrow(this_df1)>0) message(paste0("\n",i_file ,": contains coordinates that are not associated with any named stations"))
      rm(list = c("this_df1"))
    }

    # if(i_file == "Zooplankton_Occupations_Broadscale")browser()
    #Have ensured file has sufficient info to proceed (i.e. a year, and at least one of area, section or station)
    df_core <- df[,names(df) %in% core_fields, drop=FALSE]
    these_core_fields <- var_names[var_names != "year" & var_names %in% colnames(df_core)]
    if (length(these_core_fields)<1)next
    df_core<-unique(df_core[complete.cases(df_core[, these_core_fields]), ])
    if (nrow(df_core)<1)next
    df_core[setdiff(core_fields, names(df_core))]<-NA

    #df_det contains all of the info from this file we can use
    df_det <- merge(df, df_core)
    rm(list=c("df", "df_core", "var_names"))

    #below are checks for all of the filters that might be applied.  Failing any skips the file
    #note that cumulatively when combined, the file can still fail
    #this step should speed up processing considerably
    if(length(years)>0 & nrow(df_det[df_det$year %in% years,])<1) proceed <- FALSE
    if(length(areanames)>0 & nrow(df_det[tolower(df_det$area) %in% areanames |
                                         tolower(df_det$station) %in% areanames |
                                         tolower(df_det$section) %in% areanames ,])<1) proceed <- FALSE
    if(length(areaTypes)>0 & !any(colnames(df_det) %in% areaTypes)) proceed <- FALSE
    if((doParameters & length(parameters)>0) & !any(parameters %in% colnames(df_det))) proceed <- FALSE
    if(doMonths & length(months)>0 & nrow(df_det[tolower(df_det$month) %in% months,])<1) proceed <- FALSE
    if(!proceed) {
      rm(list=c("df_det"))
      next
    }

    #established this file is potentially useful, do the simple filters
    if(length(years)>0)  {
      df_det <- df_det[df_det$year %in% years,]
      if (nrow(df_det)<1) {
        next
      }
    }

    if(length(areanames)>0) {
      df_det<- df_det[tolower(df_det$area) %in% areanames |
                        tolower(df_det$station) %in% areanames |
                        tolower(df_det$section) %in% areanames,]
      if (nrow(df_det)<1) {
        next
      }
    }
    if(length(areaTypes)>0) {
      df_det[tolower(df_det$areaType) %in% areaTypes,]
      if (nrow(df_det)<1) {
        next
      }
    }

    ####
    # all initial checks passed for this file - parsing....
    ####

    if (doMonths){
      df_mon <- df_det[which(!is.na(df_det$month)),core_fields]
      if (nrow(df_mon)<1)next
      if (qcMode & is.character(df_mon$month)) message(paste0("Within ",i_file,", the 'month' field is a text field (not an integer)"))
      if (is.character(df_mon$month)) df_mon$month <- as.integer(df_mon$month)
      if (length(months)>0) df_mon <-df_mon[which(df_mon$month %in% months),]
      if (nrow(df_mon)<1)next
      df_det <- merge(df_det,df_mon)
      rm(list=c("df_mon"))
    }

    if (doParameters){
      theseParamsFields <- names(df_det)[!tolower(names(df_det)) %in% non_param_fields]
      fileParams <- df_det[F,]
      if (length(parameters)>0) theseParamsFields <- tolower(parameters)
      for (p in 1:length(theseParamsFields)){
        # there's potential for badly-entered data - 0 length strings, and written out "NA"
        if (qcMode){
          #let the user know
          if (nrow(df_det[nchar(df_det[,theseParamsFields[p]])<1,])>0) message(paste0("Within ",i_file," in the field '",theseParamsFields[p],"', empty (i.e. not-NA) cells were found."))
          if (nrow(df_det[df_det[,theseParamsFields[p]] == "NA",])>0) message(paste0("Within ",i_file," in the field '",theseParamsFields[p],"', cells were found with 'NA' physically typed into it."))
        }
        #remove them
        this_params <- unique(df_det[nchar(df_det[,theseParamsFields[p]])>0 &
                                       df_det[,theseParamsFields[p]] != "NA" &
                                       !is.na(df_det[theseParamsFields[p]]) ,core_fields])
        if (nrow(this_params)<1)next
        this_params$parameter <- theseParamsFields[p]
        fileParams <-rbind.data.frame(fileParams,this_params)
      }
      df_det <- fileParams
      rm(list=c("fileParams"))
    }

    if (!doParameters) df_det <- unique(df_det[,core_fields])

    df_det$datafile <- i_file
    result_df <- rbind.data.frame(result_df, df_det)
    rm(list=c("df_det"))
  }
  return(result_df)
}
