## code to prepare `Zooplankton_Occupations_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Ecosystem_Surveys_MAR/RingNet_Data_Grouped.RData")
load(con)
close(con)

# assemble data
Zooplankton_Occupations_Broadscale <- dplyr::bind_rows(df_abundance_grouped_l,
                                                       df_biomass_grouped_l)

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "dw2_S" = "zooplankton_meso_dry_weight")

# print order
region_order <- c("5Ze" = 1,
                  "4V" = 2,
                  "4W" = 3,
                  "4X" = 4)
# season
season_order <- c("Winter" = 1,
                  "Summer" = 2)

# reformat data
Zooplankton_Occupations_Broadscale <- Zooplankton_Occupations_Broadscale %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata, by="custom_sample_id") %>%
  dplyr::filter((region=="5Ze" & season=="Winter") | (region %in% c("4V", "4W", "4X") & season=="Summer")) %>%
  dplyr::mutate(order_region = unname(region_order[region])) %>%
  dplyr::mutate(order_season = unname(season_order[season])) %>%
  dplyr::arrange(order_region, order_season, date) %>%
  dplyr::select(region, latitude, longitude, date, season, unname(target_var)) %>%
  dplyr::rename(area = region)

# # save data to csv
readr::write_csv(Zooplankton_Occupations_Broadscale, "inst/extdata/csv/Zooplankton_Occupations_Broadscale.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Broadscale, overwrite = TRUE)
