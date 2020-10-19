## code to prepare `Derived_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_chlnuts_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/DIS_HL2_ChlNut.RData", envir=HL2_chlnuts_env)
# P5
P5_chlnuts_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/biochem/DIS_P5_ChlNut.RData", envir=P5_chlnuts_env)
# physics
physics_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/physics/Physics.RData", envir=physics_env)
# optics
optics_env <- new.env()
load("~/Projects/AZMP_Reporting_2020/outputs/physics/Optics.RData", envir=optics_env)

# assemble data
Derived_Occupations_Stations <- dplyr::bind_rows(HL2_chlnuts_env$df_data_integrated_l %>%
                                                   dplyr::mutate(., station="HL2"),
                                                 P5_chlnuts_env$df_data_integrated_l %>%
                                                   dplyr::mutate(., station="P5"),
                                                 physics_env$df_data_filtered_l,
                                                 optics_env$df_data_filtered_l)

# clean up
rm(list=c("HL2_chlnuts_env", "P5_chlnuts_env", "physics_env", "optics_env"))

#------------------
# remove duplicates - this is not good thing to do!
index <- Derived_Occupations_Stations %>% with(which(year==2002 & month==10 & day==23 & variable=="mld_m"))
Derived_Occupations_Stations <- Derived_Occupations_Stations[-index[2],]
index <- Derived_Occupations_Stations %>% with(which(year==2002 & month==10 & day==23 & variable=="strat_idx"))
Derived_Occupations_Stations <- Derived_Occupations_Stations[-index[2],]
#------------------

#------------------
# this is a workaround for handling metadata as event_id is not available for physics
# and optics data
# assemble metadata
metadata <- Derived_Occupations_Stations %>%
  dplyr::select(., event_id, station, year, month, day) %>%
  dplyr::group_by(., station, year, month, day) %>%
  dplyr::arrange(., event_id, .by_group=T) %>%
  dplyr::slice(1) %>%
  dplyr::ungroup(.)
#------------------

# target variables to include
target_var <- c("mld_m" = "mixed_layer_depth",
                "strat_idx" = "stratification_index",
                "zeu_par" = "euphotic_depth",
                "Chlorophyll_A_0_100" = "chlorophyll_0_100",
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
Derived_Occupations_Stations <- dplyr::left_join(Derived_Occupations_Stations %>%
                                                   dplyr::select(., -event_id),
                                                 metadata,
                                                 by=c("station", "year", "month", "day")) %>%
  dplyr::mutate(., order_station = unname(print_order_station[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(., id_cols=c("event_id", "station", "year", "month", "day"),
                     names_from=variable, values_from=value, values_fill=list(value=NA)) %>%
  dplyr::arrange(., order_station, year, month, day) %>%
  dplyr::select(., station, latitude, longitude, year, month, day, event_id,
                unname(target_var))

# save data to csv
readr::write_csv(Derived_Occupations_Stations, "inst/extdata/Derived_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Derived_Occupations_Stations, overwrite = TRUE)
