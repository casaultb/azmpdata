rm(list=ls())
library(azmpdata)
data("Discrete_Occupations_Stations")
library(oce)
d <- Discrete_Occupations_Stations
# example of using HL2 data from 2010 for a certain day
okrow <- d[['station']] %in% 'HL2' & d[['year']] %in% 2010 & d[['month']] %in% 1 & d[['day']] %in% 6

dd <- as.data.frame(d[okrow, ]) # still a tibble ?
dd
# When I went into the code to look at how the BO and PO data was joined, it was just a simple row bind
#   the fact that there are NA values in sea_temperature when there are say chlorophyll values seems funny
#   I thought everything was going to be joined together.
# Q : Will this cause any issues for analysis.
# Q : If you were a user, would you want everything matched up? Or would you attempt to match everything up for
#     more simple use ?

# If I was using this, I'd want to create an 'oce' CTD object. Mostly because that is just how I work with profile
# type data. So as a test, let's see how 'oce' would deal with it's current format, or if additional work is required.

# get 'other' data, i.e. non physical data into a list
okother <- names(dd) %in% c('chlorophyll', 'nitrate', 'phosphate', 'silicate')
other <- as.list(dd[,okother])

ctd <- as.ctd(salinity = dd[['salinity']],
              temperature = dd[['sea_temperature']],
              pressure = dd[['depth']],
              time = as.POSIXct(paste(dd[['year']], dd[['month']], dd[['day']], sep = '-'), tz = 'UTC'),
              latitude = dd[['latitude']],
              longitude = dd[['longitude']])
for(i in 1:length(other)){
  ctd <- oceSetData(ctd,
                    name = names(other)[i],
                    value = other[[i]])
}

# try plotting
plotProfile(ctd, xtype = 'temperature', type = 'b')
plotProfile(ctd, xtype = 'silicate', type = 'b') # NOTE ! it ASSUMES a unit. should we think about this ?
# together
plim <- rev(range(ctd[['pressure']]))
mar <- c(3.5, 3.5, 3.5, 1)
plotProfile(ctd, xtype = 'temperature', type = 'b', plim = plim, mar = mar)
par(new = TRUE)
plot(ctd[['silicate']], ctd[['pressure']], ylim = plim,
     ylab = '', yaxt = 'n',
     xlab = '',
     col = 'blue', col.axis = 'blue')
lines(ctd[['silicate']], ctd[['pressure']], ylim = plim, col = 'blue')
mtext(text = resizableLabel('silicate'), side = 1, line = 2, col = 'blue')


# pull out data from the ctd object
ctd[['temperature']]
ctd[['pressure']]

# I mean it's fine, but a little awkward.
