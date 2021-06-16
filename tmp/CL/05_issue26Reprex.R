rm(list=ls())
library(reprex)
reprex({
  library(azmpdata)
  data("Discrete_Occupations_Stations")
  library(oce)
  d <- Discrete_Occupations_Stations
  # example of using HL2 data from 2010 for a certain day
  okrow <- d[['station']] %in% 'HL2' & d[['year']] %in% 2010 & d[['month']] %in% 1 & d[['day']] %in% 6
  dd <- as.data.frame(d[okrow, ])
  dd
}, venue = 'gh')

