library(usethis)
library(azmpdata)
path <- 'inst/extdata/areas//'
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
                 area_name = areaName,
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
checkyear <- identical(year[[1]], year[[2]], year[[3]])
if(checkyear == FALSE){
  stop('Data years vary between variables! Please code for this!')
}

# match variable names to official names

names(vardat)
official_names <- c('Density gradient' = 'density_gradient_0_50', 'Practical Salinity' = 'salinity', 'Temperature' = 'sea_temperature')

ofnm <- match(names(vardat), names(official_names))

names(vardat) <- official_names[ofnm]

# no are name? broadscale

df <- data.frame(year = year[[1]],
                 area_name = 'Scotion Shelf',
                 as.data.frame(vardat))
areasOther <- df

save(areasOther, file = 'data-raw/areasOther.rda')

# usethis::use_data(areasOther, compress = "xz", overwrite = T)

write.csv(file.path(path, 'areaOther.csv'), x = areasOther, row.names = FALSE)

