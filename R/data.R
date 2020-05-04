
#' Timeseries of chlorophyll inventory at Halifax-2 station.
#'
#' The chlorophyll inventory consists in the integrated chlorophyll concentration
#'  as obtained using trapezoidal integration over the 0-100m layer for individual
#'  profiles.
#'
#' @format A data frame with four variables: \code{year}, \code{month},
#'   \code{day}, and \code{chl_0_100}. The chlorophyll inventory has
#'    units of mg chl/m2.
"chlorophyll_inventory_timeseries_hl2"

#' Annual means of chlorophyll inventory at Halifax-2 station.
#'
#' The chlorophyll inventory consists in the integrated chlorophyll concentration
#'  as obtained using trapezoidal integration over the 0-100m layer for individual
#'  profiles. The annual means are obtained by fitting a linear model of the form
#'  \code{density ~ year + month} where density is \code{chlorophyll_0_100}, and
#'  \code{year} and \code{month} are factors.
#'
#' @format A data frame with two variables: \code{year}, and \code{chl_0_100}.
#' The chlorophyll inventory has units of mg chl/m2.
"chlorophyll_inventory_annual_means_hl2"

#' Timeseries of nitrate inventory at Halifax-2 station.
#'
#' The nitrate inventory consists in the integrated nitrate concentration
#'  as obtained using trapezoidal integration over the 0-50m layer (or 50-150m)
#'   for individual profiles.
#'
#' @format A data frame with five variables: \code{year}, \code{month},
#'   \code{day}, \code{no3_0_50}, and \code{no3_50_150}. The nitrate
#'   inventory has units of mmol N/m2.
"nitrate_inventory_timeseries_hl2"
