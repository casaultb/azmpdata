#' @title plot_availability
#' @description This generates a score card of samples per month based on areaType, areaName, and parameter.
#' @param areaType default is \code{NULL}. Indicates which type of area is of interest. The options are section, station, or area.
#' @param areaName default is \code{NULL}. Indicates which area is of interest. The options are dependent on the areaType, however, a error message will let the user know which options are available.
#' @param parameters default is \code{NULL}. Indicates which parameter is of interest. This is dependent on areaType and areaName, however, an error message will let the user know which options are available.
#' @param fuzzyParameters  default is \code{TRUE}.  By default, any discovered parameters that match
#'  values within \code{parameters} will be returned.  For example, \code{parameter="nitrate"} will
#'  return fields such as "integrated_nitrate_0_50", "integrated_nitrate_50_150", and "nitrate".  If
#'  you want exact matches only, set \code{fuzzyParameters = F}.
#' @examples \dontrun{
#' plot_availability(areaType="station", areaName="P5", parameter="nitrate")
#' }
#' @author  Jaimie Harbin \email{jaimie.harbin@@dfo-mpo.gc.ca}
#' @author Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @importFrom stats aggregate reshape
#' @importFrom oce colormap imagep
#' @import graphics
#' @export
plot_availability <- function(areaType=NULL,
                               areaName=NULL,
                               parameters=NULL,
                               fuzzyParameters = FALSE
)
{
    if (length(areaName) > 1)   stop("in plot_availability() :\n  can only provide one areaName at a time", call.=FALSE)
    if (is.null(areaType))      stop("in plot_availability() :\n provide an areaType of either station, section, or area", call.=FALSE)
    if (length(areaType) > 1)   stop("in plot_availability() :\n  can only provide one areaType at a time of either station, section, or area", call.=FALSE)
    if (!areaType %in% c("station", "section", "area")) stop("in plot_availability() :\n provide an areaType of either station, section, or area", call.=FALSE)
    if (length(areaType) > 1)   stop("in plot_availability() :\n can only give one areaType at a time", call.=FALSE)

    getUnique <- function(df = NULL, field = NULL){
        these <- sort(unique(df[,field]))
        return(these)
    }
    #following takes ~10 s, message so know it hasn't crashed
    message("Indexing all available azmpdata...")
    # allAreas <- area_indexer(doMonths=T, doParameters = T)

    if (fuzzyParameters){
        allP <- getUnique(allAreas,"parameter")
        parameters <- allP[grep(paste(parameters, collapse = '|'), allP)]
    }

    FailName <- FALSE
    FailParam <- FALSE

    if (areaType == "station") {
        fieldKp <- "station"
        remainingData <- allAreas[!is.na(allAreas$station),]
        availAreas <- getUnique(remainingData,"station")
        availParams <- getUnique(remainingData,"parameter")
        if (is.null(areaName)| !any(areaName %in% remainingData$station)) FailName <- TRUE
        if (!FailName) {
            remainingData <- remainingData[remainingData$station %in% areaName,]
            availAreas <- getUnique(remainingData,"station")
            availParams <- getUnique(remainingData,"parameter")
        }
        if (is.null(parameters)| !any(parameters %in% remainingData$parameter)) FailParam <- TRUE
        if (!FailParam){
            remainingData <- remainingData[remainingData$parameter %in% parameters,]
            availAreas <- getUnique(remainingData,"station")
            availParams<- getUnique(remainingData,"parameter")
        }
    }
    if (areaType == "section") {
        fieldKp <- "section"
        remainingData <- allAreas[!is.na(allAreas$section),]
        availAreas <- getUnique(remainingData,"section")
        availParams <- getUnique(remainingData,"parameter")
        if (is.null(areaName)| !any(areaName %in% remainingData$section)) FailName <- TRUE
        if (!FailName) {
            remainingData <- remainingData[remainingData$section %in% areaName,]
            availAreas <- getUnique(remainingData,"section")
            availParams <- getUnique(remainingData,"parameter")
        }
        if (is.null(parameters)| !any(parameters %in% remainingData$parameter)) FailParam <- TRUE
        if (!FailParam){
            remainingData <- remainingData[remainingData$parameter %in% parameters,]
            availAreas <- getUnique(remainingData,"station")
            availParams<- getUnique(remainingData,"parameter")
        }
    }
    if (areaType == "area") {
        fieldKp <- "area"
        remainingData <- allAreas[!is.na(allAreas$area)&is.na(allAreas$station)&is.na(allAreas$section),]
        availAreas <- getUnique(remainingData,"area")
        availParams <- getUnique(remainingData,"parameter")
        if (is.null(areaName)| !any(areaName %in% remainingData$area)) FailName <- TRUE
        if (!FailName) {
            remainingData <- remainingData[remainingData$area %in% areaName,]
            availAreas <- getUnique(remainingData,"area")
            availParams <- getUnique(remainingData,"parameter")
        }
        if (is.null(parameters)| !any(parameters %in% remainingData$parameter)) FailParam <- TRUE
        if (!FailParam){
            remainingData <- remainingData[remainingData$parameter %in% parameters,]
            availAreas <- getUnique(remainingData,"station")
            availParams<- getUnique(remainingData,"parameter")
        }
    }
    if (length(parameters)>0){
        paramList = paste0("for your selected parameters (i.e. ",paste(parameters, collapse=", "),") ")
    }else{
        paramList = ""
    }

    if (length(areaName)>0){
        areaList = paste0(" (specifically, ",paste(areaName, collapse=", "),") ")
    }else{
        areaList = ""
    }

    if (FailName & FailParam) {
        message("For ", areaType,"s, valid places ",paramList,"include:")
        message(paste(availAreas, collapse=", "))
        message("\nFor ", areaType,"s",areaList,", valid parameters include:")
        message(paste(availParams, collapse=", "))
        stop("Error: Bad areaName AND bad parameter")
    }else if (FailName){
        message("For ", areaType,"s, valid places ",paramList,"include:")
        message(paste(availAreas, collapse=", "))
        stop("Error: Bad areaName")
    }else if (FailParam){
        message("For ", areaType,"s",areaList,", valid parameters include:")
        message(paste(availParams, collapse=", "))
        stop("Error: Bad parameter")
    }
    #given the filtering above, the condition below should never happen
    if (nrow(remainingData)<1)stop("No records match your specifications")

    remainingData <- remainingData[,c("year",fieldKp, "parameter", "month","cnt","datafile")]
    remainingDataAgg <- aggregate(
        x = list(cnt = remainingData$cnt),
        by = list(year = remainingData$year ,
                  xx = remainingData[,fieldKp],
                  parameter = remainingData$parameter,
                  month = remainingData$month
        ),
        sum
    )
    for (p in 1:length(availParams)){
        thisParamDataAgg <- remainingDataAgg[remainingDataAgg$parameter == availParams[p],]
        freqTable <- stats::reshape(thisParamDataAgg, idvar=c('year','xx','parameter'), timevar='month',direction='wide')
        if(nrow(freqTable)<2){
            message(paste0("Insufficient data to generate a plot of ",availParams[p], " at ",areaName))
            print(freqTable)
            next
        }
        attr(freqTable, "reshapeWide") <- NULL
        freqTable <- freqTable[with(freqTable, order(year)), ]
        freqTable$xx <- freqTable$parameter <- NULL
        colnames(freqTable) <- sub("cnt\\.", "", colnames(freqTable))
        freqTable[is.na(freqTable)] <- 0
        rownames(freqTable)<- freqTable[,1]
        freqTable$year <- NULL
        freqTable <- as.table(as.matrix(freqTable))
        names(dimnames(freqTable)[1])<- "year"
        names(dimnames(freqTable)[2])<- "month"
        # the below line fixes the problem of expected increasing values with imagep
        cm <- oce::colormap(zlim=c(0, max(freqTable)))
        x <- as.numeric(rownames(freqTable)) # year
        y <- as.numeric(colnames(freqTable)) # month
        oce::imagep(x = x, y = y, z = freqTable,
                    colormap = cm,
                    drawPalette = TRUE)
        graphics::box()
        graphics::abline(h = y + 0.5)
        graphics::abline(v = x + 0.5)
        graphics::mtext(side = 1, text = 'Year', line = 2, cex = 4/5)
        graphics::mtext(side = 2, text = 'Month', line = 2, cex = 4/5)
        graphics::mtext(side=3, text= paste("Frequency table for ", availParams[p], " at ",areaName), cex=4/5)
        message(paste0("Plot generated for ",availParams[p], " at ",areaName))
    }

}
