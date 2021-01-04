library(usethis)
library(azmpdata)
path <- 'inst/extdata/areas/'
files <- list.files(path = path,
                    pattern = 'areasTemperatureAnnualAnomaly\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
#vardat1 <- unlist(lapply(d, function(k) k[['data']][['anomaly']]))
#vardat2 <- unlist(lapply(d, function(k) k[['data']][['normalizedAnomaly']]))

areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))

year <- unlist(lapply(d, function(k) k[['data']][['year']]))


df <- data.frame(year = year,
                 area = areaName,
                 temperature_at_sea_floor = vardat) # verify this is correct variable name
areasTemperature <- df

save(areasTemperature, file = 'data-raw/areasTemperature.rda')

# usethis::use_data(areasTemperature, compress = "xz", overwrite = T)

write.csv(file.path(path, 'areasTemperature.csv'), x = areasTemperature, row.names = FALSE)


# add other data

# find other files

allfiles <- list.files(path = path, pattern = '.dat', full.names = TRUE)
otherFiles <- allfiles[!allfiles %in% files]

d <- lapply(otherFiles, read.physical)

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

names(vardat)
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
areasOther <- df

save(areasOther, file = 'data-raw/areasOther.rda')

# usethis::use_data(areasOther, compress = "xz", overwrite = T)

write.csv(file.path(path, 'areaOther.csv'), x = areasOther, row.names = FALSE)

