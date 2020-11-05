## code to prepare `Derived_Annual_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
# HL2
HL2_env <- new.env()
con <- url(unname(db_lookup["DIS_HL2_ChlNut.RData"]))
load(con, envir=HL2_env)
close(con)
# P5
P5_env <- new.env()
con <- url(unname(db_lookup["DIS_P5_ChlNut.RData"]))
load(con, envir=P5_env)
close(con)

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


# rename station column to match meta conventions
# NEEDS TO BE RUN BY BENOIT
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::rename(., station_name = station)


# save data to csv
readr::write_csv(Derived_Annual_Stations, "inst/extdata/discrete_derived/Derived_Annual_Stations.csv")

# save data to rda
usethis::use_data(Derived_Annual_Stations, overwrite = TRUE)
