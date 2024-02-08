Standard_Depth_Lookup <- function(station, depth) {
  
  # assign standard sampling grid
  if(station=="HL2") {
    grid <- list(std_depth = c(0,5,10,20,30,40,50,75,100,140),
                    # surface = 0,
                    bottom = 175)
  } else if(station=="P5") {
    grid <- list(std_depth = c(0,10,25,50,95),
                    # surface = 0,
                    bottom = 115)
  } else if(station %in% c("CSL1", "CSL2", "CSL3", "CSL4", "CSL5", "CSL6",
                           "LL1", "LL2", "LL3", "LL4", "LL5", "LL6", "LL7", "LL8", "LL9",
                           "HL1", "HL3", "HL4", "HL5", "HL6", "HL7",
                           "BBL1", "BBL2", "BBL3", "BBL4", "BBL5", "BBL6", "BBL7")) {
    grid <- list(std_depth = c(0,10,20,30,40,50,60,80,100,250,500,1000,1500,2000,3000),
                    # surface = 0,
                    bottom = 3500)
  } else {
    return(NA)
  }
  
  # calculate breaks
  n <- length(grid$std_depth)
  dz <- diff(grid$std_depth)/2
  breaks <- c(grid$std_depth[1], grid$std_depth[1:n-1]+dz, grid$std_depth[n]+dz[n-1]) 
  breaks[n+1] <- grid$bottom
  
  # output - note: right=F open on right and closed on left
  return(grid$std_depth[cut(depth, breaks=breaks, labels=F, include.lowest=T, right=F)])
}
