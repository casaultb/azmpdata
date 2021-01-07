## code to prepare `Derived_Annual_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)
# load data

# temperature_at_sea_floor
url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/physical/areas/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files
fn <- grep(filenames, pattern = 'areasTemperatureAnnualAnomaly\\w+\\.dat', value = TRUE)

# create dataframe list
d <- list()
for(i in 1:length(fn)){
con <- url(paste0(url_name, fn[[i]]))

d[[i]] <- read.physical(con)
}


# path <- 'inst/extdata/areas/'
# files <- list.files(path = path,
#                     pattern = 'areasTemperatureAnnualAnomaly\\w+\\.dat',
#                     full.names = TRUE)
# d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
#vardat1 <- unlist(lapply(d, function(k) k[['data']][['anomaly']]))
#vardat2 <- unlist(lapply(d, function(k) k[['data']][['normalizedAnomaly']]))

areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))

year <- unlist(lapply(d, function(k) k[['data']][['year']]))


df <- data.frame(year = year,
                 area = areaName,
                 temperature_at_sea_floor = vardat) # verify this is correct variable name
areasTemperature <- df

# density_gradient_0_50
# find other files

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
names(vardat) <- lapply(d, function(k) k[['variable']])

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

official_names <- c('Density gradient' = 'density_gradient_0_50', 'Practical Salinity' = 'salinity', 'Temperature' = 'sea_temperature')

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
df <- df %>% select(year, area, density_gradient_0_50)


areasOther <- df

# cold_intermediate_layer_volume & minimum_temperature_in_cold_intermediate_layer

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/physical/coldIntermediateLayer/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))

  d[[i]] <- read.physical(con)
}

# path <- 'inst/extdata/coldIntermediateLayer//'
# files <- list.files(path = path,
#                     pattern = 'coldIntermediateLayer\\w+\\.dat',
#                     full.names = TRUE)
# d <- lapply(files, read.physical)

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

url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/physical/summerBottomTemperature/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))

# get relevant files

# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))

  d[[i]] <- read.physical(con)
}
#
# path <- 'inst/extdata/summerBottomTemperature'
# files <- list.files(path = path,
#                     pattern = 'bottomTemperatureAnomalyNafoZone\\w+\\.dat',
#                     full.names = TRUE)
# d <- lapply(files, read.physical)

tasf <- unlist(lapply(d, function(k) as.numeric(k[['data']][['anomaly']]) + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['divisionName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 temperature_at_sea_floor = tasf)
summerBottomTemperature <- df

# assemble data

Derived_Annual_Broadscale <- dplyr::bind_rows(areasOther, areasTemperature, coldIntermediateLayer, summerBottomTemperature)


# save data


# save data to csv
readr::write_csv(Derived_Annual_Broadscale, "inst/extdata/csv/Derived_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(Derived_Annual_Broadscale, overwrite = TRUE)
