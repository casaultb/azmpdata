## code to prepare `Discrete_Annual_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# sea_temperature
path <- 'inst/extdata/areas/'
files <- list.files(path = path,
                    pattern = 'temperature0m\\w+\\.dat',
                    full.names = TRUE)

d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
#vardat1 <- unlist(lapply(d, function(k) k[['data']][['anomaly']]))
#vardat2 <- unlist(lapply(d, function(k) k[['data']][['normalizedAnomaly']]))

areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))
# update spatial name to differentiate between definitions of scotian shelf
areaName <- gsub(x = areaName, pattern = 'Scotian Shelf', replacement = 'scotian_shelf_box')

year <- unlist(lapply(d, function(k) k[['data']][['year']]))


df <- data.frame(year = year,
                 area = areaName,
                 sea_temperature = vardat) # verify this is correct variable name
sea_temperature <- df

# salinity
path <- 'inst/extdata/areas/'
files <- list.files(path = path,
                    pattern = 'salinity0m\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
#vardat1 <- unlist(lapply(d, function(k) k[['data']][['anomaly']]))
#vardat2 <- unlist(lapply(d, function(k) k[['data']][['normalizedAnomaly']]))

areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))
# update spatial name to differentiate between definitions of scotian shelf
areaName <- gsub(x = areaName, pattern = 'Scotian Shelf', replacement = 'scotian_shelf_box')

year <- unlist(lapply(d, function(k) k[['data']][['year']]))


df <- data.frame(year = year,
                 area = areaName,
                 salinity = vardat) # verify this is correct variable name
salinity <- df


# assemble data

Discrete_Annual_Broadscale <- dplyr::bind_rows(sea_temperature, salinity)



# save data
# save data to csv
readr::write_csv(Discrete_Annual_Broadscale, "inst/extdata/csv/Discrete_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(Discrete_Annual_Broadscale, overwrite = TRUE)

