## code to prepare `Derived_Occupations_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/ChlNut_MAR_AZMP.RData")
load(con)
close(con)

# clean up
rm(list=setdiff(ls(), "df_data_integrated_l"))

# target variables to include
target_var <- c("Chlorophyll_A_0_100" = "integrated_chlorophyll_0_100",
                "Nitrate_0_50" = "integrated_nitrate_0_50",
                "Nitrate_50_150" = "integrated_nitrate_50_150",
                "Phosphate_0_50" = "integrated_phosphate_0_50",
                "Phosphate_50_150" = "integrated_phosphate_50_150",
                "Silicate_0_50" = "integrated_silicate_0_50",
                "Silicate_50_150" = "integrated_silicate_50_150")

# print order
# section
print_order_section <- c("CSL" = 1,
                         "LL" = 2,
                         "HL" = 3,
                         "BBL" = 4)
# section
print_order_station <- c("CSL1" = 1, "CSL2" = 2, "CSL3" = 3, "CSL4" = 4, "CSL5" = 5, "CSL6" = 6,
                         "LL1" = 1, "LL2" = 2, "LL3" = 3, "LL4" = 4, "LL5" = 5, "LL6" = 6, "LL7" = 7, "LL8" = 8, "LL9" = 9,
                         "HL1" = 1, "HL2" = 2, "HL3" = 3, "HL4" = 4, "HL5" = 5, "HL6" = 6, "HL7" = 7,
                         "BBL1" = 1, "BBL2" = 2, "BBL3" = 3, "BBL4" = 4, "BBL5" = 5, "BBL6" = 6, "BBL7" = 7)
# season
print_order_season <- c("Spring" = 1,
                        "Fall" = 2)

# reformat data
Derived_Occupations_Sections <- df_data_integrated_l %>%
  dplyr::rename(section = transect) %>%
  dplyr::mutate(order_section = unname(print_order_section[section])) %>%
  dplyr::mutate(order_station = unname(print_order_station[station])) %>%
  dplyr::mutate(order_season = unname(print_order_season[season])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order_section, year, order_season, order_station) %>%
  dplyr::select(section, station, latitude, longitude, year, month, day, event_id,
                unname(target_var))

# save as dataframe not tibble
Derived_Occupations_Sections <- as.data.frame(Derived_Occupations_Sections)

# save data to csv
readr::write_csv(Derived_Occupations_Sections, "inst/extdata/csv/Derived_Occupations_Sections.csv")

# save data to rda
usethis::use_data(Derived_Occupations_Sections, overwrite = TRUE)
