# load libraries
library(dplyr)
library(readr)
library(tibble)
library(sf)

# load geometry data
df_geom <- readr::read_delim("~/Projects/azmpdata/tmp/data/polygons/AZMP_Sections_Coordinates.csv",
                             col_names=T, delim=",")

# load attributes data - id/names
df_attrib <- readr::read_delim("~/Projects/azmpdata/tmp/data/polygons/AZMP_Sections_Names.csv",
                               col_names=T, delim=",")

# create sf object
sf_AZMP_Sections <- df_geom %>%
	st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
	group_by(record) %>%
	summarise() %>%
	select(-record) %>%
	st_cast("POINT")

# save to RData
save(file="~/Projects/azmpdata/tmp/data/polygons/AZMP_Sections.RData", sf_AZMP_Sections)
