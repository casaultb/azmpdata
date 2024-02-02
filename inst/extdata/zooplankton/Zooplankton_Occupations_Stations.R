## code to prepare `Zooplankton_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/RingNet_Data_Grouped.RData")
load(con, envir=HL2_env)
close(con)
# P5
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/RingNet_Data_Grouped.RData")
load(con, envir=P5_env)
close(con)

# assemble metadata
df_metadata <- dplyr::bind_rows(HL2_env$df_metadata,
                                P5_env$df_metadata)

# assemble data
Zooplankton_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_abundance_grouped_l,
                                                     HL2_env$df_biomass_grouped_l,
                                                     P5_env$df_abundance_grouped_l,
                                                     P5_env$df_biomass_grouped_l)
# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Acartia spp" = "Acartia_abundance",
                "Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "Calanus glacialis" = "Calanus_glacialis_abundance",
                "Calanus hyperboreus" = "Calanus_hyperboreus_abundance",
                "Centropages spp" = "Centropages_spp_abundance",
                "Centropages typicus" = "Centropages_typicus_abundance",
                "Eurytemora spp" = "Eurytemora_abundance",
                "Metridia" = "Metridia_spp_abundance",
                "Metridia longa" = "Metridia_longa_abundance",
                "Metridia lucens" = "Metridia_lucens_abundance",
                "Microcalanus sp" = "Microcalanus_spp_abundance",
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
                "dw2_S" = "zooplankton_meso_dry_weight")

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
station_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Zooplankton_Occupations_Stations <- Zooplankton_Occupations_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata, by="custom_sample_id") %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, date) %>%
  dplyr::select(station, latitude, longitude, date, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Occupations_Stations, "inst/extdata/csv/Zooplankton_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Stations, overwrite = TRUE)
