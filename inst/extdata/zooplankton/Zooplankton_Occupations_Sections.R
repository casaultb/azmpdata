## code to prepare `Zooplankton_Occupations_Sections` dataset

library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/RingNet_Data_Grouped.RData")
load(con)
close(con)

# assemble data
Zooplankton_Occupations_Sections <- dplyr::bind_rows(df_abundance_grouped_l,
                                                     df_biomass_grouped_l)

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "Pseudocalanus" = "Pseudocalanus_abundance",
                "Copepods" = "copepods",
                "Non-copepods" = "non_copepods",
                "Arctic Calanus" = "Arctic_Calanus_species",
                "Warm Offshore" = "warm_offshore_copepods",
                "Warm Shelf" = "warm_shelf_copepods",
                "dw2_S" = "zooplankton_meso_dry_weight")

# include those ??
# "Amphipoda total"
# "Bivalvia total"
# "Bryozoa total"
# "Chaetognatha total"
# "Cirripedia total"
# "Cladocera total"
# "Cnidaria total"
# "Echinodermata total"
# "Euphausiacea total"
# "Gastropoda total"
# "Larvacea total"
# "Ostracoda total"
# "Polychaeta total"
# "Other NonCopepods"

# print order
# section
section_order <- c("CSL" = 1,
                   "LL" = 2,
                   "HL" = 3,
                   "BBL" = 4)
# section
station_order <- c("CSL1" = 1, "CSL2" = 2, "CSL3" = 3, "CSL4" = 4, "CSL5" = 5, "CSL6" = 6,
                   "LL1" = 1, "LL2" = 2, "LL3" = 3, "LL4" = 4, "LL5" = 5, "LL6" = 6, "LL7" = 7, "LL8" = 8, "LL9" = 9,
                   "HL1" = 1, "HL2" = 2, "HL3" = 3, "HL4" = 4, "HL5" = 5, "HL6" = 6, "HL7" = 7,
                   "BBL1" = 1, "BBL2" = 2, "BBL3" = 3, "BBL4" = 4, "BBL5" = 5, "BBL6" = 6, "BBL7" = 7)
# season
season_order <- c("Spring" = 1,
                  "Fall" = 2)

# reformat data
Zooplankton_Occupations_Sections <- Zooplankton_Occupations_Sections %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata %>%
                     mutate(year=lubridate::year(date)),
                   by="custom_sample_id") %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::mutate(order_season = unname(season_order[season])) %>%
  dplyr::arrange(order_section, year, order_season, order_station) %>%
  dplyr::select(section, station, latitude, longitude, date, season, unname(target_var))

# # save data to csv
readr::write_csv(Zooplankton_Occupations_Sections, "inst/extdata/csv/Zooplankton_Occupations_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Sections, overwrite = TRUE)
