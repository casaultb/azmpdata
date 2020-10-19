## code to prepare `chlorophyll_inventory_timeseries_hl2` dataset

library(readr)
library(usethis)

# read csv data
chlorophyll_inventory_timeseries_hl2 <- readr::read_csv("inst/extdata/chlorophyll_inventory_timeseries_hl2.csv")

names(chlorophyll_inventory_timeseries_hl2) <- c('year', 'month', 'day', 'integrated_chlorophyll_0_100')

chlorophyll_inventory_timeseries_hl2$station_name <-  rep('HL2', length(chlorophyll_inventory_timeseries_hl2[[1]]))

save(chlorophyll_inventory_timeseries_hl2, file = 'data-raw/chlorophyll_inventory_timeseries_hl2.rda')

# usethis::use_data(chlorophyll_inventory_timeseries_hl2, overwrite = TRUE)
