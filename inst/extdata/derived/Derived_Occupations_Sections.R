## code to prepare `Derived_Occupations_Sections` dataset
cat('Sourcing Derived_Occupations_Sections.R', sep = '\n')

library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(usethis)

# load data
cat('    reading in biochemical data', sep = '\n')
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/ChlNut_Data_Integrated.RData")
load(con)
close(con)

# clean up
rm(list=setdiff(ls(), c("df_metadata", "df_data_integrated_l")))

# target variables to include
target_var <- c("Chlorophyll 0-100" = "integrated_chlorophyll_0_100",
                "Nitrate 0-50" = "integrated_nitrate_0_50",
                "Nitrate 50-150" = "integrated_nitrate_50_150",
                "Phosphate 0-50" = "integrated_phosphate_0_50",
                "Phosphate 50-150" = "integrated_phosphate_50_150",
                "Silicate 0-50" = "integrated_silicate_0_50",
                "Silicate 50-150" = "integrated_silicate_50_150")

# print order
# section
section_order <- c("CSL" = 1,
                   "LL" = 2,
                   "HL" = 3,
                   "BBL" = 4)
# section
station_order <- c("CSL1" = 1, "CSL2" = 2, "CSL3" = 3, "CSL4" = 4, "CSL5" = 5, "CSL6" = 6,
                   "LL1" = 1, "LL2" = 2, "LL3" = 3, "LL4" = 4, "LL5" = 5, "LL6" = 6, "LL7" = 7, "LL8" = 8, "LL9" = 9,
                   "HL1" = 1, "HL2" = 2, "HL3" = 3, "HL4" = 4, "HL5" = 5, "HL6" = 6, "HL7" = 7,
                   "BBL1" = 1, "BBL2" = 2, "BBL3" = 3, "BBL4" = 4, "BBL5" = 5, "BBL6" = 6, "BBL7" = 7)
# season
season_order <- c("Spring" = 1,
                  "Fall" = 2)

# reformat data
Derived_Occupations_Sections <- df_data_integrated_l %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::left_join(df_metadata %>%
                     dplyr::mutate(year = lubridate::year(date)),
                   by="custom_event_id") %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::mutate(order_season = unname(season_order[season])) %>%
  dplyr::arrange(order_section, year, order_season, order_station) %>%
  dplyr::select(section, station, latitude, longitude, date, unname(target_var))

# save as dataframe not tibble
Derived_Occupations_Sections <- as.data.frame(Derived_Occupations_Sections)

# save data to csv
readr::write_csv(Derived_Occupations_Sections, "inst/extdata/csv/Derived_Occupations_Sections.csv")

# save data to rda
usethis::use_data(Derived_Occupations_Sections, overwrite = TRUE)
