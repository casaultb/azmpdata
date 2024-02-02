## code to prepare `Zooplankton_Annual_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/Means&Anomalies_Annual.RData")
load(con)
close(con)

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                 "Pseudocalanus" = "Pseudocalanus_log10",
                 "Copepods" = "copepods_log10",
                 "Non-copepods" = "non_copepods_log10",
                 "Arctic Calanus" = "Arctic_Calanus_species_log10",
                 "Warm Offshore" = "warm_offshore_copepods_log10",
                 "Warm Shelf" = "warm_shelf_copepods_log10",
                "dw2_S" = "zooplankton_meso_dry_weight")

# print order
section_order <- c("CSL" = 1,
                   "LL" = 2,
                   "HL" = 3,
                   "BBL" = 4)

# reformat data
Zooplankton_Annual_Sections <- df_means %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::arrange(order_section, year) %>%
  dplyr::select(section, year, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Annual_Sections, "inst/extdata/csv/Zooplankton_Annual_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Annual_Sections, overwrite = TRUE)
