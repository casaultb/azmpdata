## code to prepare `nitrate_inventory_timeseries_hl2` dataset

library(readr)
library(usethis)

# read csv data
nitrate_inventory_timeseries_hl2 <- readr::read_csv("inst/extdata/nitrate_inventory_timeseries_hl2.csv")

names(nitrate_inventory_timeseries_hl2) <- c('year', 'month', 'day', 'integrated_nitrate_0_50', 'integrated_nitrate_50_150')

nitrate_inventory_timeseries_hl2$station_name <-  rep('HL2', length(nitrate_inventory_timeseries_hl2[[1]]))

save(nitrate_inventory_timeseries_hl2, file = 'data-raw/nitrate_inventory_timeseries_hl2.rda')

# usethis::use_data(nitrate_inventory_timeseries_hl2, overwrite = TRUE)
