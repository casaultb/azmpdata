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
              if (length(areaType) > 1) {
                       stop("in plot_availability() :\n can only give one areaType at a time", call.=FALSE)
              }

              if (areaType == "station") {

                  k <- area_indexer(datafiles=c("Derived_Monthly_Stations","Derived_Occupations_Sections","Derived_Occupations_Stations", "Discrete_Occupations_Sections","Discrete_Occupations_Stations","Phytoplankton_Occupations_Stations", "Zooplankton_Occupations_Sections","Zooplankton_Occupations_Stations"), areaTypes=c("station"), doMonths=T, doParameters=T) # For stations
                  stations <- unique(k$areaname)
                      if (length(areaName) == 0) {
                       stop("in plot_availability() :\n must give an areaName argument of either ", paste(stations, collapse=" "), " when 'areaType' == 'station'", call.=FALSE)
                      } else if (length(areaName) > 1) {
                       stop("in plot_availability() :\n can only provide one station at a time. This may change in the future", call.=FALSE)
                      } else if (areaName %in% stations) {
                      d <- k[which(k$areaname == areaName),]
                      dd <- d[which(d$parameter == parameters),]
                      p <- unique(d[which(d$areaname == areaName),]$parameter)
                      if (length(parameters) == 0) {
                       stop("in plot_availability() :\n must give a parameters argument of either ", paste(p, collapse=" "), " for station ", areaName, call.=FALSE)
                      } else if (parameters %in% p) {
                        df <- data.frame(year = dd[['year']], month = dd[['month']])
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
                          graphics::mtext(side=3, text= paste("Frequency table for ", parameters, " at the ", areaName, " station"), cex=4/5)
                      } else {
                       stop("in plot_availability() :\n when areaName = ", areaName, " the parameters must be equal to", paste(p, collapse=" "), call.=FALSE)
                      }

                  } else {
                       stop("in plot_availability() :\n  areaName must be ", paste(stations, collapse=" "), " when 'areaType' == 'station'", call.=FALSE)
                  }

              } else if (areaType == "section") {
                  # FIXME (MM): There is an NA section
                   k <- area_indexer(datafiles=c("Derived_Monthly_Stations","Derived_Occupations_Sections","Derived_Occupations_Stations", "Discrete_Occupations_Sections","Discrete_Occupations_Stations","Phytoplankton_Occupations_Stations", "Zooplankton_Occupations_Sections","Zooplankton_Occupations_Stations"), areaTypes=c("section"), doMonths=T, doParameters=T) # For sections
                  sections <- unique(k$areaname)
                      if (length(areaName) == 0) {
                       stop("in plot_availability() :\n must give an areaName argument of either ", paste(sections, collapse=" "), " when 'areaType' == 'section'", call.=FALSE)
                      } else if (length(areaName) > 1) {
                       stop("in plot_availability() :\n can only provide one section at a time. This may change in the future", call.=FALSE)
                      } else if (areaName %in% sections) {
                      d <- k[which(k$areaname == areaName),]
                      p <- unique(d[which(d$areaname == areaName),]$parameter)
                      if (length(parameters) == 0) {
                       stop("in plot_availability() :\n must give a parameters argument of either ", paste(p, collapse=" "), " for section ", areaName, call.=FALSE)
                      } else if (parameters %in% p) {
                          df <- data.frame(year = d[['year']], month = d[['month']])
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
                          graphics::mtext(side=3, text= paste("Frequency table for ", parameters, " at the ", areaName, " section")
               , cex=4/5)


                      } else {
                       stop("in plot_availability() :\n when areaName = ", areaName, " the parameters must be equal to", paste(p, collapse=" "), call.=FALSE)
                      }

                  } else {
                       stop("in plot_availability() :\n  areaName must be ", paste(sections, collapse=" "), " when 'areaType' == 'section'", call.=FALSE)
                  }
              }
              else if (areaType == "area") {
                   #Note: NAFO (gen) ,NAFO (det), and SS Box, SS Grid, SS Areas, General Areas, or RemoteSensing does not work because there are no months associated with dataframes.
                  # Test case:
                  #kk <- area_indexer(areaTypes=c("area"), doMonths=T, doParameters=T) # For areas
                  #k <- kk[which(kk$areaname %in% c("scotian_shelf_box")),]
                  #unique(k$dataframe)
                  #names(Derived_Annual_Broadscale)

                  # FIXME: This is kind of working, but I want the colorbar better
                  kk <- area_indexer(areaTypes=c("area"), doMonths=T, doParameters=T) # For areas
                  k <- kk[which(kk$areaname %in% c("Gulf of St. Lawrence")),]
                  areas <- unique(k$areaname)
                      if (length(areaName) == 0) {
                       stop("in plot_availability() :\n must give an areaName argument of either ", paste(areas, collapse=" "), " when 'areaType' == 'area'", call.=FALSE)
                      } else if (length(areaName) > 1) {
                       stop("in plot_availability() :\n can only provide one area at a time. This may change in the future", call.=FALSE)
                      } else if (areaName %in% areas) {
                      d <- k[which(k$areaname == areaName),]
                      p <- unique(d[which(d$areaname == areaName),]$parameter)
                      if (length(parameters) == 0) {
                       stop("in plot_availability() :\n must give a parameters argument of either ", paste(p, collapse=" "), " for area ", areaName, call.=FALSE)
                      } else if (parameters %in% p) {
                          df <- data.frame(year = d[['year']], month = d[['month']])
                          freqTable <- with(df, table(year, month))

                          cm <- oce::colormap(z = freqTable, breaks=c(11,12,13), col=c("darkgreen","purple"))
                          x <- as.numeric(rownames(freqTable)) # year
                          y <- as.numeric(colnames(freqTable)) # month
                          oce::imagep(x = x, y = y, z = freqTable,
                                 colormap = cm,
                                 drawPalette=T)
                          graphics::box()
                          graphics::abline(h = y + 0.5)
                          graphics::abline(v = x + 0.5)
                          graphics::mtext(side = 1, text = 'Year', line = 2, cex = 4/5)
                          graphics::mtext(side = 2, text = 'Month', line = 2, cex = 4/5)
                          graphics::mtext(side=3, text= paste("Frequency table for ", parameters, " at the ", areaName, " area")
               , cex=4/5)


                      } else {
                       stop("in plot_availability() :\n when areaName = ", areaName, " the parameters must be equal to", paste(p, collapse=" "), call.=FALSE)
                      }

                  } else {
                       stop("in plot_availability() :\n  areaName must be ", paste(areas, collapse=" "), " when 'areaType' == 'area'", call.=FALSE)
                  }





















              } else {
                  stop("The areaType must be station, section, or area")

              }

          }


