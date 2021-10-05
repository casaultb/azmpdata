#' @title Frequency plot of parameter(s) from specified locations
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
#' @export
plot_availability <- function(areaType=NULL,
                              areaName=NULL,
                              parameters=NULL,
                              fuzzyParameters = FALSE
)
{
    # Note: This is for area
    if (!requireNamespace("tidyr", quietly=TRUE))
        stop("must install.packages('tidyr') for plot_availability() to work")

    if (is.null(areaType)) {
        stop("in plot_availability() :\n provide an areaType of either station, section, or area", call.=FALSE)
    }

    if (length(areaType) > 1) {
        stop("in plot_availability() :\n  can only provide one areaType at a time of either station, section, or area", call.=FALSE)
    }

    if (!areaType %in% c("station", "section", "area")) {
        stop("in plot_availability() :\n provide an areaType of either station, section, or area", call.=FALSE)
    }

    if (length(areaType) > 1) {
        stop("in plot_availability() :\n can only give one areaType at a time", call.=FALSE)
    }

    unique <- area_indexer(areaTypes=areaType, doMonths=T)
    if (areaType == "station") {
        s <- unique(unique$station)
    }
    if (areaType == "section") {
        s <- unique(unique$section)
    }

    # Note this is because when you do the following,
    # Gulf of St. Lawrence is the only one that has 'month'
    # k <- area_indexer(areaTypes = "area", doParameters = T)
    # unique(k$area)
    # d <- area_indexer(areaTypes = "area", doParameters = T, doMonths=T)
    # unique(d$area)

    # Note that in RemoteSensing_Weekly_Broadscale information is stored in doy.
    # I changed that to month, and look at the unique(RemoteSensing_Weekly_Broadscale$area)
    # To get the other names.

    if (areaType == "area") {
        s <- c("Gulf of St. Lawrence", "CS_remote_sensing",  "ESS_remote_sensing", "CSS_remote_sensing",
               "WSS_remote_sensing", "GB_remote_sensing",  "LS_remote_sensing")
    }

    if (is.null(areaName)) {
        # The following is for error messages
        if (areaType == "station") {
            stop("in plot_availability() :\n provide areaName of either ", paste(s, collapse=","), call.=FALSE)
        }
        if (areaType == "section") {
            stop("in plot_availability() :\n provide areaName of either ", paste(s, collapse=","), call.=FALSE)
        }

        if (areaType == "area") {
            stop("in plot_availability() :\n provide areaName of ", paste(s, collapse=", "), call.=FALSE)
        }
    }

    if (length(areaName) > 1) {
        stop("in plot_availability() :\n  can only provide one areaName at a time", call.=FALSE)
    }

    if (!areaName %in% s) {
        stop("in plot_availability() :\n", areaName, " is not an areaName within areaType = ", areaType, " try the following ", paste(s, collapse=", "), call.=FALSE)
    }


    # The following is for error messages
    uniquep <- area_indexer(areaTypes=areaType, areanames=areaName, doParameters=T, doMonths=T)
    param <- unique(uniquep$parameter)
    if (areaType == "area" && areaName %in% c("CS_remote_sensing", "ESS_remote_sensing", "CSS_remote_sensing",
                                              "WSS_remote_sensing", "GB_remote_sensing", "LS_remote_sensing")) {
        param <- "surface_chlorophyll"
    }

    if (is.null(parameters)) {
        stop("in plot_availability() :\n when areaName is equal to ", areaName, " must use the following parameters ", paste(param, collapse=","), call.=FALSE)
    }


    for (p in seq_along(parameters)) {
        if (!parameters[p] %in% param | is.null(parameters))
            stop("in plot_availability() : ",parameters[p], " not a parameter in ",areaName, " try one of ", paste(param, collapse=" "))
        k <- area_indexer(areaTypes=areaType, areanames = areaName, doMonths=T, parameters=parameters[p],
                          doParameters=T, fuzzyParameters = fuzzyParameters)
        params <- sort(unique(k$parameter))

        if (length(params) != 1 && areaType != "area") {
            for (P in params) {
                # Note that I had to make fuzzyParameters FALSE here
                k <- area_indexer(areaTypes=areaType, areanames = areaName, doMonths=T, parameters=P,
                                  doParameters=T, fuzzyParameters = F)
                #freqTable <- with(k, table(year, month))
                #cm <- oce::colormap(zlim=c(0, max(freqTable)))

                if(areaType=="station") fieldKp <- "station"
                if(areaType=="section") fieldKp <- "section"
                if(areaType=="area") fieldKp <- "area"
                k <- k[,c("year",fieldKp, "parameter", "month","cnt","datafile")] # this changes "area", for example, to station
                #message("the length of year is ", length(k$year), " and the lenght of station is ", length(k$station))
                # The following is splitting data into subsets
                k1 <- aggregate(
                    x = list(cnt = k$cnt),
                    by = list(year = k$year ,
                              xx = k[,fieldKp],
                              parameter = k$parameter,
                              month = k$month
                    ),
                    sum
                )
                freqTable <- reshape(k1, idvar=c('year','xx','parameter'), timevar='month',direction='wide')
                attr(freqTable, "reshapeWide") <- NULL

                freqTable = freqTable[with(freqTable, order(year)), ]
                freqTable$xx <- freqTable$parameter <- NULL
                colnames(freqTable) <- sub("cnt\\.", "", colnames(freqTable))
                freqTable[is.na(freqTable)] <- 0
                rownames(freqTable)<- freqTable[,1]
                freqTable$year <- NULL

                freqTable <- as.table(as.matrix(freqTable))
                names(dimnames(freqTable)[1])<- "year"
                names(dimnames(freqTable)[2])<- "month"
                cm <- oce::colormap(z = freqTable)
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
                graphics::mtext(side=3, text= paste("Frequency table for ", paste0(P, collapse = ","), " at ",areaName), cex=4/5)
            }
        } else if (areaType == "area" && areaName %in%  c("CS_remote_sensing",  "ESS_remote_sensing", "CSS_remote_sensing",
                                                          "WSS_remote_sensing", "GB_remote_sensing",  "LS_remote_sensing")) {
            vec <- rep("NA", length(RemoteSensing_Weekly_Broadscale$doy))
            RemoteSensing_Weekly_Broadscale$month <- vec
            RemoteSensing_Weekly_Broadscale$month <- as.Date(RemoteSensing_Weekly_Broadscale$doy, origin = paste0(RemoteSensing_Weekly_Broadscale$year,"-01-01"))
            d <- RemoteSensing_Weekly_Broadscale %>%
                tidyr::separate(month, sep="-", into = c("year", "month", "day"))
            areas <- unique(d$area)

            for (a in areas) {
                k <- d[which(d$area == a),]
            }
            freqTable <- with(k, table(year, month))
            cm <- oce::colormap(z = freqTable)
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
            graphics::mtext(side=3, text= paste("Frequency table for surface_chlorophyll at ", areaName), cex=4/5)
        } else {

            if(areaType=="station") fieldKp <- "station"
            if(areaType=="section") fieldKp <- "section"
            if(areaType=="area") fieldKp <- "area"
            k <- k[,c("year",fieldKp, "parameter", "month","cnt","datafile")]
            k1 <- aggregate(
                x = list(cnt = k$cnt),
                by = list(year = k$year ,
                          xx = k[,fieldKp],
                          parameter = k$parameter,
                          month = k$month
                ),
                sum
            )
            freqTable <- reshape(k1, idvar=c('year','xx','parameter'), timevar='month',direction='wide')
            attr(freqTable, "reshapeWide") <- NULL

            freqTable = freqTable[with(freqTable, order(year)), ]
            freqTable$xx <- freqTable$parameter <- NULL
            colnames(freqTable) <- sub("cnt\\.", "", colnames(freqTable))
            freqTable[is.na(freqTable)] <- 0
            rownames(freqTable)<- freqTable[,1]
            freqTable$year <- NULL

            freqTable <- as.table(as.matrix(freqTable))
            names(dimnames(freqTable)[1])<- "year"
            names(dimnames(freqTable)[2])<- "month"
            cm <- oce::colormap(z = freqTable)

            # freqTable <- with(k, table(year, month))

            # cm <- oce::colormap(zlim=c(0, max(freqTable)))
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
            graphics::mtext(side=3, text= paste("Frequency table for ", paste0(params, collapse = ","), " at ",areaName), cex=4/5)
        }

    }}
