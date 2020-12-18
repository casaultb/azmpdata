## code to prepare `Zooplankton_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
# HL2
# abundance data
HL2_abundance_env <- new.env()
con <- url(unname(db_lookup["PL_HL2_Abundance.RData"]))
load(con, envir=HL2_abundance_env)
close(con)
# biomass data
HL2_biomass_env <- new.env()
con <- url(unname(db_lookup["PL_HL2_Biomass.RData"]))
load(con, envir=HL2_biomass_env)
close(con)
# P5
# abundance data
P5_abundance_env <- new.env()
con <- url(unname(db_lookup["PL_P5_Abundance.RData"]))
load(con, envir=P5_abundance_env)
close(con)
# biomass data
P5_biomass_env <- new.env()
con <- url(unname(db_lookup["PL_P5_Biomass.RData"]))
load(con, envir=P5_biomass_env)
close(con)

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
target_var <- c("Acartia" = "Acartia_abundance",
                "Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "Calanus glacialis" = "Calanus_glacialis_abundance",
                "Calanus hyperboreus" = "Calanus_hyperboreus_abundance",
                "Centropages" = "Centropages_spp_abundance",
                "Centropages typicus" = "Centropages_typicus_abundance",
                "Eurytemora" = "Eurytemora_abundance",
                "Metridia" = "Metridia_spp_abundance",
                "Metridia longa" = "Metridia_longa_abundance",
                "Metridia lucens" = "Metridia_lucens_abundance",
                "Microcalanus" = "Microcalanus_spp_abundance",
                "Oithona" = "Oithona_spp_abundance",
                "Oithona atlantica" = "Oithona_atlantica_abundance",
                "Oithona similis" = "Oithona_similis_abundance",
                "Paracalanus" = "Paracalanus_spp_abundance",
                "Pseudocalanus" ="Pseudocalanus_abundance" ,
                "Temora longicornis" = "Temora_longicornis_abundance",
                "Other copepods HL2" = "other_copepods",
                "Other copepods P5" = "other_copepods",
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
readr::write_csv(Zooplankton_Occupations_Stations, "inst/extdata/csv/Zooplankton_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Stations, overwrite = TRUE)
