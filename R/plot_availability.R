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
    for (p in seq_along(parameters)) {
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
