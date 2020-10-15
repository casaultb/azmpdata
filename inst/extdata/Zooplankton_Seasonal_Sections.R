## code to prepare `Zooplankton_Seasonal_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# abundance data
abundance_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_MAR_AZMP_Abundance.RData", envir=abundance_env)
# biomass data
biomass_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/PL_MAR_AZMP_Biomass.RData", envir=biomass_env)

# assemble data
Zooplankton_Seasonal_Sections <- dplyr::bind_rows(abundance_env$df_log_abundance_means_seasonal_l %>%
                                                    dplyr::select(., transect, year, season, variable, value) %>%
                                                    dplyr::rename(., section=transect),
                                                  biomass_env$df_biomass_means_seasonal_l %>%
                                                    dplyr::select(., transect, year, season, variable, value) %>%
                                                    dplyr::rename(., section=transect))

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "dw2_S" = "mesozooplankton_dry_biomass",
                "ww2_T" = "zooplankton_wet_biomass")

# print order
# section
print_order_section <- c("CSL" = 1,
                         "LL" = 2,
                         "HL" = 3,
                         "BBL" = 4)

# season
print_order_season <- c("Spring" = 1,
                         "Fall" = 2)

# reformat data
Zooplankton_Seasonal_Sections <- Zooplankton_Seasonal_Sections %>%
  dplyr::mutate(., order_section = unname(print_order_section[section])) %>%
  dplyr::mutate(., order_season = unname(print_order_season[season])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order_section, year, order_season) %>%
  dplyr::select(., section, year, season, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Seasonal_Sections, "inst/extdata/Zooplankton_Seasonal_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Seasonal_Sections, overwrite = TRUE)
