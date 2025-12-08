# code to prepare `Derived_Annual_Stations` dataset
cat('Sourcing Derived_Annual_Stations.R', sep = '\n')
library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)
source('inst/extdata/read_physical.R')

# load biochemical data ----
## HL2 ----
cat('    reading in station2 biochemical data', sep = '\n')
HL2_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Halifax-2/Means&Anomalies_Annual.RData")
load(con, envir=HL2_env)
close(con)
# P5 ---
cat('    reading in prince5 biochemical data', sep = '\n')
P5_env <- new.env()
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/biochemical/Prince-5/Means&Anomalies_Annual.RData")
load(con, envir=P5_env)
close(con)
# initialize station metadata ----
stnMetadata <- NULL
# load physical data ----
cat('    reading in station2 and prince5 data', sep = '\n')
## all files ----
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/fixedStations/'
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))
## get relevant files ----
fn <- grep(filenames, pattern = '(?:station2|prince5).*(?:0to50|150m|90m)_en\\.dat', value = TRUE)
## read data ---
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}
## get nice variable name ----
### infer variable name from filename ----
dvarname <- unlist(lapply(d, function(k) gsub(pattern = '(?:station2|prince5)(.*)_en\\.dat', '\\1', k[['filename']])))
### remove 'm' from depth ----
dvarname <- gsub(pattern = '^(\\w+\\d+)(m)$', '\\1', dvarname)
### substitute 'to' with underscore for integrated vars ----
dvarname <- gsub(pattern = '(^\\w+\\d+)(to)(\\d+)$', '\\1_\\3', dvarname)
### make everything lower-case ----
dvarname <- tolower(dvarname)
### add underscore between variable name and depth value ----
dvarname <- gsub('^([a-z]+)((?:\\d+|\\d+\\_\\d+))', '\\1_\\2', dvarname)
### add underscore after 'integrated' ----
dvarname <- gsub('^(integrated)(.*)', '\\1_\\2', dvarname)
### reinstate 'sigmatheta' camel case ----
dvarname <- gsub('sigmatheta', 'sigmaTheta', dvarname)
## create data.frame in output format ----
polist <- vector(mode = 'list', length = length(d))
stnMetadataProd <- NULL
for(id in 1:length(d)){
  dd <- d[[id]]
  ddf <- data.frame(station = dd[['stationName']],
                    variable = dvarname[id],
                    year = dd[['data']][['year']],
                    value = as.numeric(dd[['data']][['anomaly']]) + as.numeric(dd[['climatologicalMean']]))
  stnMetaAdd <- data.frame(station = dd[['stationName']],
                           longitude = dd[['longitude']],
                           latitude = dd[['latitude']])
  polist[[id]] <- ddf
  stnMetadataProd <- rbind(stnMetadataProd,
                       stnMetaAdd)
}
## combine all PO data ----
podf <- do.call('rbind', polist)
## re-name Prince 5 to P5 ----
podf[['station']][podf[['station']] == 'Prince 5'] <- 'P5'
stnMetadataProd[['station']][stnMetadataProd[['station']] == 'Prince 5'] <- 'P5'
### only retain data for years >= 1999 ----
podf <- podf[podf[['year']] >= 1999, ]
### get unique station metadata and add to larger list ----
stnMetdataU <- unique(stnMetadataProd)
stnMetadata <- rbind(stnMetadata,
                     stnMetdataU)

# temperature_in_air ----
cat('    reading in air temperature data', sep = '\n')
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/airTemperature/'
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))
## get relevant files ----
fn <- grep(filenames, pattern = 'airTemperatureAnnualAnomaly\\w+\\.dat', value = TRUE)
## read in data ----
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}
## create data.frame in output format
vardat <- unlist(lapply(d, function(k) as.numeric(k[['data']][['anomaly']]) + as.numeric(k[['climatologicalMean']])))
stationName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))
df <- data.frame(year = year,
                 station = stationName,
                 temperature_in_air = vardat)
stnMetaAdd <- data.frame(station = unlist(lapply(d, '[[', 'stationName')),
                         longitude = unlist(lapply(d, function(k) as.numeric(strsplit(k[['longitude']], ',')[[1]][1]))),
                         latitude = unlist(lapply(d, function(k) as.numeric(strsplit(k[['latitude']], ',')[[1]][1]))))
### only retain data for years >= 1999 ----
airTemperature <- df %>%
  dplyr::filter(year>=1999)
### add station metadata to primary list ----
stnMetadata <- rbind(stnMetadata,
                     stnMetaAdd)

# sea_surface_temperature_from_moorings ----
cat('    reading in sst in-situ data', sep = '\n')
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/SSTinSitu/'
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))
## get relevant files ----
fn <- grep(filenames, pattern = 'SSTinSitu\\_\\w+\\.dat', value = TRUE)
## read in data ----
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}
## create data.frame in output format
vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
stationName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))
df <- data.frame(year = year,
                 station = stationName,
                 sea_surface_temperature_from_moorings = vardat)
stnMetaAdd <- data.frame(station = unlist(lapply(d, '[[', 'stationName')),
                         longitude = unlist(lapply(d, '[[', 'longitude')),
                         latitude = unlist(lapply(d, '[[', 'latitude')))
## re-name Halifax to Halifax_maritimeMuseum ----
df[['station']][df[['station']] == 'Halifax'] <- 'Halifax_maritimeMuseum'
stnMetaAdd[['station']][stnMetaAdd[['station']] == 'Halifax'] <- 'Halifax_maritimeMuseum'
### only retain data for years >= 1999 ----
SSTinSitu <- df %>%
  dplyr::filter(year>=1999)
### add station metadata to primary list ----
stnMetadata <- rbind(stnMetadata,
                     stnMetaAdd)

# assemble data ----
## combine biochemical data ----
Derived_Annual_Stations <- dplyr::bind_rows(HL2_env$df_means,
                                            P5_env$df_means)
### remove biochemical envs ----
rm(list=c("HL2_env", "P5_env"))
### add po data
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::bind_rows(., podf)
### define target variables to include ----
target_var <- c("Chlorophyll 0-100" = "integrated_chlorophyll_0_100",
                "Nitrate 0-50" = "integrated_nitrate_0_50",
                "Nitrate 50-150" = "integrated_nitrate_50_150",
                "Phosphate 0-50" = "integrated_phosphate_0_50",
                "Phosphate 50-150" = "integrated_phosphate_50_150",
                "Silicate 0-50" = "integrated_silicate_0_50",
                "Silicate 50-150" = "integrated_silicate_50_150")
potarget_var <- unique(podf[['variable']])
names(potarget_var) <- potarget_var
target_var <- c(target_var,
                potarget_var)
### define station print order ---
station_order <- c("HL2" = 1,
                   "P5" = 2)
### reformat data ----
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::filter(variable %in% names(target_var)) %>%
  dplyr::mutate(variable = unname(target_var[variable])) %>%
  tidyr::pivot_wider(names_from=variable, values_from=value) %>%
  dplyr::mutate(order_station = unname(station_order[station])) %>%
  dplyr::arrange(order_station, year) %>%
  dplyr::select(station, year, unname(target_var))

## add remaining physical data ----
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::bind_rows(., SSTinSitu, airTemperature)
## format metadata ----
stnMetadata <- dplyr::as_tibble(stnMetadata)
## add metadata ----
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::left_join(stnMetadata, by = 'station')

# save data to csv ----
readr::write_csv(Derived_Annual_Stations, "inst/extdata/csv/Derived_Annual_Stations.csv")

# save data to rda ----
usethis::use_data(Derived_Annual_Stations, overwrite = TRUE)
