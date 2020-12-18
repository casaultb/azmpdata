## code to prepare `Derived_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/outputs/DIS_HL2_ChlNut.RData")
load(con, envir=HL2_env)
close(con)
# P5
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/outputs/DIS_P5_ChlNut.RData")
load(con, envir=P5_env)
close(con)

# assemble data
Derived_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_data_integrated_l %>%
                                                   dplyr::mutate(., station="HL2"),
                                                 P5_env$df_data_integrated_l %>%
                                                   dplyr::mutate(., station="P5"))

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Chlorophyll_A_0_100" = "chlorophyll_0_100",
                "Nitrate_0_50" = "nitrate_0_50",
                "Nitrate_50_150" = "nitrate_50_150",
                "Phosphate_0_50" = "phosphate_0_50",
                "Phosphate_50_150" = "phosphate_50_150",
                "Silicate_0_50" = "silicate_0_50",
                "Silicate_50_150" = "silicate_50_150")

# print order
print_order_station <- c("HL2" = 1,
                         "P5" = 2)

# reformat data
Derived_Occupations_Stations <- Derived_Occupations_Stations %>%
  dplyr::mutate(., order_station = unname(print_order_station[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order_station, year, month, day) %>%
  dplyr::select(., station, latitude, longitude, year, month, day, event_id, unname(target_var))

# save data to csv
readr::write_csv(Derived_Occupations_Stations, "inst/extdata/csv/Derived_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Derived_Occupations_Stations, overwrite = TRUE)
