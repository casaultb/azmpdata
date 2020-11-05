## code to prepare `RemoteSensing_Weekly_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
con <- url(unname(db_lookup["Surface_Chl_Weekly_MODIS.RData"]))
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
  dplyr::select(., region, year, month, week, value) %>%
  dplyr::mutate(., variable="chl") %>%
  dplyr::mutate(., order = unname(print_order[region])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., region, year, month, week, unname(target_var))

# save data to csv
readr::write_csv(RemoteSensing_Weekly_Broadscale, "inst/extdata/remote_sensing/RemoteSensing_Weekly_Broadscale.csv")

# save data to rda
usethis::use_data(RemoteSensing_Weekly_Broadscale, overwrite = TRUE)
