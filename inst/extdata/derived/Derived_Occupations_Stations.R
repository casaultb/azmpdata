## code to prepare `Derived_Occupations_Stations` dataset
cat('Sourcing Derived_Occupations_Stations.R', sep = '\n')

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# HL2
cat('    reading in station2 biochemical data', sep = '\n')
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/ChlNut_Data_Integrated.RData")
load(con, envir=HL2_env)
close(con)
# P5
cat('    reading in prince5 biochemical data', sep = '\n')
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/ChlNut_Data_Integrated.RData")
load(con, envir=P5_env)
close(con)

# assemble metadata
df_metadata <- dplyr::bind_rows(HL2_env$df_metadata,
                                P5_env$df_metadata)

# assemble data
Derived_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_data_integrated_l,
                                                 P5_env$df_data_integrated_l)

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Chlorophyll 0-100" = "integrated_chlorophyll_0_100",
                "Nitrate 0-50" = "integrated_nitrate_0_50",
                "Nitrate 50-150" = "integrated_nitrate_50_150",
                "Phosphate 0-50" = "integrated_phosphate_0_50",
                "Phosphate 50-150" = "integrated_phosphate_50_150",
                "Silicate 0-50" = "integrated_silicate_0_50",
                "Silicate 50-150" = "integrated_silicate_50_150")

# print order
station_order <- c("HL2" = 1,
                   "P5" = 2)

# reformat data
Derived_Occupations_Stations <- Derived_Occupations_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata,
                   by="custom_event_id") %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, date) %>%
  dplyr::select(station, latitude, longitude, date, custom_event_id, unname(target_var))

# save as dataframe not tibble
Derived_Occupations_Stations <- as.data.frame(Derived_Occupations_Stations)

# save data to csv
readr::write_csv(Derived_Occupations_Stations, "inst/extdata/csv/Derived_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Derived_Occupations_Stations, overwrite = TRUE)
