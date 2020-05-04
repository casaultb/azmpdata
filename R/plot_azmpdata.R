#' Plot azmpdata dataset variable
#'
#' Plot a variable from a given dataset.
#'
#' @param dataset string (lowercase only)
#' @param variable string (lowercase only)
#'
#' @return NULL
#' @export
#'
#' @examples
#' plot_azmpdata("chlorophyll_inventory_annual_means_hl2", "chl_0_100")
plot_azmpdata <- function(dataset, variable) {

  # declare empty list
  ls_data <- list()

  # metadata
  ls_data$dataset <- dataset
  ls_data$variable <- variable
  switch(variable,
         chl_0_100 = {ls_data$units <- "mg chl/m2"},
         no3_0_50 = {ls_data$units <- "mmol N/m2"},
         no3_50_150 = {ls_data$units <- "mmol N/m2"})

  # data resolution
  data_res <- ifelse(stringr::str_detect(dataset, "timeseries"), "timeseries",
                     ifelse(stringr::str_detect(dataset, "annual_means"), "annual_means", NULL))

  # plot data
  switch(data_res,
         timeseries = {ls_data$data <- get(dataset) %>%
           dplyr::rename(value=variable) %>%
           dplyr::select(year, month, day, value)
         p <- plot_timeseries(ls_data)},
         annual_means = {ls_data$data <- get(dataset) %>%
           dplyr::rename(value=variable) %>%
           dplyr::select(year, value)
         p <- plot_annual_means(ls_data)})

  # print plot
  print(p)
}
