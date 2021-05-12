## code to prepare `Phytoplankton_Annual_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Microplankton.RData")
load(con)

# clean up
rm(list=setdiff(ls(), "df_log_abundance_means_annual_glm_l"))

# target variables to include
target_var <- c("Diatoms" = "diatoms_log10",
                "Dinoflagellates" = "dinoflagellates_log10",
                "Flagellates" = "flagellates_log10",
                "Ciliates" = "ciliates_log10")

# print order
print_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Phytoplankton_Annual_Stations <- df_log_abundance_means_annual_glm_l %>%
  dplyr::mutate(station = ifelse(station=="HL_02", "HL2",
                                    ifelse(station=="P_05", "P5", NA))) %>%
  dplyr::mutate(order = unname(print_order[station])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::filter(!is.na(station)) %>%
  dplyr::arrange(order, year) %>%
  dplyr::select(station, year, unname(target_var))

# save data to csv
readr::write_csv(Phytoplankton_Annual_Stations, "inst/extdata/csv/Phytoplankton_Annual_Stations.csv")

# save data to rda
usethis::use_data(Phytoplankton_Annual_Stations, overwrite = TRUE)
