# load libraries
library(dplyr)
library(readr)
library(tibble)
library(sf)

# load geometry data
df_geom <- readr::read_delim("~/Projects/azmpdata/tmp/BC/data/polygons/polygons_geometry_2.csv",
                             col_names=T, delim=",")

# load attributes data
df_attrib <- readr::read_delim("~/Projects/azmpdata/tmp/BC/data/polygons/polygons_attributes_2.csv",
                               col_names=T, delim=",")

# find records for points, lines, polygons
rec_pt <- dplyr::filter(df_attrib, grepl("station", type)) %>%
  .$record
rec_ln <- dplyr::filter(df_attrib, type=="section") %>%
  .$record
rec_pl <- dplyr::filter(df_attrib, !(record %in% c(rec_pt, rec_ln))) %>%
  .$record

# create sf object - points first, then lines, then polygons
sf <- dplyr::bind_rows(df_geom %>%
                         dplyr::filter(record %in% rec_pt) %>%
                         st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
                         group_by(record) %>%
                         summarise() %>%
                         st_cast("POINT"),
                       df_geom %>%
                         dplyr::filter(record %in% rec_ln) %>%
                         st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
                         group_by(record) %>%
                         summarise() %>%
                         st_cast("LINESTRING"),
                       df_geom %>%
                         dplyr::filter(record %in% rec_pl) %>%
                         st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
                         group_by(record) %>%
                         summarise() %>%
                         st_cast("POLYGON") %>%
                         st_convex_hull())  # check what that does

# add attributes to sf object
sf <- st_sf(df_attrib[sf$record, ], geometry=sf$geometry) %>%
  dplyr::arrange(record)

# save to RData
save(file="~/Projects/azmpdata/tmp/data/polygons/polygons.RData", sf)
