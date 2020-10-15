library(dplyr)
library(readr)
library(tibble)
library(sf)

# load geometry data
df_geom <- readr::read_delim("~/Projects/azmpdata/tmp/data/polygons/SS_coordinates.csv",
                             col_names=T, delim=",")

# load attributes data - id/names
df_attrib <- readr::read_delim("~/Projects/azmpdata/tmp/data/polygons/SS_names.csv",
                               col_names=T, delim=",")

# create sf object
sf_SS <- df_geom %>%
	st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
	group_by(record) %>%
	summarise() %>%
	select(-record) %>%
	st_cast("POLYGON") %>%
	st_convex_hull()  # check what that does

# save to RData
save(file="~/Projects/azmpdata/tmp/data/polygons/SS.RData", sf_SS)
