# load libraries
library(sf)

# load data
load("~/Projects/azmpdata/tmp/data/polygons/SS.RData")
load("~/Projects/azmpdata/tmp/data/polygons/AZMP_Sections.RData")

# plot Petrie boxes and AZMP section stations
plot(st_geometry(sf_SS), col = sf.colors(12, categorical = TRUE), border = 'grey',
		 axes = TRUE)
plot(st_geometry(sf_AZMP_Sections), pch = 16, col = 'black', cex=0.75, add = TRUE)
