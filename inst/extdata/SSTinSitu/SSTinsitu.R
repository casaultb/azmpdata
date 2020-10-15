library(usethis)
library(azmpdata)
path <- 'inst/extdata/SSTinSitu//'
files <- list.files(path = path,
                    pattern = 'SSTinSitu\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
#vardat1 <- unlist(lapply(d, function(k) k[['data']][['anomaly']]))
#vardat2 <- unlist(lapply(d, function(k) k[['data']][['normalizedAnomaly']]))

stationName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))

year <- unlist(lapply(d, function(k) k[['data']][['year']]))


df <- data.frame(year = year,
                 station_name = stationName,
                 sea_surface_temperature_from_moorings = vardat)
SSTinSitu <- df

save(SSTinSitu, file = 'data-raw/SSTinSitu.rda')

# usethis::use_data(SSTinSitu, compress = "xz", overwrite = T)

write.csv(file.path(path, 'SSTinSitu.csv'), x = SSTinSitu, row.names = FALSE)

