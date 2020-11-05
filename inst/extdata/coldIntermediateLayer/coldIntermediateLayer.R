library(usethis)
library(azmpdata)
path <- 'inst/extdata/coldIntermediateLayer//'
files <- list.files(path = path,
                    pattern = 'coldIntermediateLayer\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

#vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
vardat1 <- unlist(lapply(d, function(k) k[['data']][['volume']]))
vardat2 <- unlist(lapply(d, function(k) k[['data']][['minimumTemperature']]))
areaName <- unlist(lapply(d, function(k) rep(k[['areaName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area = areaName,
                 cold_intermediate_layer_volume = vardat1,
                 minimum_temperature_in_cold_intermediate_layer = vardat2)
coldIntermediateLayer <- df

save(coldIntermediateLayer, file = 'data-raw/coldIntermediateLayer.rda')

# usethis::use_data(coldIntermediateLayer, compress = "xz", overwrite = T)

write.csv(file.path(path, 'coldIntermediateLayer.csv'), x = coldIntermediateLayer, row.names = FALSE)
