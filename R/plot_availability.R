#' @title plot_availability
#' @description This generates a score card of samples per month based on areaType, areaName, and parameter.
#' @param areaType default is \code{NULL}. Indicates which type of area is of interest. The options are section, station, or area.
#' @param areaName default is \code{NULL}. Indicates which area is of interest. The options are dependant on the areaType, however, a error message will let the user know which options are available.
#' @param parameters default is \code{NULL}. Indicates which parameter is of interest. This is dependant on areaType and areaName, however, an error message will let the user know which options are available.
#' @examples \dontrun{
#' plot_availability(areaType="section", areaName="p5", parameter="nitrate")
#' }
#' @author Jaimie Harbin \email{jaimie.harbin@@dfo-mpo.gc.ca}
#' @export

plot_availability <- function(areaType=NULL,
                              areaName=NULL,
                              parameters=NULL
)
{
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

    unique <- area_indexer(areaTypes=areaType)
    if (areaType == "station") {
        s <- unique(unique$station)
    }
    if (areaType == "section") {
        s <- unique(unique$section)
    }

    if (areaType == "area") {
        s <- "Gulf of St. Lawrence"
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
        stop("in plot_availability() :\n provide areaName of ", s, call.=FALSE)
        }
    }

    if (length(areaName) > 1) {
        stop("in plot_availability() :\n  can only provide one areaName at a time", call.=FALSE)
    }

     if (!areaName %in% s) {
        stop("in plot_availability() :\n", areaName, " is not an areaName within areaType = ", areaType, " try the following ", paste(s, collapse=" "), call.=FALSE)
    }



        # The following is for error messages
        uniquep <- area_indexer(areaTypes=areaType, areanames=areaName, doParameters=T)
        param <- unique(uniquep$parameter)
        if (is.null(parameters)) {
            stop("in plot_availability() :\n when areaname is equal to ", areaName, " must use the following parameters ", paste(param, collapse=","), call.=FALSE)
        }

        for (p in seq_along(parameters)) {
        if (!parameters[p] %in% param | is.null(parameters)) {
        stop("in plot_availability() : ",parameters[p], " not a parameter in ",areaName, " try one of ", param)
        } else {
        k <- area_indexer(areaTypes=areaType, areanames = areaName, doMonths=T,parameters=parameters[p], doParameters=T)
        dd <- k[which(k$parameter == parameters[p]),]
        df <- data.frame(year=dd[["year"]], month=dd[["month"]])
        freqTable <- with(df, table(year, month))
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
        graphics::mtext(side=3, text= paste("Frequency table for ", parameters[p], " at the ", areaName, " ", areaType), cex=4/5)
    }
        }
}
