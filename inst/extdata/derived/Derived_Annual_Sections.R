## code to prepare `Derived_Annual_Sections` dataset
cat('Sourcing Derived_Annual_Sections.R', sep = '\n')

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/Means&Anomalies_Annual.RData")
load(con)
close(con)

# clean up
rm(list=setdiff(ls(), "df_means"))

# target variables to include
target_var <- c("Chlorophyll 0-100" = "integrated_chlorophyll_0_100",
                "Nitrate 0-50" = "integrated_nitrate_0_50",
                "Nitrate 50-150" = "integrated_nitrate_50_150",
                "Phosphate 0-50" = "integrated_phosphate_0_50",
                "Phosphate 50-150" = "integrated_phosphate_50_150",
                "Silicate 0-50" = "integrated_silicate_0_50",
                "Silicate 50-150" = "integrated_silicate_50_150")

# print order
section_order <- c("CSL" = 1,
                   "LL" = 2,
                   "HL" = 3,
                   "BBL" = 4)

# reformat data
Derived_Annual_Sections <- df_means %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::arrange(order_section, year) %>%
  dplyr::select(section, year, unname(target_var))

# save data to csv
readr::write_csv(Derived_Annual_Sections, "inst/extdata/csv/Derived_Annual_Sections.csv")

# save data to rda
usethis::use_data(Derived_Annual_Sections, overwrite = TRUE)
