## code to prepare `Zooplankton_Annual_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/Means&Anomalies_Annual.RData")
load(con, envir=HL2_env)
close(con)
# P5
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/Means&Anomalies_Annual.RData")
load(con, envir=P5_env)
close(con)

# assemble data
Zooplankton_Annual_Stations <- dplyr::bind_rows(HL2_env$df_means,
                                                P5_env$df_means)

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Acartia spp" = "Acartia_log10",
                "Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "Calanus hyperboreus" = "Calanus_hyperboreus_log10",
                "Centropages spp" = "Centropages_spp_log10",
                # "Centropages typicus" = "Centropages_typicus_log10",
                "Eurytemora spp" = "Eurytemora_log10",
                # "Metridia" = "Metridia_spp_log10",
                "Metridia longa" = "Metridia_longa_log10",
                "Metridia lucens" = "Metridia_lucens_log10",
                "Microcalanus sp" = "Microcalanus_spp_log10",
                # "Oithona spp" = "Oithona_spp_log10",
                "Oithona atlantica" = "Oithona_atlantica_log10",
                "Oithona similis" = "Oithona_similis_log10",
                "Paracalanus sp" = "Paracalanus_sp_log10",
                "Pseudocalanus" ="Pseudocalanus_log10" ,
                "Temora longicornis" = "Temora_longicornis_log10",
                "Other copepods HL2" = "other_copepods_log10",
                "Other copepods P5" = "other_copepods_log10",
                "Copepods" = "copepods_log10",
                "Non-copepods" = "non_copepods_log10",
                "Arctic Calanus" = "Arctic_Calanus_species_log10",
                "Warm Offshore" = "warm_offshore_copepods_log10",
                "Warm Shelf" = "warm_shelf_copepods_log10",
                "dw2_S" = "zooplankton_meso_dry_weight")

# print order
station_order <- c("HL2" = 1,
                   "P5" = 2)

# reformat data
Zooplankton_Annual_Stations <- Zooplankton_Annual_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, year) %>%
  dplyr::select(station, year, unname(target_var))

# # save data to csv
readr::write_csv(Zooplankton_Annual_Stations, "inst/extdata/csv/Zooplankton_Annual_Stations.csv")

# save data to rda
usethis::use_data(Zooplankton_Annual_Stations, overwrite = TRUE)
