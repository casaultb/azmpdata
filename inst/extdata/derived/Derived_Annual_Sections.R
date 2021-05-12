## code to prepare `Derived_Annual_Sections` dataset
cat('Sourcing Derived_Annual_Sections.R', sep = '\n')
library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/ChlNut_MAR_AZMP.RData")
load(con)
close(con)

# clean up
rm(list=setdiff(ls(), "df_means_annual_l"))

# target variables to include
target_var <- c("Chlorophyll_A_0_100" = "integrated_chlorophyll_0_100",
                "Nitrate_0_50" = "integrated_nitrate_0_50",
                "Nitrate_50_150" = "integrated_nitrate_50_150",
                "Phosphate_0_50" = "integrated_phosphate_0_50",
                "Phosphate_50_150" = "integrated_phosphate_50_150",
                "Silicate_0_50" = "integrated_silicate_0_50",
                "Silicate_50_150" = "integrated_silicate_50_150")

# print order
print_order <- c("CSL" = 1,
                 "LL" = 2,
                 "HL" = 3,
                 "BBL" = 4)

# reformat data
Derived_Annual_Sections <- df_means_annual_l %>%
  dplyr::rename(section = transect) %>%
  dplyr::mutate(order = unname(print_order[section])) %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::spread(variable, value) %>%
  dplyr::arrange(order, year) %>%
  dplyr::select(section, year, unname(target_var))

# save data to csv
readr::write_csv(Derived_Annual_Sections, "inst/extdata/csv/Derived_Annual_Sections.csv")

# save data to rda
usethis::use_data(Derived_Annual_Sections, overwrite = TRUE)
