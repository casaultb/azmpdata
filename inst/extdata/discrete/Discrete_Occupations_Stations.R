## code to prepare `Discrete_Occupations_Stations` dataset
cat('Sourcing Discrete_Occupations_Stations.R', sep = '\n')

library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)

# source custom functions
source("~/Projects/Utils/R/azmp/Standard_Depth_Lookup.R")

# load data
# HL2
cat('    reading in station2 biochemical data', sep = '\n')
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/ChlNut_Data_Filtered.RData")
load(con, envir=HL2_env)
close(con)
# P5
cat('    reading in prince5 biochemical data', sep = '\n')
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/ChlNut_Data_Filtered.RData")
load(con, envir=P5_env)
close(con)

# load physical data

# 1. read in mission look up tables and combine
cat('    reading in lookup table data', sep = '\n')

url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/lookup/' # have to move this to new directory
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))
lookup <- list()
lookup[[1]] <- read.csv(paste0(url_name, filenames[1]))
lookup[[2]] <- read.csv(paste0(url_name, filenames[2]))
# lookupfiles <- list.files(lookupPath, pattern = '^mission.*', full.names = TRUE)
# lookup <- lapply(lookupfiles, read.csv)
missions <- do.call('rbind', lookup)

# 2. read in the data and combine
cat('    reading in station2 and prince5 physical data', sep = '\n')
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/fixedStations/'
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# only pick out relevant files
filenames <- grep(filenames, pattern = '*IntegratedVariables*', value = TRUE, invert = TRUE)

d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.csv(con)
}

############################
# this requires to be fixed
############################
# # datafile <- paste(dataPath, c('prince5.csv', 'station2.csv'), sep = '/')
# # d <- lapply(datafile, read.csv)
#  d <- do.call('rbind', d)
# 
# # 3. match up cruiseNumber and mission_number
# # note : if anything goes sideways matching up idx, the structure of idx will change
# #        so it could become a list instead of a vector
# idx <- apply(d, 1, function(k) {ok <- which(missions[['mission_name']] == k[['cruiseNumber']]);
#                                 if(length(ok) > 1) {
#                                   ok[1]
#                                 } else if(length(ok) == 0){
#                                   NA
#                                 } else {
#                                   ok
#                                 }})
#
# d <- cbind(d, descriptor = missions[['mission_descriptor']][idx])
#
# fixedStationsPO <- d
fixedStationsPO <- rbind(d[[3]], d[[2]])

# rename variables
fixedStationsPO <- fixedStationsPO %>%
  dplyr::rename(sea_temperature = temperature) %>%
  dplyr::rename(depth = pressure) %>%
  dplyr::filter(year>=1999) %>%
  tidyr::unite(date, year, month, day, sep="-", remove=T) %>%
  dplyr::mutate(date = lubridate::ymd(date))

# assemble metadata
df_metadata <- dplyr::bind_rows(HL2_env$df_metadata %>%
                                  dplyr::mutate(nominal_depth=Standard_Depth_Lookup(depth, "HL2")),
                                P5_env$df_metadata %>%
                                  dplyr::mutate(nominal_depth=Standard_Depth_Lookup(depth, "P5")))

# assemble data
Discrete_Occupations_Stations <- dplyr::bind_rows(HL2_env$df_data_averaged_l,
                                                  P5_env$df_data_averaged_l)

# clean up
rm(list=c("HL2_env", "P5_env"))

# target variables to include
target_var <- c("Chlorophyll A" = "chlorophyll",
                "Nitrate" = "nitrate",
                "Phosphate" = "phosphate",
                "Silicate" = "silicate")

# print order
print_order_station <- c("HL2" = 1,
                         "P5" = 2)

# reformat data
Discrete_Occupations_Stations <- Discrete_Occupations_Stations %>%
  dplyr::filter(parameter_name %in% names(target_var)) %>%
  dplyr::mutate(parameter_name = unname(target_var[parameter_name])) %>%
  tidyr::pivot_wider(names_from=parameter_name, values_from=data_value) %>%
  dplyr::left_join(df_metadata %>%
                     # dplyr::select(custom_sample_id, custom_event_id, date, latitude, longitude, start_depth, standard_depth, station) %>%
                     dplyr::select(custom_sample_id, custom_event_id, date, latitude, longitude, depth, nominal_depth, station),
                   by=c("custom_sample_id")) %>%
  dplyr::mutate(order_station = unname(print_order_station[station])) %>%
  dplyr::group_by(custom_event_id) %>%
  dplyr::arrange(depth, .by_group=T) %>%
  dplyr::arrange(order_station, date) %>%
  dplyr::ungroup() %>%
  dplyr::select(station, latitude, longitude, date, depth, nominal_depth, unname(target_var))

# # fix metadata names
# Discrete_Occupations_Stations <- Discrete_Occupations_Stations %>%
# dplyr::rename(nominal_depth = standard_depth)

# add physical data
Discrete_Occupations_Stations <- Discrete_Occupations_Stations %>%
  dplyr::bind_rows(., fixedStationsPO)

# save as dataframe not tibble
Discrete_Occupations_Stations <- as.data.frame(Discrete_Occupations_Stations)

# save data to csv
readr::write_csv(Discrete_Occupations_Stations, "inst/extdata/csv/Discrete_Occupations_Stations.csv")

# save data to rda
usethis::use_data(Discrete_Occupations_Stations, overwrite = TRUE)
