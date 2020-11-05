## code to prepare `RemoteSensing_Annual_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
# chl data
chl_env <- new.env()
con <- url(unname(db_lookup["Surface_Chl_Weekly_MODIS.RData"]))
load(con, envir=chl_env)
close(con)
# bloom data
bloom_env <- new.env()
con <- url(unname(db_lookup["Bloom_parameters_Weekly_MODIS.RData"]))
load(con, envir=bloom_env)
close(con)

# assemble data
RemoteSensing_Annual_Broadscale <- dplyr::bind_rows(chl_env$df_log_means_annual_l %>%
                                                      dplyr::mutate(., variable="chl") %>%
                                                      dplyr::select(., region, year, variable, value),
                                                    bloom_env$df_data_filtered_l %>%
                                                       dplyr::select(., region, year, variable, value))
# clean up
rm(list=c("chl_env", "bloom_env"))

# target variables to include
target_var <- c("chl" = "surface_chlorophyll_log10",
                "start" = "bloom_start",
                "duration" = "bloom_duration",
                "amplitude" = "bloom_amplitude",
                "magnitude" = "bloom_magnitude")

# print order
print_order <- c("CS" = 1,
                 "ESS" = 2,
                 "CSS" = 3,
                 "WSS" = 4,
                 "GB" = 5,
                 "LS" = 6)

# reformat data
RemoteSensing_Annual_Broadscale <- RemoteSensing_Annual_Broadscale %>%
  dplyr::mutate(., order = unname(print_order[region])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., region, year, unname(target_var))

# save data to csv
readr::write_csv(RemoteSensing_Annual_Broadscale, "inst/extdata/remote_sensing/RemoteSensing_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(RemoteSensing_Annual_Broadscale, overwrite = TRUE)
