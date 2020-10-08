library(usethis)
library(azmpdata)
path <- 'inst/extdata/seaLevelHeight//'
files <- list.files(path = path,
                    pattern = 'seaLevelHeight\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical) # broken

#vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
vardat1 <- unlist(lapply(d, function(k) k[['data']][['time']]))
vardat2 <- unlist(lapply(d, function(k) k[['data']][['elevation']]))
vardat3 <- unlist(lapply(d, function(k) k[['data']][['elevationResidual']]))

stationName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))

year <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%Y')))
month <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%m')))
day <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%d')))

df <- data.frame(year = year,
                 month = month,
                 day = day,
                 station_name = stationName,
                 sea_surface_height  = vardat2,
                 sea_surface_height_residual= vardat3)
seaLevelHeight <- df

usethis::use_data(seaLevelHeight, compress = "xz", overwrite = T)
