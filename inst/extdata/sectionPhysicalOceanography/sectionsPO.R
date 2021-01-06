dataPath <- 'inst/extdata/sectionPhysicalOceanography'
lookupPath <- 'inst/extdata/lookup'

# 1. read in mission look up tables and combine
lookupfiles <- list.files(lookupPath, pattern = '^mission.*', full.names = TRUE)
lookup <- lapply(lookupfiles, read.csv)
missions <- do.call('rbind', lookup)

# 2. read in the data and combine
datafile <- paste(dataPath, 'coreTransect.csv', sep = '/')
d <- read.csv(datafile)

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

sectionsPO <- d
# 4. save data
save(sectionsPO, file = 'data-raw/sectionsPO.rda')
write.csv(file.path(dataPath, 'sectionsPO.csv'), x = sectionsPO, row.names = FALSE)
