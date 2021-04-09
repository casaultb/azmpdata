# Rough draft of a plan to check cruise identifiers in azmpdata in order to properly merge bioloigcal and physical data
# E. Chisholm
# January 2021
# slightly modified by C.Layton 20210418
library(stringr)
library(dplyr)
library(azmpdata)
library(RCurl)

# pull all mission descriptors out of Benoit's event ids

# get all data
dat <- data(package = 'azmpdata')

datnames <- dat[['results']][ , colnames(dat[['results']]) == 'Item']

biodesc <- list()
phydesc <- list()
for (i in 1:length(datnames)){
  datname <- datnames[i]
  df <- get(datname)
  # check for event_id column
  if('event_id' %in% names(df)){
    # pull event ids
    event_ids <- df$event_id
    splitids <- str_split(event_ids, pattern = '_')
    cruise_desc_list <- lapply(splitids, FUN = function(k){k[1]})
    biodesc[[i]] <- unique(unlist(cruise_desc_list))
    names(biodesc)[[i]] <- datname
  }
  # check for descriptor column
  if('descriptor' %in% names(df)){
    phydesc[[i]] <- unique(df$descriptor)
    names(phydesc)[[i]] <- datname
  }

}


# check that they all descriptor/ identifiers are in lookup table
url_name <- 'ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/AZMP_Reporting/lookup/'
result <- getURL(url_name,
                 verbose=TRUE,
                 ftp.use.epsv=TRUE,
                 dirlistonly = TRUE)

filenames <- unlist(strsplit(result, "\r\n"))
filenamesfull <- paste0(url_name, filenames)
missions <- lapply(filenamesfull, read.csv)
lookup <- do.call('rbind', missions)

# print the biological descriptors which are not in lookup
unname(unlist(biodesc))[!unlist(cds) %in% lookup$mission_descriptor]

# print the physical descriptors which are missing from lookup
unname(unlist(phydesc))[!unlist(phys_desc) %in% lookup$mission_descriptor]


# check that all existing descriptors match between phys and bio data
# note that the 'descriptor' field only exists in one dataframe currently (EC 29-01-2021)

for(i in 1:length(phydesc)){
  if(!is.null(phydesc[[i]])){
    # compare descriptor fields
    tf <- identical(phydesc[[i]], cds[[i]])
    # further investigate
    if(tf == FALSE){
      pd <- phydesc[[i]]
      bd <- biodesc[[i]]
      print(paste(names(phydesc)[[i]], ':'))
      print(paste('Physical descriptors missing from biological data: '))
      pd[!pd %in% bd]
      print(paste('Biological descriptors missing from physical data: '))
      bd[!bd %in% pd]

      # check actual data
      df <- get(names(phydesc)[[i]])

      # group data by year month day
      df_time <- df %>%
        dplyr::group_by(., year, month, day) %>%
        dplyr::mutate(bio_descriptor = str_extract(event_id, "[^_]+")) %>%
        dplyr::summarise(., bio_descriptor, descriptor) %>%
        dplyr::distinct(., ) %>%
        dplyr::mutate(., ymd = paste(year, month, day, sep = '-'))

      # if descriptors don't match
      ymd_list <- unique(df_time$ymd)
      for(ii in 1:length(ymd_list)){
        ymdd <- ymd_list[[ii]]
        bd <- str_sort(na.omit(unique(df_time$bio_descriptor[df_time$ymd == ymdd])))
        pd <- str_sort(na.omit(unique(df_time$descriptor[df_time$ymd == ymdd])))

        if(length(bd) == 0 | length(pd) == 0){
          # some cruise descirptors are missing

        }else{
          if(bd != pd){
          print(paste('Cruise descriptors do not match for', ymdd))
          print(paste('Bio: ', bd, '| Phys: ', pd))
          }
        }
      }

    }else{
      print(paste(names(phys_desc)[[i]], ', physical and biological descriptors match!'))
    }
  }
}

# loop for all dataframes which you want to combine
# try to collapse dataframe just based on year month day

df_c <- df %>%
  dplyr::mutate(., descriptor2 =  str_extract(event_id, "[^_]+")) %>%
  tidyr::unite(., 'descriptor', c(descriptor, descriptor2), na.rm = TRUE)

# check that no descriptors got pasted together

desc <- df_c$descriptor
any(nchar(desc) >9)


# split phys and bio data

df_p <- df_c %>% select(., station, latitude, longitude, year, month, day, depth, cruiseNumber, descriptor, sea_temperature, salinity, sigmaTheta)

df_b <- df_c %>% select(., station, latitude, longitude, year, month, day, depth, nominal_depth, chlorophyll, nitrate, phosphate, silicate, descriptor)

# remove NA rows
# double check that no rows are lost!!
df_p <- df_p %>% dplyr::filter(., !is.na(rowSums(df_p[,10:12])))
df_b <- df_b %>% dplyr::filter(., !is.na(rowSums(df_b[,9:12])))


# combine phys and bio

df2 <- full_join(df_p, df_b, by = c('year', 'month', 'day', 'descriptor', 'depth', 'station'))


# TODO:
# leaves a dataframe with lat/lon x and y, where there are slight differences between lat and lon roundings/ sigfigs from each dataframe
# fix lat and lon matches with fuzzy matching or adjust rounding to make values equal, then join by value
# alternatively, choose to remove the lat/lon with lower sigfigs, after doing some checking to ensure the two column sets are relatively equal


