## code to prepare `RemoteSensing_Weekly_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/biochemical/Surface_Chl_8day_MODIS.RData")
load(con)
close(con)

# clean up
rm(list=setdiff(ls(), "df_data_filtered"))

# target variables to include
target_var <- c("chl" = "surface_chlorophyll")

# print order
print_order <- c("CS" = 1,
                 "ESS" = 2,
                 "CSS" = 3,
                 "WSS" = 4,
                 "GB" = 5,
                 "LS" = 6)

# reformat data
RemoteSensing_Weekly_Broadscale <- df_data_filtered %>%
  dplyr::select(region, year, doy, value) %>%
  dplyr::filter(year<=2020) %>%
  dplyr::mutate(variable="chl") %>%
  dplyr::mutate(order = unname(print_order[region])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order, year) %>%
  dplyr::select(region, year, doy, unname(target_var))

# rename regions
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^CS$', replacement = 'CS_remote_sensing')
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^ESS$', replacement = 'ESS_remote_sensing')
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^CSS$', replacement = 'CSS_remote_sensing')
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^WSS$', replacement = 'WSS_remote_sensing')
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^GB$', replacement = 'GB_remote_sensing')
RemoteSensing_Weekly_Broadscale$region <- gsub(RemoteSensing_Weekly_Broadscale$region, pattern = '^LS$', replacement = 'LS_remote_sensing')

# fix metadata
RemoteSensing_Weekly_Broadscale <- RemoteSensing_Weekly_Broadscale %>%
  dplyr::rename(area = region)

# save data to csv
readr::write_csv(RemoteSensing_Weekly_Broadscale, "inst/extdata/csv/RemoteSensing_Weekly_Broadscale.csv")

# save data to rda
usethis::use_data(RemoteSensing_Weekly_Broadscale, overwrite = TRUE)
