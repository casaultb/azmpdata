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
#' plot_availability(areaType="section", areaName="p5", parameter="nitrate")
#' }
#' @author  Jaimie Harbin \email{jaimie.harbin@@dfo-mpo.gc.ca}
#' @export

plot_availability <- function(areaType=NULL,
                              areaName=NULL,
                              parameters=NULL,
                              fuzzyParameters = TRUE
)
{
    k <- area_indexer(areaTypes=areaType, areanames = areaName, doMonths=T, parameters=parameters,
                      doParameters=T, fuzzyParameters = fuzzyParameters)

    params <- sort(unique(k$parameter))
    if (length(params)>3) params = "multiple parameters"
    areas <- unique(k[!is.na(k$area), "area"])
    sections <- unique(k[!is.na(k$section), "section"])
    stations <- unique(k[!is.na(k$station), "station"])
    if(is.null(areaType)){
        allAreas <- c(areas, sections, stations)
        areaDesc <- ""
    }else if(areaType == "section"){
        allAreas <- c(sections)
        areaDesc <- "section(s):"
    }else if(areaType == "station"){
        allAreas <- c(stations)
        areaDesc <- "station(s):"
    }else if(areaType == "area"){
        allAreas <- c(areas)
        areaDesc <- "area(s):"
    }

    if (length(allAreas)<=3){
        areaDesc <- paste(areaDesc,paste0(allAreas, collapse = ", "))
    }else if (length(allAreas)>3 & length(areas)<1 & length(stations)<1) {
        areaDesc <- "multiple sections"
    }else if (length(allAreas)>3 & length(areas)<1 & length(sections)<1) {
        areaDesc <- "multiple stations"
    }else if (length(allAreas)>3 & length(stations)<1 & length(sections)<1 ){
        areaDesc <- "multiple areas"
    }else if (length(allAreas)>3 & length(areas)<1) {
        areaDesc <- "multiple stations and sections"
    }else if (length(allAreas)>3 & length(stations)<1) {
        areaDesc <- "multiple areas and sections"
    }else if (length(allAreas)>3 & length(sections)<1) {
        areaDesc <- "multiple areas and stations"
    }else if (length(allAreas)>3){
        areaDesc <- "multiple places"
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
    graphics::mtext(side=3, text= paste("Frequency table for ", paste0(params, collapse = ","), " at ",areaDesc), cex=4/5)
    return(freqTable)
    }
