## code to prepare `Zooplankton_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_abundance_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_HL2_Abundance.RData", envir=HL2_abundance_env)
HL2_biomass_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_HL2_Biomass.RData", envir=HL2_biomass_env)
# P5
P5_abundance_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_P5_Abundance.RData", envir=P5_abundance_env)
P5_biomass_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_P5_Biomass.RData", envir=P5_biomass_env)

# assemble data
Zooplankton_Occupations_Stations <- dplyr::bind_rows(HL2_abundance_env$df_abundance_grouped_l %>%
                                                       dplyr::mutate(., station="HL2"),
                                                     HL2_biomass_env$df_biomass_grouped_l %>%
                                                       dplyr::mutate(., station="HL2"),
                                                     P5_abundance_env$df_abundance_grouped_l %>%
                                                       dplyr::mutate(., station="P5"),
                                                     P5_biomass_env$df_biomass_grouped_l %>%
                                                       dplyr::mutate(., station="P5"))
# clean up
rm(list=c("HL2_abundance_env", "HL2_biomass_env", "P5_abundance_env", "P5_biomass_env"))

# target variables to include
target_var <- c("Acartia" = "Acartia",
                "Calanus finmarchicus" = "Calanus_finmarchicus",
                "Calanus glacialis" = "Calanus_glacialis",
                "Calanus hyperboreus" = "Calanus_hyperboreus",
                "Centropages" = "Centropages",
                "Centropages typicus" = "Centropages_typicus",
                "Eurytemora" = "Eurytemora",
                "Metridia" = "Metridia",
                "Metridia longa" = "Metridia_longa",
                "Metridia lucens" = "Metridia_lucens",
                "Microcalanus" = "Microcalanus",
                "Oithona" = "Oithona",
                "Oithona atlantica" = "Oithona_atlantica",
                "Oithona similis" = "Oithona_similis",
                "Paracalanus" = "Paracalanus",
                "Pseudocalanus" ="Pseudocalanus" ,
                "Temora longicornis" = "Temora_longicornis",
                "Other copepods HL2" = "other_copepods",
                "Other copepods P5" = "other_copepods",
                "Copepods" = "copepods",
                "Non-copepods" = "non_copepods",
                "Arctic Calanus" = "Arctic_Calanus_species",
                "Warm Offshore" = "warm_offshore_copepods",
                "Warm Shelf" = "warm_shelf_copepods",
                "dw2_S" = "mesozooplankton_dry_biomass",
                "dw2_L" = "macrozooplankton_dry_biomass",
                "dw2_T" = "zooplankton_dry_biomass",
                "ww2_S" = "mesozooplankton_wet_biomass",
                "ww2_L" = "macrozooplankton_wet_biomass",
                "ww2_T" = "zooplankton_wet_biomass")

# include those ??
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
# "Other NonCopepods"
# "Polychaeta total"
# "Cladocera & Bivalvia"
# "Cnidaria & Appendicularia"
# "Euphausiidae & Decapoda"
# "Polychaeta & Chaetognatha"
# "Other zooplankton"
# "Total copepods"
# "Total zooplankton"

# print order
print_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Zooplankton_Occupations_Stations <- Zooplankton_Occupations_Stations %>%
  dplyr::mutate(., order = unname(print_order[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year, month, day) %>%
  dplyr::select(., station, latitude, longitude, year, month, day, sample_id,
                unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Occupations_Stations, "inst/extdata/Zooplankton_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Stations, overwrite = TRUE)
