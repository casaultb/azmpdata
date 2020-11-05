## code to prepare `Zooplankton_Annual_Stations` dataset

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
Zooplankton_Annual_Stations <- dplyr::bind_rows(HL2_abundance_env$df_log_abundance_means_annual_l %>%
                                                  dplyr::mutate(., station="HL2"),
                                                HL2_biomass_env$df_biomass_means_annual_l %>%
                                                  dplyr::mutate(., station="HL2"),
                                                P5_abundance_env$df_log_abundance_means_annual_l %>%
                                                  dplyr::mutate(., station="P5"),
                                                P5_biomass_env$df_biomass_means_annual_l %>%
                                                  dplyr::mutate(., station="P5"))
# clean up
rm(list=c("HL2_abundance_env", "HL2_biomass_env", "P5_abundance_env", "P5_biomass_env"))

# target variables to include
target_var <- c("Acartia" = "Acartia_log10",
                "Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "Calanus hyperboreus" = "Calanus_hyperboreus_log10",
                "Centropages" = "Centropages_log10",
                "Centropages typicus" = "Centropages_typicus_log10",
                "Eurytemora" = "Eurytemora_log10",
                "Metridia" = "Metridia_log10",
                "Metridia longa" = "Metridia_longa_log10",
                "Metridia lucens" = "Metridia_lucens_log10",
                "Microcalanus" = "Microcalanus_log10",
                "Oithona" = "Oithona_log10",
                "Oithona atlantica" = "Oithona_atlantica_log10",
                "Oithona similis" = "Oithona_similis_log10",
                "Paracalanus" = "Paracalanus_log10",
                "Pseudocalanus" ="Pseudocalanus_log10" ,
                "Temora longicornis" = "Temora_longicornis_log10",
                "Other copepods HL2" = "other_copepods_log10",
                "Other copepods P5" = "other_copepods_log10",
                "Copepods" = "copepods_log10",
                "Non-copepods" = "non_copepods_log10",
                "Arctic Calanus" = "Arctic_Calanus_species_log10",
                "Warm Offshore" = "warm_offshore_copepods_log10",
                "Warm Shelf" = "warm_shelf_copepods_log10",
                "dw2_S" = "mesozooplankton_dry_biomass",
                "ww2_T" = "zooplankton_wet_biomass")

# print order
print_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Zooplankton_Annual_Stations <- Zooplankton_Annual_Stations %>%
  dplyr::mutate(., order = unname(print_order[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., station, year, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Annual_Stations, "inst/extdata/zooplankton/Zooplankton_Annual_Stations.csv")

# save data to rda
usethis::use_data(Zooplankton_Annual_Stations, overwrite = TRUE)
