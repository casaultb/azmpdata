## code to prepare `Discrete_Occupations_Sections` dataset

library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)

# load data
con <- url("ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/outputs/DIS_MAR_AZMP_ChlNut.RData")
load(con)
close(con)

# load physical data
url_name <- "ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/physical/sections/"
result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))


# create dataframe list
d <- list()
for(i in 1:length(filenames)){
  con <- url(paste0(url_name, filenames[[i]]))

  d[[i]] <- read.csv(con)
}

# rename variables

posections <- do.call('rbind', d)

posections <- posections %>%
  dplyr::rename(., depth = pressure)

# clean up
# rm(list=setdiff(ls(), c("df_data_averaged_l", "df_sample_filtered")))

# target variables to include
target_var <- c("Chlorophyll_A" = "chlorophyll",
                "Nitrate" = "nitrate",
                "Phosphate" = "phosphate",
                "Silicate" = "silicate")

# print order
# section
print_order_section <- c("CSL" = 1,
                         "LL" = 2,
                         "HL" = 3,
                         "BBL" = 4)
# section
print_order_station <- c("CSL1" = 1, "CSL2" = 2, "CSL3" = 3, "CSL4" = 4, "CSL5" = 5, "CSL6" = 6,
                         "LL1" = 1, "LL2" = 2, "LL3" = 3, "LL4" = 4, "LL5" = 5, "LL6" = 6, "LL7" = 7, "LL8" = 8, "LL9" = 9,
                         "HL1" = 1, "HL2" = 2, "HL3" = 3, "HL4" = 4, "HL5" = 5, "HL6" = 6, "HL7" = 7,
                         "BBL1" = 1, "BBL2" = 2, "BBL3" = 3, "BBL4" = 4, "BBL5" = 5, "BBL6" = 6, "BBL7" = 7)
# season
print_order_season <- c("Spring" = 1,
                        "Fall" = 2)

# reformat data
Discrete_Occupations_Sections <- dplyr::left_join(df_data_averaged_l %>%
                                                    dplyr::select(., sample_id, parameter_name, data_value) %>%
                                                    dplyr::rename(., variable=parameter_name, value=data_value),
                                                  df_sample_filtered %>%
                                                    dplyr::select(., sample_id, event_id, year, month, day,
                                                                  time, latitude, longitude, start_depth, standard_depth, station,
                                                                  transect, season) %>%
                                                    dplyr::rename(depth=start_depth, section=transect),
                                                  by=c("sample_id")) %>%
  dplyr::mutate(., order_section = unname(print_order_section[section])) %>%
  dplyr::mutate(., order_station = unname(print_order_station[station])) %>%
  dplyr::mutate(., order_season = unname(print_order_season[season])) %>%
  dplyr::filter(., variable %in% names(target_var)) %>%
  dplyr::mutate(., variable = unname(target_var[variable])) %>%
  dplyr::group_by(., sample_id, variable) %>%
  dplyr::slice(., 1) %>%
  dplyr::ungroup(.) %>%
  tidyr::spread(., variable, value) %>%
  dplyr::group_by(., event_id) %>%
  dplyr::arrange(., depth, .by_group=T) %>%
  dplyr::arrange(., order_section, year, order_season, order_station) %>%
  dplyr::ungroup(.) %>%
  dplyr::select(., section, station, latitude, longitude, year, month, day, event_id,
                sample_id, depth, standard_depth, unname(target_var))

# to make it easier to use
b <- Discrete_Occupations_Sections
p <- posections

# get mission descriptor and names lookup table
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/lookup/'
result <- getURL(url_name,
                 verbose=TRUE,
                 ftp.use.epsv=TRUE,
                 dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))
filenamesfull <- paste0(url_name, filenames)
missions <- lapply(filenamesfull, read.csv)
lookup <- do.call('rbind', missions)

# first step is to match up the cruiseNumber to get the descriptor
pdescriptor <- lookup[['mission_descriptor']][match(p[['cruiseNumber']], lookup[['mission_name']])]
# add it to the physical dataframe
p <- cbind(p, missionDescriptor = pdescriptor)

# now split up event_id to get the descriptor
bdescriptor <- gsub('(\\w+)\\_\\w+', '\\1', b[['event_id']])
# add it to the biological dataframe
b <- cbind(b, missionDescriptor = bdescriptor)
b <- as.data.frame(b)

# now merge them together
bp <- merge(b, p,
            by.x = c('station', 'year', 'month', 'day', 'standard_depth', 'missionDescriptor'),
            by.y = c('station', 'year', 'month', 'day', 'depth', 'missionDescriptor'),
            all = TRUE)

# check, manual visual check, nothing serious or rigorus
stn <- 'LL8'
year <- 2019
month <- 4
day <- 22

bok <- b[['station']] == stn & b[['year']] == year & b[['month']] == month & b[['day']] == day
pok <- p[['station']] == stn & p[['year']] == year & p[['month']] == month & p[['day']] == day
bpok <- bp[['station']] == stn & bp[['year']] == year & bp[['month']] == month & bp[['day']] == day

bcheck <- b[bok, ]
pcheck <- p[pok, ]
bpcheck <- bp[bpok, ]

# # join physical data - 20210419 old way
# Discrete_Occupations_Sections <- Discrete_Occupations_Sections %>%
#   dplyr::bind_rows(posections)
#
# would need to uncomment below to save
# # save as dataframe not tibble
# Discrete_Occupations_Sections <- as.data.frame(Discrete_Occupations_Sections)
#
# # save data to csv
# readr::write_csv(Discrete_Occupations_Sections, "inst/extdata/csv/Discrete_Occupations_Sections.csv")
#
# # save data to rda
# usethis::use_data(Discrete_Occupations_Sections, overwrite = TRUE)
