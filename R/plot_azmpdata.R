#' Plot azmpdata dataset variable
#'
#' Plot a variable from a given dataset.
#'
#' @param dataset string (lowercase only)
#' @param variable string (lowercase only)
#'
#'
#' @importFrom stringr str_detect
#' @import dplyr
#' @return NULL
#' @export
#'
#'
#'
plot_azmpdata <- function(dataset, variable) {

  # declare empty list
  # ls_data <- list()

  # metadata
  # ls_data$dataset <- dataset
  # ls_data$variable <- variable
  # switch(variable,
  #        chl_0_100 = {ls_data$units <- "mg chl/m2"},
  #        no3_0_50 = {ls_data$units <- "mmol N/m2"},
  #        no3_50_150 = {ls_data$units <- "mmol N/m2"})
  # create function that gives units for any variable?

  # data resolution
  # TODO add more data resolutions?
  data_res <- ifelse(stringr::str_detect(dataset, "Occupations"), "timeseries",
                     ifelse(stringr::str_detect(dataset, "Annual"), "annual_means", NULL))


  if(data_res == 'annual_means'){
    p <- plot_annual_means(df_data = get(dataset), variable = variable)
  }

  if(data_res == 'timeseries'){
    p <- plot_timeseries()
  }

  if(is.null(data_res)){
    stop('Incompatible data resolution, could not find appropriate plotting function')
  }

  # plot data
  # switch(data_res,
  #        timeseries = {ls_data$data <- get(dataset) %>%
  #          dplyr::rename(value=variable) %>%
  #          dplyr::select(year, month, day, value)
  #        p <- plot_timeseries(ls_data)},
  #        annual_means = {ls_data$data <- get(dataset) %>%
  #          dplyr::rename(value=variable) %>%
  #          dplyr::select(year, value)
  #        p <- plot_annual_means(ls_data)})

  # print plot
  return(p)
}
