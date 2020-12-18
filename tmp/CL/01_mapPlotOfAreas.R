rm(list=ls())
library(azmpdata)
library(oce)
library(ocedata)
data("coastlineWorldFine")
datadir <- 'inst/extdata'

# all the dirs that have my .dat files that can
# be read in using read.physical
podirs <- c('airTemperature',
            'coldIntermediateLayer',
            'areas',
            'seaLevelHeight',
            'SSTinSitu',
            'summerBottomTemperature')

files <- lapply(podirs, function(k) list.files(path = paste(datadir, k, sep = '/'),
                                               pattern = '.*\\.dat$',
                                               full.names = TRUE))
d <- lapply(files, function(k) lapply(k, read.physical))

proj <- '+proj=merc'
fillcol <- 'lightgray'
lonlim <- c(-70, -56)
latlim <- c(40, 48)
for (i in 1:length(d)){
  par(mar = c(3.5, 3.5, 2, 1))
  mapPlot(coastlineWorldFine,
          longitudelim = lonlim,
          latitudelim = latlim,
          col = fillcol,
          proj = proj,
          grid = c(2,1))
  mtext(text = podirs[i], side = 3)
  dd <- d[[i]]
  for (j in 1:length(dd)){
    dstn <- dd[[j]]
    okName <- grep('.*Name$', names(dstn))
    okLon <- grep('ongitude$', names(dstn))
    okLat <- grep('atitude$', names(dstn))
    name <- dstn[[okName]]
    longitude <- as.numeric(strsplit(dstn[[okLon]], ',')[[1]])
    latitude <- as.numeric(strsplit(dstn[[okLat]], ',')[[1]])
    # if the length of coord greater than 3, use polygon, if not use points
    if(length(longitude) >= 3){
      mapPolygon(longitude, latitude, border = j)
      mapText(mean(longitude), mean(latitude), labels = name)
    } else {
      mapPoints(longitude, latitude, col = j, pch = 20, cex = 1.4)
      mapText(longitude, latitude, labels = name)
    }

  }
}
