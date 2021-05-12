## code to prepare `Zooplankton_Seasonal_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# abundance data
abundance_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Zoo_Abundance_MAR_TS_NAFO.RData")
load(con, envir=abundance_env)
close(con)
# biomass data
biomass_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Zoo_Biomass_MAR_TS_NAFO.RData")
load(con, envir=biomass_env)
close(con)

# assemble data
Zooplankton_Seasonal_Broadscale <- dplyr::bind_rows(abundance_env$df_abundance_means_seasonal_l %>%
                                                      dplyr::select(year, season, region, variable, mean) %>%
                                                      dplyr::rename(value=mean) %>%
                                                      dplyr::filter((region=="5Ze" & season=="Winter") | (region %in% c("4V", "4W", "4X") & season=="Summer")),
                                                    biomass_env$df_biomass_means_seasonal_l %>%
                                                      dplyr::select(year, season, region, variable, mean) %>%
                                                      dplyr::rename(value=mean) %>%
                                                      dplyr::filter((region=="5Ze" & season=="Winter") | (region %in% c("4V", "4W", "4X") & season=="Summer")))

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus",
                "dw2_S" = "zooplankton_meso_dry_weight",
                "ww2_T" = "zooplankton_total_wet_weight")

# print order
print_order <- c("5Ze" = 1,
                 "4V" = 2,
                 "4W" = 3,
                 "4X" = 4)

# reformat data
Zooplankton_Seasonal_Broadscale <- Zooplankton_Seasonal_Broadscale %>%
  dplyr::mutate(order = unname(print_order[region])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order, year) %>%
  dplyr::select(region, year, season, unname(target_var))

# fix metadata
Zooplankton_Seasonal_Broadscale <- Zooplankton_Seasonal_Broadscale %>%
  dplyr::rename(area = region)

# save data to csv
readr::write_csv(Zooplankton_Seasonal_Broadscale, "inst/extdata/csv/Zooplankton_Seasonal_Broadscale.csv")

# save data to rda
usethis::use_data(Zooplankton_Seasonal_Broadscale, overwrite = TRUE)
