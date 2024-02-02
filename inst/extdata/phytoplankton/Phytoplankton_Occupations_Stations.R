## code to prepare `Phytoplankton_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/Microplankton_Data_Grouped.RData")
load(con, envir=HL2_env)
close(con)
# P5
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/Microplankton_Data_Grouped.RData")
load(con, envir=P5_env)
close(con)

# assemble metadata
df_metadata <- dplyr::bind_rows(HL2_env$df_metadata,
                                P5_env$df_metadata)

# assemble data
Phytoplankton_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_abundance_grouped_l,
                                                       P5_env$df_abundance_grouped_l)
# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Diatoms" = "diatoms",
                "Dinoflagellates" = "dinoflagellates",
                "Flagellates" = "flagellates",
                "Ciliates" = "ciliates",
                "Microzooplankton" = "microzooplankton")

# print order
station_order <- c("HL2" = 1,
                   "P5" = 2)

# reformat data
Phytoplankton_Occupations_Stations <- Phytoplankton_Occupations_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata, by="custom_sample_id") %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, date) %>%
  # dplyr::select(station, latitude, longitude, date, unname(target_var))
  dplyr::select(station, date, unname(target_var))

# save data to csv
readr::write_csv(Phytoplankton_Occupations_Stations, "inst/extdata/csv/Phytoplankton_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Phytoplankton_Occupations_Stations, overwrite = TRUE)
