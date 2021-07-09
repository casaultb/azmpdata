#' @title df2sf
#' @description This function will convert a df into an sf objects.
#' @param input a df contain coordinates for conversion to sf.
#' @param lat.field the default is \code{"latitude"}. This is the name of the field holding latitude
#' values (in decimal degrees)
#' @param lon.field the default is \code{"longitude"}.  This is the name of the field holding
#' longitude values (in decimal degrees)
#' @param PID the default is \code{"PID"}.  This is a field that uniquely identifies discrete
#' points, lines, or polygons.
#' @param ORD the default is \code{NULL}.  This is not used if \code{out} is "points".  This is the
#' name of a field holding the order in which the provided coordinates should be joined (in lines or
#' polygons).  If nothing is provided, it will be assumed that the data has been provided in the
#' correct order.
#' @param epsg the default is \code{4326}.  This is the coordinate system associated with the input
#' positions, and it assumes WGS84 (i.e. collected via a GPS).
#' @param type.field the default is \code{NULL}. This is a field within the data that contains
#' information about whether each record is a point, line, or polygon.
#' @param point.IDs the default is \code{NULL}. This is a vector of values from within
#' \code{type.field} that can be used to recognize the point objects (e.g. "station").
#' @param line.IDs the default is \code{NULL}. This is a vector of values from within
#' \code{type.field} that can be used to recognize the line objects.
#' @param poly.IDs the default is \code{NULL}. This is a vector of values from within
#' \code{type.field} that can be used to recognize the polygon objects.
#' @param quiet default is \code{F}.  If 1 PID is found to have multiple positions, by default, a
#' message is displayed, and information about the points is shown.  If this is set to T, no message
#' or information is shown.
#' @return an sf object
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @note This is a duplicate of what exists in https://github.com/Maritimes/Mar.utils/blob/master/R/df2sf.R.
#' It is copied, rather than added as a dependency to reduce the number of packages necessary.
#' @export
df2sf <- function(input = NULL, lat.field="latitude", lon.field="longitude",
                  PID=NULL, ORD=NULL, epsg=4326,
                  type.field = NULL,
                  point.IDs = NULL,
                  line.IDs = NULL,
                  poly.IDs =NULL,
                  quiet = F

){
  # count how many positions exist for each PID, and merge that info onto the data
  ptCount <- stats::aggregate(
    x = list(npoints = input[,PID]),
    by = list(PID = input[,PID]),
    length
  )
  input <- merge(input, ptCount, by.x = PID, by.y = "PID")
  rm(ptCount)

  thePoints <- input[input[,type.field] %in% point.IDs,]
  badPoints <- thePoints[thePoints$npoints > 1,]
  if (nrow(badPoints)>0){
    if (!quiet) {
      message("\nThe following 'points' each had more than one position for the provided value of ", PID,":\n")
      print(thePoints[thePoints[,PID] %in% badPoints[,PID],!names(thePoints) %in% "npoints"])
      message("\nOnly the first from each duplicate groups was retained, and converted")
    }
    thePoints <- thePoints[!thePoints[,PID] %in% badPoints[,PID],]
    fixedPoints <- badPoints[ !duplicated(badPoints[, c(PID)], fromLast=F),]
    thePoints <- rbind(thePoints, fixedPoints)
    rm(fixedPoints)
  }
  rm(badPoints)

  theLines <- input[input[,type.field] %in% line.IDs,]
  badLines <- theLines[theLines$npoints < 2,]
  if (nrow(badLines)>0){
    message("\nThe following 'lines' each had less than 2 positions, and were ignored:\n")
    print(theLines[theLines[,PID] %in% badLines[,PID],!names(theLines) %in% "npoints"])
    theLines <- theLines[!theLines[,PID] %in% badLines[,PID],]
  }
  rm(badLines)

  if(!is.null(ORD)) theLines = theLines[with(theLines, order(get(PID),get(ORD))), ]


  thePolysO <- input[input[,type.field] %in% poly.IDs,]
  thePolys <- thePolysO[FALSE,]
  # check each poly and ensure that last coord is same as first, if not, add it
  allPolys = unique(thePolysO[,PID])
  for (p in 1:length(allPolys)){
    thisPoly = thePolysO[thePolysO[PID] == allPolys[p],]
    if(!is.null(ORD)) thisPoly = thisPoly[with(thisPoly, order(get(ORD))), ]
    if (!all(thisPoly[1,c(PID, lat.field, lon.field)]==thisPoly[nrow(thisPoly),c(PID, lat.field, lon.field)])){
      thisPoly <- rbind.data.frame(thisPoly, thisPoly[1,])
      if(!is.null(ORD)) thisPoly[nrow(thisPoly),ORD] <- max(thisPoly[,ORD])+1
    }
    thisPoly$npoints <- nrow(thisPoly)
    thePolys <- rbind.data.frame(thePolys, thisPoly)
    rm(thisPoly)
  }
  rm(list=c("thePolysO", "p"))
  badPolys <- thePolys[thePolys$npoints < 4,]
  if (nrow(badPolys)>0){
    message("\nThe following 'polys' each had less than 3 unique positions, and were ignored:\n")
    print(thePolys[thePolys[,PID] %in% badPolys[,PID],!names(thePolys) %in% "npoints"])
    thePolys <- thePolys[!thePolys[,PID] %in% badPolys[,PID],]
  }
  rm(list=c("badPolys","input"))

  if(nrow(thePoints)>0){
    thePointsSf <- sfheaders::sf_point(
      obj = thePoints
      , x = lon.field
      , y = lat.field
      , keep = T
    )
  }else{
    thePointsSf<- thePoints
    thePointsSf[,lat.field] <- thePointsSf[,lon.field] <- NULL
    thePointsSf$geometry <- character()
  }
  if(nrow(theLines)>0){
    theLinesSf <- sfheaders::sf_linestring(
      obj = theLines
      , x = lon.field
      , y = lat.field
      , linestring_id = PID,
      keep = T
    )
  }else{
    theLinesSf<- theLines
    theLinesSf[,lat.field] <- theLinesSf[,lon.field] <- NULL
    theLinesSf$geometry <- character()
  }
  if(nrow(thePolys)>0){
    thePolysSf <- sfheaders::sf_polygon(
      obj = thePolys
      , x = lon.field
      , y = lat.field
      , polygon_id = PID
      , keep = T
    )
  }else{
    thePolysSf<- thePolys
    thePolysSf[,lat.field] <- thePolysSf[,lon.field] <- NULL
    thePolysSf$geometry <- character()
  }
  res <- rbind.data.frame(thePointsSf, theLinesSf, thePolysSf)
  res$npoints <- NULL
  return(res)
}
