## code to prepare `Phytoplankton_Annual_Stations` dataset

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
Phytoplankton_Annual_Stations <- dplyr::bind_rows(HL2_env$df_means,
                                                  P5_env$df_means)

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Diatoms" = "diatoms_log10",
                "Dinoflagellates" = "dinoflagellates_log10",
                "Flagellates" = "flagellates_log10",
                "Ciliates" = "ciliates_log10")

# print order
station_order <- c("HL2" = 1,
                   "P5" = 2)

# reformat data
Phytoplankton_Annual_Stations <- Phytoplankton_Annual_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, year) %>%
  dplyr::select(station, year, unname(target_var))

# save data to csv
readr::write_csv(Phytoplankton_Annual_Stations, "inst/extdata/csv/Phytoplankton_Annual_Stations.csv")

# save data to rda
usethis::use_data(Phytoplankton_Annual_Stations, overwrite = TRUE)
