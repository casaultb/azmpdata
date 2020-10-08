library(usethis)
library(azmpdata)
path <- 'inst/extdata/airTemperature/'
files <- list.files(path = path,
                    pattern = 'airTemperatureAnnualAnomaly\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area_name = areaName,
                 temperature_in_air = vardat)
airTemperature <- df

usethis::use_data(airTemperature, compress = "xz", overwrite = T)
