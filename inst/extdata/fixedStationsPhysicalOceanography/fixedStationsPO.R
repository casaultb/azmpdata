dataPath <- 'inst/extdata/fixedStationsPhysicalOceanography'
lookupPath <- 'inst/extdata/lookup'

# 1. read in mission look up tables and combine
lookupfiles <- list.files(lookupPath, pattern = '^mission.*', full.names = TRUE)
lookup <- lapply(lookupfiles, read.csv)
missions <- do.call('rbind', lookup)

# 2. read in the data and combine
datafile <- paste(dataPath, c('prince5.csv', 'station2.csv'), sep = '/')
d <- lapply(datafile, read.csv)
d <- do.call('rbind', d)

# 3. match up cruiseNumber and mission_number
# note : if anything goes sideways matching up idx, the structure of idx will change
#        so it could become a list instead of a vector
idx <- apply(d, 1, function(k) {ok <- which(missions[['mission_name']] == k[['cruiseNumber']]);
                                if(length(ok) > 1) {
                                  ok[1]
                                  } else if(length(ok) == 0){
                                    NA
                                  } else {
                                    ok
                                  }})

d <- cbind(d, descriptor = missions[['mission_descriptor']][idx])

fixedStationsPO <- d



# rename variables
fixedStationsPO <- fixedStationsPO %>%
  dplyr::rename(., sea_temperature = temperature) %>%
  dplyr::rename(., depth = pressure)

# 4. save data
save(fixedStationsPO, file = 'data-raw/fixedStationsPO.rda')
write.csv(file.path(dataPath, 'fixedStationsPO.csv'), x = fixedStationsPO, row.names = FALSE)
