## code to prepare `chlorophyll_inventory_annual_means_hl2` dataset

library(readr)
library(usethis)

# read csv data
chlorophyll_inventory_annual_means_hl2 <- readr::read_csv("inst/extdata/chlorophyll_inventory_annual_means_hl2.csv")

usethis::use_data(chlorophyll_inventory_annual_means_hl2, overwrite = TRUE)
