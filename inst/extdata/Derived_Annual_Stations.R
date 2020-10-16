## code to prepare `Derived_Annual_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/DIS_HL2_ChlNut.RData", envir=HL2_env)
# P5
P5_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/DIS_P5_ChlNut.RData", envir=P5_env)

# assemble data
Derived_Annual_Stations <- dplyr::bind_rows(HL2_env$df_means_annual_l %>%
                                              dplyr::mutate(., station="HL2"),
                                            P5_env$df_means_annual_l %>%
                                              dplyr::mutate(., station="P5"))

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Chlorophyll_A_0_100" = "integrated_chlorophyll_0_100",
                "Nitrate_0_50" = "integrated_nitrate_0_50",
                "Nitrate_50_150" = "integrated_nitrate_50_150",
                "Phosphate_0_50" = "integrated_phosphate_0_50",
                "Phosphate_50_150" = "integrated_phosphate_50_150",
                "Silicate_0_50" = "integrated_silicate_0_50",
                "Silicate_50_150" = "integrated_silicate_50_150")

# print order
print_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::mutate(., order = unname(print_order[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::arrange(., order, year) %>%
  dplyr::select(., station, year, unname(target_var))

# save data to csv
readr::write_csv(Derived_Annual_Stations, "inst/extdata/Derived_Annual_Stations.csv")

# save data to rda
usethis::use_data(Derived_Annual_Stations, overwrite = TRUE)
