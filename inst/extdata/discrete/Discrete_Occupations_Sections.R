## code to prepare `Discrete_Occupations_Sections` dataset
cat('Sourcing Discrete_Occupations_Sections.R', sep = '\n')

library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)

# source custom functions
source("~/Projects/Utils/R/azmp/Standard_Depth_Lookup.R") # not needed here

# load data
cat('    reading in biochemical section data', sep = '\n')
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Seasonal_Surveys_MAR/ChlNut_Data_Filtered.RData")
load(con)
close(con)

# load physical data
cat('    reading in physical section data', sep = '\n')
url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/sections/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))


# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.csv(con)
}
############################
# this requires to be fixed
############################
# posections <- do.call('rbind', d)
posections <- d[[1]]

# rename variables
posections <- posections %>%
  dplyr::rename(depth = pressure) %>%
  tidyr::unite(date, year, month, day, sep="-", remove=T) %>%
  dplyr::mutate(date = lubridate::ymd(date))


# target variables to include
target_var <- c("Chlorophyll A" = "chlorophyll",
                "Nitrate" = "nitrate",
                "Phosphate" = "phosphate",
                "Silicate" = "silicate")

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
Discrete_Occupations_Sections <- df_data_averaged_l %>%
  dplyr::filter(parameter_name %in% names(target_var)) %>%
  dplyr::mutate(parameter_name = unname(target_var[parameter_name])) %>%
  tidyr::pivot_wider(names_from=parameter_name, values_from=data_value) %>%
  dplyr::left_join(df_metadata  %>%
                     # add nominal depth (the vectorized function)
                     mutate(year=lubridate::year(date)),
                   by=c("custom_sample_id")) %>%
  dplyr::mutate(order_section = unname(section_order[section])) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::mutate(order_season = unname(season_order[season])) %>%
  dplyr::arrange(order_section, year, order_season, order_station, depth) %>%
  # dplyr::select(station, latitude, longitude, date, depth, nominal_depth, unname(target_var))
  dplyr::select(section, station, latitude, longitude, date, depth, unname(target_var))

# join physical data
Discrete_Occupations_Sections <- Discrete_Occupations_Sections %>%
  dplyr::bind_rows(., posections)

# save as dataframe not tibble
Discrete_Occupations_Sections <- as.data.frame(Discrete_Occupations_Sections)

# save data to csv
readr::write_csv(Discrete_Occupations_Sections, "inst/extdata/csv/Discrete_Occupations_Sections.csv")

# save data to rda
usethis::use_data(Discrete_Occupations_Sections, overwrite = TRUE)
