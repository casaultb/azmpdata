## code to prepare `Discrete_Annual_Broadscale` dataset
cat('Sourcing Discrete_Annual_Broadscale.R', sep = '\n')

library(dplyr)
library(tidyr)
library(readr)
library(usethis)

# load data
# sea_temperature
cat('    reading in areas surface temperature data', sep = '\n')

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/areas/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files
fn <- grep(filenames, pattern = 'temperature0m\\w+\\.dat', value = TRUE)

# create dataframe list
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}

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
cat('    reading in areas surface salinity data', sep = '\n')

result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files
fn <- grep(filenames, pattern = 'salinity0m\\w+\\.dat', value = TRUE)

# create dataframe list
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}

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

