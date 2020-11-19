## code to prepare `Zooplankton_Annual_Sections` dataset

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
con <- url(unname(db_lookup["PL_MAR_AZMP_Abundance.RData"]))
load(con, envir=abundance_env)
close(con)
# biomass data
biomass_env <- new.env()
con <- url(unname(db_lookup["PL_MAR_AZMP_Biomass.RData"]))
load(con, envir=biomass_env)
close(con)

# assemble data
Zooplankton_Annual_Sections <- dplyr::bind_rows(abundance_env$df_log_abundance_means_annual_l %>%
                                                  dplyr::select(., transect, year, variable, value),
                                                biomass_env$df_biomass_means_annual_l %>%
                                                  dplyr::select(., transect, year, variable, value))

# clean up
rm(list=c("abundance_env", "biomass_env"))

# target variables to include
target_var <- c("Calanus finmarchicus" = "Calanus_finmarchicus_log10",
                "Pseudocalanus" = "Pseudocalanus_log10",
                "Copepods" = "copepods_log10",
                "Non-copepods" = "non_copepods_log10",
                "Arctic Calanus" = "Arctic_Calanus_species_log10",
                "Warm Offshore" = "warm_offshore_copepods_log10",
                "Warm Shelf" = "warm_shelf_copepods_log10",
                "dw2_S" = "zooplankton_meso_dry_weight",
                "ww2_T" = "zooplankton_total_wet_weight")

# print order
print_order <- c("CSL" = 1,
                 "LL" = 2,
                 "HL" = 3,
                 "BBL" = 4)

# reformat data
Zooplankton_Annual_Sections <- Zooplankton_Annual_Sections %>%
  dplyr::rename(., section = transect) %>%
  dplyr::mutate(., order = unname(print_order[section])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., section, year, unname(target_var))



# save data to csv
readr::write_csv(Zooplankton_Annual_Sections, "inst/extdata/csv/Zooplankton_Annual_Sections.csv")

# save data to rda
usethis::use_data(Zooplankton_Annual_Sections, overwrite = TRUE)
