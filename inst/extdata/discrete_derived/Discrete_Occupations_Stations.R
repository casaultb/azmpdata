## code to prepare `Discrete_Occupations_Stations` dataset

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
Discrete_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_data_averaged_l %>%
                                                    dplyr::mutate(., station="HL2"),
                                                  P5_env$df_data_averaged_l %>%
                                                    dplyr::mutate(., station="P5"))

# assemble metadata
metadata <- dplyr::bind_rows(HL2_env$df_sample_filtered,
                             P5_env$df_sample_filtered)

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Chlorophyll_A" = "chlorophyll",
                "Nitrate" = "nitrate",
                "Phosphate" = "phosphate",
                "Silicate" = "silicate")

# print order
print_order_station <- c("HL2" = 1,
                         "P5" = 2)

# reformat data
Discrete_Occupations_Stations <- dplyr::left_join(Discrete_Occupations_Stations %>%
                                                    dplyr::select(., sample_id, parameter_name, data_value) %>%
                                                    dplyr::rename(., variable=parameter_name, value=data_value),
                                                  metadata %>%
                                                    dplyr::select(., sample_id, event_id, year, month, day,
                                                                  time, latitude, longitude, start_depth, standard_depth, station) %>%
                                                    dplyr::rename(depth=start_depth),
                                                  by=c("sample_id")) %>%
  dplyr::mutate(., order_station = unname(print_order_station[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  dplyr::group_by(., sample_id, variable) %>%
  dplyr::slice(., 1) %>%
  dplyr::ungroup(.) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::group_by(., event_id) %>%
  dplyr::arrange(., depth, .by_group=T) %>%
  dplyr::arrange(., order_station, year, month, day) %>%
  dplyr::ungroup(.)%>%
  dplyr::select(., station, latitude, longitude, year, month, day, event_id, sample_id,
                depth, standard_depth, unname(target_var))

# save data to csv
readr::write_csv(Discrete_Occupations_Stations, "inst/extdata/discrete_derived/Discrete_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Discrete_Occupations_Stations, overwrite = TRUE)
