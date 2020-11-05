## code to prepare `Zooplankton_Seasonal_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
# abundance data
abundance_env <- new.env()
con <- url(unname(db_lookup["PL_MAR_TS_Abundance.RData"]))
load(con, envir=abundance_env)
close(con)
# biomass data
biomass_env <- new.env()
con <- url(unname(db_lookup["PL_MAR_TS_Biomass.RData"]))
load(con, envir=biomass_env)
close(con)

# assemble data
Zooplankton_Seasonal_Broadscale <- dplyr::bind_rows(abundance_env$df_log_abundance_means_seasonal_l %>%
                                                      dplyr::select(., year, season, variable, value) %>%
                                                      dplyr::mutate(., region=ifelse(season=="Winter", "Georges Bank",
                                                                                     ifelse(season=="Summer", "Scotian Shelf", NA))),
                                                    biomass_env$df_biomass_means_seasonal_l %>%
                                                      dplyr::select(., year, season, variable, value) %>%
                                                      dplyr::mutate(., region=ifelse(season=="Winter", "Georges Bank",
                                                                                     ifelse(season=="Summer", "Scotian Shelf", NA))))

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "dw2_S" = "mesozooplankton_dry_biomass",
                "ww2_T" = "zooplankton_wet_biomass")

# print order
print_order <- c("Georges Bank" = 1,
                 "Scotian Shelf" = 4)

# reformat data
Zooplankton_Seasonal_Broadscale <- Zooplankton_Seasonal_Broadscale %>%
  dplyr::mutate(., order = unname(print_order[region])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., region, year, season, unname(target_var))

# save data to csv
readr::write_csv(Zooplankton_Seasonal_Broadscale, "inst/extdata/zooplankton/Zooplankton_Seasonal_Broadscale.csv")

# save data to rda
usethis::use_data(Zooplankton_Seasonal_Broadscale, overwrite = TRUE)
