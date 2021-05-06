## code to prepare `Zooplankton_Occupations_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# abundance data
abundance_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Zoo_Abundance_MAR_AZMP.RData")
load(con, envir=abundance_env)
close(con)
# biomass data
biomass_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Zoo_Biomass_MAR_AZMP.RData")
load(con, envir=biomass_env)
close(con)

# assemble data
Zooplankton_Occupations_Sections <- dplyr::bind_rows(abundance_env$df_abundance_grouped_l,
                                                     biomass_env$df_biomass_grouped_l)

# this is a workaround for handling metadata (e.g. lat, lon) that might be different between
# the abundance dataset and the biomass dataset (but should really be the same)
# assemble metadata
metadata <- dplyr::bind_rows(abundance_env$df_sample_filtered,
                             biomass_env$df_sample_filtered) %>%
  dplyr::select(sample_id, latitude, longitude, station, transect, year, month, day, season) %>%
  dplyr::rename(section = transect) %>%
  dplyr::group_by(sample_id) %>%
  dplyr::slice(1) %>%
  dplyr::ungroup(.)

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "Pseudocalanus" = "Pseudocalanus_abundance",
                "Copepods" = "copepods",
                "Non-copepods" = "non_copepods",
                "Arctic Calanus" = "Arctic_Calanus_species",
                "Warm Offshore" = "warm_offshore_copepods",
                "Warm Shelf" = "warm_shelf_copepods",
                "dw2_S" = "zooplankton_meso_dry_weight",
                "dw2_L" = "zooplankton_macro_dry_weight",
                "dw2_T" = "zooplankton_total_dry_weight",
                "ww2_S" = "zooplankton_meso_wet_weight",
                "ww2_L" = "zooplankton_macro_wet_weight",
                "ww2_T" = "zooplankton_total_wet_weight")

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
print_order_section <- c("CSL" = 1,
                         "LL" = 2,
                         "HL" = 3,
                         "BBL" = 4)
# section
print_order_station <- c("CSL1" = 1, "CSL2" = 2, "CSL3" = 3, "CSL4" = 4, "CSL5" = 5, "CSL6" = 6,
                         "LL1" = 1, "LL2" = 2, "LL3" = 3, "LL4" = 4, "LL5" = 5, "LL6" = 6, "LL7" = 7, "LL8" = 8, "LL9" = 9,
                         "HL1" = 1, "HL2" = 2, "HL3" = 3, "HL4" = 4, "HL5" = 5, "HL6" = 6, "HL7" = 7,
                         "BBL1" = 1, "BBL2" = 2, "BBL3" = 3, "BBL4" = 4, "BBL5" = 5, "BBL6" = 6, "BBL7" = 7)
# season
print_order_season <- c("Spring" = 1,
                        "Fall" = 2)

# reformat data
Zooplankton_Occupations_Sections <- dplyr::left_join(Zooplankton_Occupations_Sections %>%
                                                       dplyr::select(sample_id, variable, value),
                                                     metadata,
                                                     by="sample_id") %>%
  dplyr::mutate(order_section = unname(print_order_section[section])) %>%
  dplyr::mutate(order_station = unname(print_order_station[station])) %>%
  dplyr::mutate(order_season = unname(print_order_season[season])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order_section, year, order_season, order_station) %>%
  dplyr::select(section, station, latitude, longitude, year, month, day, season, sample_id,
                unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Occupations_Sections, "inst/extdata/csv/Zooplankton_Occupations_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Sections, overwrite = TRUE)
