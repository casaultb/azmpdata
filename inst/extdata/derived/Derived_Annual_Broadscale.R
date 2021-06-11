## code to prepare `Derived_Annual_Broadscale` dataset
cat('Sourcing Derived_Annual_Broadscale.R', sep = '\n')
library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)
source('inst/extdata/read_physical.R')

# load data

# sea_surface_temperature_from_satellite
cat('    reading in satellite SST data', sep = '\n')
url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/SSTsatellite/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.physical(con)
}

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['regionName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 sea_surface_temperature_from_satellite = vardat) # verify this is correct variable name
sstSatellite <- df

# north_atlantic_oscillation
cat('    reading in nao data', sep = '\n')

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/nao/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.physical(con)
}

vardat <- unlist(lapply(d, function(k) k[['data']][['nao']] + as.numeric(k[['climatologicalMean']])))
areaName <- NA
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 north_atlantic_oscillation = vardat) # verify this is correct variable name
nao <- df

# temperature_at_sea_floor
cat('    reading in areas bottom temperature data', sep = '\n')
url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/areas/"
result <- getURL(url_name,
                 verbose = TRUE, ftp.use.epsv = TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files
fn <- grep(filenames, pattern = 'areasTemperatureAnnualAnomaly\\w+\\.dat', value = TRUE)

# create dataframe list
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))
  d[[i]] <- read.physical(con)
}

vardat <- unlist(lapply(d, function(k) k[['data']][['temperatureAnomaly']] + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 temperature_at_sea_floor = vardat) # verify this is correct variable name
areasTemperature <- df

# density_gradient_0_50
cat('    reading in areas data, density gradient', sep = '\n')
# find other files
cat('    reading in areas data', sep = '\n')


otherFiles <- filenames[!filenames %in% fn]

d <- list()
for(i in 1:length(otherFiles)){
  con <- url(paste0(url_name, otherFiles[[i]]))
  d[[i]] <- read.physical(con)
}

# allfiles <- list.files(path = path, pattern = '.dat', full.names = TRUE)
# otherFiles <- allfiles[!allfiles %in% files]
#d <- lapply(otherFiles, read.physical)

# read in individual variables

vardat <- lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']]))
variableName <- unlist(lapply(d, function(k) k[['variable']]))
variableName <- gsub('\\s', '', variableName) # remove any space in variable name
variableDepth <- unlist(lapply(d, function(k) ifelse('depth' %in% names(k), k[['depth']], " ")))
variableDepth <- gsub('NA', "", variableDepth)
names(vardat) <- paste0(variableName, variableDepth)
year <- lapply(d, function(k) k[['data']][['year']])

# check that years are all the same
#checkyear <- identical(year[[1]], year[[2]], year[[3]])
# reduce breaking code by using sapply, assuming year[[1]]
# is our 'gold standard'
checkyear <- all(sapply(year[2:length(year)], identical, year[[1]]))
if(!checkyear){
  stop('Data years vary between variables! Please code for this!')
}

# check that all areaNames are the same
areaNames <- lapply(d, function(k) k[['areaName']])
checkAreaName <- all(sapply(areaNames[2:length(areaNames)], identical, areaNames[[1]]))
if(!checkAreaName){
  stop('The area name between files does not match.')
}

# match variable names to official names

official_names <- c('Densitygradient' = 'density_gradient_0_50',
                    'PracticalSalinity0m' = 'salinity_0',
                    'PracticalSalinity50m' = 'salinity_50',
                    'salinityGradient' = 'salinity_gradient_0_50',
                    'Temperature0m' = 'sea_temperature_0',
                    'Temperature50m' = 'sea_temperature_50',
                    'SigmaTheta0m' = 'sigmaTheta_0',
                    'SigmaTheta50m' = 'sigmaTheta_50')
ofnm <- match(names(vardat), names(official_names))
names(vardat) <- official_names[ofnm]

# update spatial name to differentiate between definitions of scotian shelf
areaNames <- gsub(x = areaNames, pattern = 'Scotian Shelf', replacement = 'scotian_shelf_box')

# since we've passted the checkyear and checkAreaName above
#   we'll use the area name and year from the first file
df <- data.frame(year = year[[1]],
                 area = unique(areaNames),
                 as.data.frame(vardat))

# keep only density gradient var
df <- df %>% select(year, area, density_gradient_0_50, sea_temperature_0, salinity_0)
areasOther <- df

# cold_intermediate_layer_volume & minimum_temperature_in_cold_intermediate_layer
cat('    reading in cold intermediate layer data', sep = '\n')

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/coldIntermediateLayer/"
result <- getURL(url_name,
                 verbose = TRUE, ftp.use.epsv = TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.physical(con)
}

#vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
vardat1 <- unlist(lapply(d, function(k) k[['data']][['volume']]))
vardat2 <- unlist(lapply(d, function(k) k[['data']][['minimumTemperature']]))
areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

# update spatial name to differentiate between definitions of scotian shelf
areaName <- gsub(x = areaName, pattern = 'Scotian Shelf', replacement = 'scotian_shelf_grid')
df <- data.frame(year = year,
                 area = areaName,
                 cold_intermediate_layer_volume = vardat1,
                 minimum_temperature_in_cold_intermediate_layer = vardat2)
coldIntermediateLayer <- df

# temperature_at_sea_floor
cat('    reading in summer bottom temperature data', sep = '\n')

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/physical/summerBottomTemperature/"
result <- getURL(url_name,
                 verbose = TRUE, ftp.use.epsv = TRUE, dirlistonly = TRUE)
filenames <- unlist(strsplit(result, "\r\n"))

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))
  d[[i]] <- read.physical(con)
}

tasf <- unlist(lapply(d, function(k) as.numeric(k[['data']][['anomaly']]) + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['divisionName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 temperature_at_sea_floor = tasf)
summerBottomTemperature <- df

# assemble data

Derived_Annual_Broadscale <- dplyr::bind_rows(areasOther, areasTemperature,
                                              coldIntermediateLayer, summerBottomTemperature,
                                              nao, sstSatellite)


# save data

# save data to csv
readr::write_csv(Derived_Annual_Broadscale, "inst/extdata/csv/Derived_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(Derived_Annual_Broadscale, overwrite = TRUE)
