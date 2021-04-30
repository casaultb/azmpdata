## code to prepare `RemoteSensing_Annual_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# chl data
chl_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/biochemical/Surface_Chl_8day_MODIS.RData")
load(con, envir=chl_env)
close(con)
# bloom data
bloom_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/biochemical/Bloom_parameters_8day_MODIS.RData")
load(con, envir=bloom_env)
close(con)

# assemble data
RemoteSensing_Annual_Broadscale <- dplyr::bind_rows(chl_env$df_log_means_annual_l %>%
                                                      dplyr::mutate(variable="chl") %>%
                                                      dplyr::select(region, year, variable, value),
                                                    bloom_env$df_data_filtered_l %>%
                                                       dplyr::select(region, year, variable, value))

# clean up
rm(list=c("chl_env", "bloom_env"))

# rename regions
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^CS$', replacement = 'CS_remote_sensing')
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^ESS$', replacement = 'ESS_remote_sensing')
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^CSS$', replacement = 'CSS_remote_sensing')
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^WSS$', replacement = 'WSS_remote_sensing')
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^GB$', replacement = 'GB_remote_sensing')
RemoteSensing_Annual_Broadscale$region <- gsub(RemoteSensing_Annual_Broadscale$region, pattern = '^LS$', replacement = 'LS_remote_sensing')

# target variables to include
target_var <- c("chl" = "surface_chlorophyll_log10",
                "t[start]" = "bloom_start",
                "t[duration]" = "bloom_duration",
                "Amplitude[real]" = "bloom_amplitude",
                "Magnitude[real]" = "bloom_magnitude")

# print order
print_order <- c("CS_remote_sensing" = 1,
                 "ESS_remote_sensing" = 2,
                 "CSS_remote_sensing" = 3,
                 "WSS_remote_sensing" = 4,
                 "GB_remote_sensing" = 5,
                 "LS_remote_sensing" = 6)

# reformat data
RemoteSensing_Annual_Broadscale <- RemoteSensing_Annual_Broadscale %>%
  dplyr::mutate(order = unname(print_order[region])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order, year) %>%
  dplyr::select(region, year, unname(target_var))

# fix metadata
RemoteSensing_Annual_Broadscale <- RemoteSensing_Annual_Broadscale %>%
  dplyr::rename(area = region)

# save data to csv
readr::write_csv(RemoteSensing_Annual_Broadscale, "inst/extdata/csv/RemoteSensing_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(RemoteSensing_Annual_Broadscale, overwrite = TRUE)
