## code to prepare `Phytoplankton_Occupations_Stations` dataset

library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(usethis)

# load dropbox lookup table
db_lookup <- readr::read_csv(file="inst/extdata/dropbox_lookup.csv", comment="#")
db_lookup <- tibble::deframe(db_lookup)

# load data
con <- url(unname(db_lookup["Microplankton.RData"]))
load(con)

# clean up
rm(list=setdiff(ls(), "df_abundance_grouped_l"))

# target variables to include
target_var <- c("Diatoms" = "diatoms",
                "Dinoflagellates" = "dinoflagellates",
                "Flagellates" = "flagellates",
                "Ciliates" = "ciliates",
                "Microzooplankton" = "microzooplankton")

# print order
print_order <- c("HL2" = 1,
                 "P5" = 2)

# reformat data
Phytoplankton_Occupations_Stations <- df_abundance_grouped_l %>%
  dplyr::mutate(., station = ifelse(station=="HL_02", "HL2",
                                    ifelse(station=="P_05", "P5", NA))) %>%
  dplyr::mutate(., order = unname(print_order[station])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  #----------------
# this will have to be updated once data get extracted from Biochem
#----------------
dplyr::mutate(., latitude = ifelse(station=="HL2", 44.2670,
                                   ifelse(station=="P5", 44.9300, NA))) %>%
  dplyr::mutate(., longitude = ifelse(station=="HL2",  -63.31700,
                                      ifelse(station=="P5", -66.8500, NA))) %>%
  dplyr::mutate(., time=NA) %>%
  tidyr::separate(., sample_id, c("mission_id", "event_id", "sample_id"), sep="_") %>%
  #----------------
tidyr::spread(., variable, value) %>%
  dplyr::filter(., !is.na(station)) %>%
  dplyr::arrange(., order, year, month, day, time) %>%
  dplyr::select(., station, latitude, longitude, year, month, day, event_id, sample_id,
                unname(target_var))

# save data to csv
readr::write_csv(Phytoplankton_Occupations_Stations, "inst/extdata/phytoplankton/Phytoplankton_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Phytoplankton_Occupations_Stations, overwrite = TRUE)
