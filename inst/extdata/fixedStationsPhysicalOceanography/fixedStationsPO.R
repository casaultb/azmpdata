dataPath <- 'inst/extdata/fixedStationsPhysicalOceanography'
lookupPath <- 'inst/extdata/lookup'

# 1. read in mission look up tables and merge
lookupfiles <- list.files(lookupPath, pattern = '^mission.*', full.names = TRUE)
lookup <- lapply(lookupfiles, read.csv)
missions <- do.call('rbind', lookup)

# 2. read in the data
datafile <- paste(dataPath, 'prince5.csv', sep = '/')
d <- read.csv(datafile)

# 3. match up cruiseNumber and mission_number
idx <- apply(d, 1, function(k) which(missions[['mission_name']] == k[['cruiseNumber']]))

d <- cbind(d, descriptor = missions[['mission_descriptor']][idx])

fixedStationsPO <- d
# 4. save data
save(fixedStationsPO, file = 'data-raw/fixedStationsPO.rda')
write.csv(file.path(dataPath, 'fixedStationsPO.csv'), x = fixedStationsPO, row.names = FALSE)
