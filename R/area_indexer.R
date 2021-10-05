#' @title area_indexer
#' @description This function assembles a dataframe consisting of the years and areas where the azmpdata
#' packages\'s data has been collected, as well as the associated file(s) where the data can be found.
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
#' @param months default is \code{NULL}.  If you want to restrict the available data by one or more
#' months, a vector of desired months can be provided (e.g. \code{area_indexer(months=c(1,2,3,4))})
#' @param doParameters default is \code{F}.  Identifying all of the parameters that were collected
#' at each combination of area/site/year is a bit more intensive than leaving them out.  To force
#' this function to do this, set this parameter to \code{doParameters=T}.  If one or more parameters
#' are provided, the function will override this default value and set \code{doParameters=F}
#' @param parameters default is \code{NULL}.  Many parameters exist - any named parameter found in
#' any data file should work.  (e.g. \code{area_indexer(parameters=c("Arctic_Calanus_species",
#' "integrated_phosphate_50"))})
#' @param fuzzyParameters  default is \code{T}.  By default, any discovered parameters that match
#'  values within \code{parameters} will be returned.  For example, \code{parameter="nitrate"} will
#'  return fields such as "integrated_nitrate_0_50", "integrated_nitrate_50_150", and "nitrate".  If
#'  you want exact matches only, set \code{fuzzyParameters = F}.
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
#'                                          "integrated_phosphate_0_50"), year=c(2000:2009))
#' februaryParameters <-area_indexer(doMonths = T, months = 2, doParameters = T)
#' }
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @note Note that each additional filter that gets sent will reduce the number of results returned.
#' For example, if \code{doMonths = TRUE} and \code{years = 2010}, only those results from 2010 that
#' also have monthly data will be returned.
#' @export
#'
area_indexer <- function(years = NULL, areanames = NULL, areaTypes = NULL, datafiles = NULL, months = NULL, doMonths = F, doParameters =F, parameters = NULL, fuzzyParameters = TRUE, qcMode = F){
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
  core_fields <- c("year", "area","section", "station","datafile")
  # area_year_fields <- core_fields
  coord_fields <- c("latitude","longitude")
  non_param_fields <- c(core_fields, "datafile","latitude","longitude", "cruisenumber","month",
                        "day", "event_id", "depth", "standard_depth","sample_id","nominal_depth",
                        "doy", "season","descriptor" )

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
    df$datafile <- i_file

    if ("doy" %in% names(df) & "year" %in% names(df))
    {
      df$month <- lubridate::month(as.Date(df$doy, origin = paste0(df$year,"-01-01")))
    }

    if (i_file %in% c("Derived_Occupations_Sections", "Discrete_Occupations_Sections")){
      #there are cases where the station information also exists in the section file
      #retaining the station info in these files results in duplicated data (for plot_availability)
      #first found with:  if (length(var_names[var_names %in% c("station", "section")])==2){
      if (i_file == "Discrete_Occupations_Sections") df <- Discrete_Occupations_Sections[!Discrete_Occupations_Sections$sample_id %in% Discrete_Occupations_Stations$sample_id,]
      if (i_file == "Derived_Occupations_Sections") df <- Derived_Occupations_Sections[!Derived_Occupations_Sections$event_id %in% Derived_Occupations_Stations$event_id,]
    }

    if (qcMode & all(coord_fields %in% var_names)){
      #this bit just checks for specific cases of coordinates with no associated stations.
      this_df1 <- df[!is.na(df$latitude) & !is.na(df$longitude),]
      if ("station" %in% names(this_df1)) this_df1<-this_df1[is.na(this_df1$station),]
      if (nrow(this_df1)>0) message(paste0("\n",i_file ,": contains coordinates that are not associated with any named stations"))
      rm(list = c("this_df1"))
    }

    #Have ensured file has sufficient info to proceed (i.e. a year, and at least one of area, section or station)
    df_core <- df[,names(df) %in% core_fields, drop=FALSE]
    these_core_fields <- var_names[var_names != "year" & var_names %in% colnames(df_core)]
    if (length(these_core_fields)<1)next
    df_core<-unique(df_core[stats::complete.cases(df_core[, these_core_fields]), ])
    if (nrow(df_core)<1)next
    df_core[setdiff(core_fields, names(df_core))]<-NA

    #df_det contains all of the info from this file we can use
    df_det <- merge(df, df_core)
    colnames(df_det) <- tolower(colnames(df_det))
    rm(list=c("df", "df_core", "var_names"))

    #below are checks for all of the filters that might be applied.  Failing any skips the file
    #note that cumulatively when combined, the file can still fail
    #this step should speed up processing considerably
    if(length(years)>0 & nrow(df_det[df_det$year %in% years,])<1) proceed <- FALSE
    if(length(areanames)>0 & nrow(df_det[tolower(df_det$area) %in% areanames |
                                         tolower(df_det$station) %in% areanames |
                                         tolower(df_det$section) %in% areanames ,])<1) proceed <- FALSE
    if(length(areaTypes)>0 & !any(colnames(df_det) %in% areaTypes)) proceed <- FALSE

    if (!fuzzyParameters){
      if((doParameters & length(parameters)>0) & !any(parameters %in% colnames(df_det))) proceed <- FALSE
    } else{
      if ((doParameters & length(parameters)>0)){
        matches <- FALSE
        for (r in 1:length(parameters)){
          if (length(tolower(colnames(df_det)[grep(pattern = parameters[r], x=colnames(df_det))]))>0) matches <- TRUE
        }
        if (!matches) proceed <- FALSE
      }
    }

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
      df_det <- unique(merge(df_det,df_mon))
      rm(list=c("df_mon"))
    }

    if (doParameters){
      theseParamsFields <- names(df_det)[!tolower(names(df_det)) %in% non_param_fields]
      fileParams <- df_det[F,]
      if (!fuzzyParameters & length(parameters)>0) {
        theseParamsFields <- tolower(parameters)
      }else if (fuzzyParameters & length(parameters)>0){
        theseParamsFields <- NA
        for (q in 1:length(parameters)){
          thisParamsFields <- tolower(colnames(df_det)[grep(pattern = parameters[q], x=colnames(df_det))])
          theseParamsFields <- c(theseParamsFields, thisParamsFields)
          theseParamsFields <- theseParamsFields[!is.na(theseParamsFields)]
        }
      }
      for (p in 1:length(theseParamsFields)){
        if (qcMode){
          # there's potential for badly-entered data - 0 length strings, and written out "NA"
          if (nrow(df_det[which(nchar(df_det[,theseParamsFields[p]])<1),])>0) message(paste0("Within ",i_file," in the field '",theseParamsFields[p],"', empty (i.e. not-NA) cells were found."))
          if (nrow(df_det[which(df_det[,theseParamsFields[p]] == "NA"),])>0) message(paste0("Within ",i_file," in the field '",theseParamsFields[p],"', cells were found with 'NA' physically typed into it."))
        }
        #remove them

        this_params <- df_det[which(nchar(df_det[,theseParamsFields[p]])>0 &
                                      df_det[,theseParamsFields[p]] != "NA" &
                                      !is.na(df_det[,theseParamsFields[p]])),c(core_fields,theseParamsFields[p])]


        if (nrow(this_params)<1)next

        this_params[is.na(this_params)] <- -999
        this_paramsOrig<-this_params
        if (doMonths ){

          this_params <- aggregate(
            x = list(cnt = this_params$month),
            by = list(year = this_params$year ,
                      area = this_params$area,
                      section = this_params$section,
                      station = this_params$station,
                      parameter = this_params$parameter,
                      month = this_params$month
            ),
            length
          )
        }else{
          this_params <- unique(df_det[nchar(df_det[,theseParamsFields[p]])>0 &
                                         df_det[,theseParamsFields[p]] != "NA" &
                                         !is.na(df_det[theseParamsFields[p]]) ,core_fields])
        }

        this_params[this_params == -999] <- NA


        # colnames(this_params)[colnames(this_params)=="cnt"] <- paste0("cnt",theseParamsFields[p])

        # this_params <- unique(df_det[nchar(df_det[,theseParamsFields[p]])>0 &
        #                                df_det[,theseParamsFields[p]] != "NA" &
        #                                !is.na(df_det[theseParamsFields[p]]) ,core_fields])
        if (nrow(this_params)<1)next
        this_params$parameter <- theseParamsFields[p]
        fileParams <-rbind.data.frame(fileParams,this_params)
      }
      df_det <- fileParams
      rm(list=c("fileParams"))
    }

    if (!doParameters) df_det <- unique(df_det[,core_fields])
    if (nrow(df_det)<1) next
    df_det$datafile <- i_file
    result_df <- rbind.data.frame(result_df, df_det)
    rm(list=c("df_det"))
  }

  return(result_df)
}
