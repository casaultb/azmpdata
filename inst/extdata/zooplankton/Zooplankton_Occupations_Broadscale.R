## code to prepare `Zooplankton_Occupations_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# abundance data
abundance_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/biochemical/Zoo_Abundance_MAR_TS_NAFO.RData")
load(con, envir=abundance_env)
close(con)
# biomass data
biomass_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/biochemical/Zoo_Biomass_MAR_TS_NAFO.RData")
load(con, envir=biomass_env)
close(con)

# assemble data
Zooplankton_Occupations_Broadscale <- dplyr::bind_rows(abundance_env$df_abundance_grouped_l,
                                                     biomass_env$df_biomass_grouped_l)

# this is a workaround for handling metadata (e.g. lat, lon) that might be different between
# the abundance dataset and the biomass dataset (but should really be the same)
# assemble metadata
metadata <- dplyr::bind_rows(abundance_env$df_sample_filtered,
                             biomass_env$df_sample_filtered) %>%
  dplyr::select(sample_id, latitude, longitude, region, year, month, day, season) %>%
   dplyr::group_by(sample_id) %>%
  dplyr::slice(1) %>%
  dplyr::ungroup(.)

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_abundance",
                "dw2_S" = "zooplankton_meso_dry_weight",
                "ww2_T" = "zooplankton_total_wet_weight")

# print order
# season
print_order_season <- c("Winter" = 1,
                        "Summer" = 2)

# reformat data
Zooplankton_Occupations_Broadscale <- dplyr::left_join(Zooplankton_Occupations_Broadscale %>%
                                                       dplyr::select(sample_id, variable, value),
                                                     metadata,
                                                     by="sample_id") %>%
  dplyr::mutate(order_season = unname(print_order_season[season])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(year, order_season, month, day) %>%
  dplyr::select(latitude, longitude, year, month, day, season, sample_id,
                unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Occupations_Broadscale, "inst/extdata/csv/Zooplankton_Occupations_Broadscale.csv")

# save data to rda
usethis::use_data(Zooplankton_Occupations_Broadscale, overwrite = TRUE)
