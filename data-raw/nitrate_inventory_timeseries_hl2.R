## code to prepare `nitrate_inventory_timeseries_hl2` dataset

library(readr)
library(usethis)

# read csv data
nitrate_inventory_timeseries_hl2 <- readr::read_csv("data-raw/nitrate_inventory_timeseries_hl2.csv")

usethis::use_data(nitrate_inventory_timeseries_hl2, overwrite = TRUE)
