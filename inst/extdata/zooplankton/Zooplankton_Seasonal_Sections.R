## code to prepare `Zooplankton_Seasonal_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/Means&Anomalies_Seasonal.RData")
load(con)
close(con)

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "dw2_S" = "zooplankton_meso_dry_weight")

# print order
section_order <- c("CSL" = 1,
                   "LL" = 2,
                   "HL" = 3,
                   "BBL" = 4)

# season
season_order <- c("Spring" = 1,
                  "Fall" = 2)

# reformat data
Zooplankton_Seasonal_Sections <- df_means %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::mutate(order_season = unname(season_order[season])) %>%
  dplyr::arrange(order_section, order_season, year) %>%
  dplyr::select(section, year, season, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Seasonal_Sections, "inst/extdata/csv/Zooplankton_Seasonal_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Seasonal_Sections, overwrite = TRUE)
