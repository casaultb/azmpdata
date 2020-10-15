library(usethis)
library(azmpdata)
path <- 'inst/extdata/summerBottomTemperature'
files <- list.files(path = path,
                    pattern = 'bottomTemperatureAnomalyNafoZone\\w+\\.dat',
                    full.names = TRUE)
d <- lapply(files, read.physical)

tasf <- unlist(lapply(d, function(k) as.numeric(k[['data']][['anomaly']]) + as.numeric(k[['climatologicalMean']])))
areaName <- unlist(lapply(d, function(k) rep(k[['divisionName']], dim(k[['data']])[1])))
year <- unlist(lapply(d, function(k) k[['data']][['year']]))

df <- data.frame(year = year,
                 area_name = areaName,
                 temperature_at_sea_floor = tasf)
summerBottomTemperature <- df

save(summerBottomTemperature, file = 'data-raw/summerBottomTemperature.rda')
# usethis::use_data(summerBottomTemperature, compress = "xz", overwrite = T)

write.csv(file.path(path, 'summerBottomTemperature.csv'), x = summerBottomTemperature, row.names = FALSE)
