# derived_monthly station data
library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)

# sea_surface_height

url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/physical/seaLevelHeight/'

result <- getURL(url_name,
                 verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))


# get relevant files
fn <- grep(filenames, pattern = 'seaLevelHeight\\w+\\.dat', value = TRUE)

# create dataframe list
d <- list()
for(i in 1:length(fn)){
  con <- url(paste0(url_name, fn[[i]]))

  d[[i]] <- read.physical(con)
}

# path <- 'inst/extdata/seaLevelHeight/'
# files <- list.files(path = path,
#                     pattern = 'seaLevelHeight\\w+\\.dat',
#                     full.names = TRUE)
# d <- lapply(files, read.physical)

#vardat <- unlist(lapply(d, function(k) k[['data']][['anomaly']] + as.numeric(k[['climatologicalMean']])))
vardat1 <- unlist(lapply(d, function(k) k[['data']][['time']]))
vardat2 <- unlist(lapply(d, function(k) k[['data']][['elevation']]))
vardat3 <- unlist(lapply(d, function(k) k[['data']][['elevationResidual']]))

stationName <- unlist(lapply(d, function(k) rep(k[['stationName']], dim(k[['data']])[1])))

year <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%Y')))
month <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%m')))
day <- unlist(lapply(d, function(k) format(as.Date(k[['data']][['time']]), format = '%d')))

df <- data.frame(year = as.numeric(year),
                 month = as.numeric(month),
                 day = as.numeric(day),
                 station = stationName,
                 sea_surface_height  = vardat2 #,
                 # sea_surface_height_residual= vardat3
)
seaLevelHeight <- df %>%
  dplyr::select(-day)



# assemble data

Derived_Monthly_Stations <- dplyr::bind_rows(seaLevelHeight)


# save data


# save data to csv
readr::write_csv(Derived_Monthly_Stations, "inst/extdata/csv/Derived_Monthly_Stations.csv")

# save data to rda
usethis::use_data(Derived_Monthly_Stations, overwrite = TRUE)
