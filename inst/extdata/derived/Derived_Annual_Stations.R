## code to prepare `Derived_Annual_Stations` dataset
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
for(id in 1:length(d)){
  dd <- d[[id]]
  ddf <- data.frame(station = dd[['stationName']],
                    variable = dvarname[id],
                    year = dd[['data']][['year']],
                    value = as.numeric(dd[['data']][['anomaly']]) + as.numeric(dd[['climatologicalMean']]))
  polist[[id]] <- ddf
}
## combine all PO data ----
podf <- do.call('rbind', polist)
### only retain data for years >= 1999 ----
podf <- podf[podf[['year']] >= 1999, ]

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
### only retain data for years >= 1999 ----
airTemperature <- df %>%
  dplyr::filter(year>=1999)

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
### only retain data for years >= 1999 ----
SSTinSitu <- df %>%
  dplyr::filter(year>=1999)

# assemble data ----
## combine biochemical data ----
Derived_Annual_Stations <- dplyr::bind_rows(HL2_env$df_means,
                                            P5_env$df_means)
### remove biochemical envs ----
rm(list=c("HL2_env", "P5_env"))
### define target variables to include ----
target_var <- c("Chlorophyll 0-100" = "integrated_chlorophyll_0_100",
                "Nitrate 0-50" = "integrated_nitrate_0_50",
                "Nitrate 50-150" = "integrated_nitrate_50_150",
                "Phosphate 0-50" = "integrated_phosphate_0_50",
                "Phosphate 50-150" = "integrated_phosphate_50_150",
                "Silicate 0-50" = "integrated_silicate_0_50",
                "Silicate 50-150" = "integrated_silicate_50_150")
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

## add physical data ----
Derived_Annual_Stations <- Derived_Annual_Stations %>%
  dplyr::bind_rows(., podf, SSTinSitu, airTemperature)

# save data to csv ----
readr::write_csv(Derived_Annual_Stations, "inst/extdata/csv/Derived_Annual_Stations.csv")

# save data to rda ----
usethis::use_data(Derived_Annual_Stations, overwrite = TRUE)
