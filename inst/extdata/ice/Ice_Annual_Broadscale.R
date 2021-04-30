## code to prepare `Ice_Annual_Broadscale` dataset

library(dplyr)
library(tidyr)
library(readr)
library(sp)
library(tibble)
library(usethis)

##--------------------------------------------------------------------------------------------
# ice volume data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/ice/volume/AZMP_CIL_ICE_NAO.dat")
df_volume <- read.table(file=con, sep="",
                            col.names=c("year", rep(NA,8), "gsl", "ss", rep(NA,5)),
                            colClasses=c("integer", rep("NULL",8), "numeric", "numeric", rep("NULL",5)),
                            comment.char="#", stringsAsFactors=F) %>%
  dplyr::filter(year>=1999) %>%
  dplyr::mutate(ice_volume = gsl+ss) %>%
  dplyr::select(-gsl, -ss)

##--------------------------------------------------------------------------------------------
# ice area data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/ice/area/IceAreaRegions.GEC.dat")
df_area <- read.table(file=con, sep="", flush=T,
                          col.names=c(NA, "date", "gsl", "ss", rep(NA, 2)),
                          colClasses=c("NULL", "character", rep("numeric", 2), rep("NULL", 2)),
                          comment.char="#", stringsAsFactors=F) %>%
  dplyr::filter(!(gsl==-99 & ss==-99)) %>%
  tidyr::separate(col="date", into=c("year", "month", "day"), sep="-", convert=T, remove=T) %>%
  dplyr::mutate(ice_area = gsl+ss) %>%
  dplyr::select(-day, -gsl, -ss) %>%
  dplyr::filter(month>=1 & month<=3) %>%
  dplyr::select(-month) %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(ice_area=mean(ice_area, na.rm=TRUE)) %>%
  dplyr::ungroup(.) %>%
  dplyr::filter(year>=1999)

##--------------------------------------------------------------------------------------------
# ice occurrence data
# load GSL+SS polygon coordinates
df_polygon <- read.table(file="./inst/extdata/ice/GSL_SS_Polygon.csv",
                         sep=",", col.names=c("lat","lon"), colClasses=rep("numeric", 2), skip=1)

# load data
df_occurrence_all <- data.frame()
for(i_year in seq(1999, 2020)){
  con <- url(paste("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/raw_data/ice/occurrence/", i_year, "/IceGridOccurrence.dat", sep=""))
  df_occurrence_all <- dplyr::bind_rows(df_occurrence_all,
                                        read.table(file=con, sep="",
                                                   col.names=c("lon","lat", "ice_first_day", NA, "ice_last_day", NA, "ice_duration"),
                                                   colClasses=c(rep("numeric", 3), "NULL", "numeric", "NULL", "numeric"),
                                                   comment.char="#", stringsAsFactors=F) %>%
                                          dplyr::mutate(year = i_year) %>%
                                          dplyr::mutate(lon = -lon))
}

# find data points within polygon
df_in_polygon <- df_occurrence_all %>%
  dplyr::select(lat, lon) %>%
  dplyr::distinct() %>%
  dplyr::filter(lon>=min(df_polygon$lon) & lon<=max(df_polygon$lon) &
                  lat>=min(df_polygon$lat) & lat<=max(df_polygon$lat)) %>%
  dplyr::mutate(in_poly = sp::point.in.polygon(lon, lat, df_polygon$lon, df_polygon$lat, mode.checked=FALSE)) %>%
  dplyr::filter(in_poly>0)

# filter main data frame for points within polygon
df_occurrence <- dplyr::left_join(df_occurrence_all,
                                  df_in_polygon,
                                  by=c("lat", "lon")) %>%
  dplyr::filter(!is.na(in_poly)) %>%
  dplyr::select(-in_poly)
rm(df_in_polygon)

# find individual grid points for which duration>0 in at least one year
# note: this is just an extra check because only grid point where ice is observed
#       are included in the original data files
target_loc <- df_occurrence %>%
  tidyr::unite(col=loc_id, lat, lon, sep="_", remove=FALSE) %>%
  dplyr::mutate(ice_flag = ice_duration>0) %>%
  dplyr::group_by(loc_id) %>%
  dplyr::summarize(n=sum(ice_flag)) %>%
  dplyr::ungroup() %>%
  dplyr::filter(n>0) %>%
  .$loc_id

# re-filter main data frame for grid points for which duration>0 in at least one year
df_occurrence <- df_occurrence %>%
  tidyr::unite(col=loc_id, lat, lon, sep="_", remove=FALSE) %>%
  dplyr::filter(loc_id %in% target_loc) %>%
  dplyr::select(-loc_id)
rm(target_loc)

# calculate annual means for each variable
df_occurrence <- df_occurrence %>%
  tidyr::pivot_longer(cols=c("ice_first_day", "ice_last_day", "ice_duration"),
                      names_to="variable", values_to="value") %>%
  dplyr::group_by(year, variable) %>%
  dplyr::summarise(value = mean(value, na.rm=T)) %>%
  dplyr::ungroup() %>%
  tidyr::pivot_wider(names_from="variable", values_from="value")

##--------------------------------------------------------------------------------------------
# assemble data
Ice_Annual_Broadscale <- dplyr::full_join(df_volume, df_area, by="year") %>%
  dplyr::left_join(., df_occurrence, by="year")

# save data to csv
readr::write_csv(Ice_Annual_Broadscale, "inst/extdata/csv/Ice_Annual_Broadscale.csv")

# save data to rda
usethis::use_data(Ice_Annual_Broadscale, overwrite = TRUE)
