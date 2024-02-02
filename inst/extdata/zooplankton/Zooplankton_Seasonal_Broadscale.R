## code to prepare `Zooplankton_Seasonal_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Ecosystem_Surveys_MAR/Means&Anomalies_Seasonal.RData")
load(con)
close(con)

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus",
                "dw2_S" = "zooplankton_meso_dry_weight")

# print order
region_order <- c("5Ze" = 1,
                  "4V" = 2,
                  "4W" = 3,
                  "4X" = 4)

# reformat data
Zooplankton_Seasonal_Broadscale <- df_means %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_region = unname(region_order[region])) %>%
  dplyr::filter((region=="5Ze" & season=="Winter") | (region %in% c("4V", "4W", "4X") & season=="Summer")) %>%
  dplyr::arrange(order_region, year) %>%
  dplyr::select(region, year, season, unname(target_var)) %>%
  dplyr::rename(area = region)

# save data to csv
readr::write_csv(Zooplankton_Seasonal_Broadscale, "inst/extdata/csv/Zooplankton_Seasonal_Broadscale.csv")

# save data to rda
usethis::use_data(Zooplankton_Seasonal_Broadscale, overwrite = TRUE)
