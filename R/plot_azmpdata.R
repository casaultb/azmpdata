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
#'
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
  data_res <- ifelse(test = stringr::str_detect(dataset, "Occupations"), yes = "timeseries",
                      no = ifelse(test = stringr::str_detect(dataset, "Annual"), yes =  "annual_means", no = NA))


  res <- tryCatch(get(dataset),
           error=function(error_condition) {
             message(paste("Dataset does not exist:", dataset))
             # Choose a return value in case of error
             return(NA)
           })

  if(data_res == 'annual_means'){
    p <- plot_annual_means(df_data = get(dataset), variable = variable)
  }

  if(data_res == 'timeseries'){
    p <- plot_timeseries(df_data = get(dataset), variable = variable)
  }

  if(is.na(data_res)){
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
