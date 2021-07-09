#' @title azmpmap
#' @description This generates a leaflet plot of the geospatial files stored at
#' ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/lookup/polygons/.
#' @examples \dontrun{
#' map <- azmpmap()
#' }
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @export

azmpmap <- function(){
  urlCsvExtract <- function(url=NULL){
    tryCatch(
      {
        utils::read.csv(text = RCurl::getURL(url, connecttimeout = 10))
      },
      error=function(cond){
        return(-1)
      }
    )
  }

  #create the data from the most recent values available
  regtab_att = urlCsvExtract('ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/lookup/polygons/polygons_attributes.csv')
  regtab_geo = urlCsvExtract('ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/lookup/polygons/polygons_geometry.csv')
  if (any(class(regtab_att) == "numeric"| class(regtab_geo) == "numeric")) stop("Could not download the necessary files.  Stopping.")
  AZMP <- merge(regtab_att, regtab_geo, all.x = T, by="record")
  #convert it to sf objects
  AZMP_sf = df2sf(input = AZMP, PID = "record", type.field = "type", ORD = "vertice", point.IDs = c("station"), poly.IDs = c("nafo","area", "section"))

  # get an inventory of all data that has been collected, and assocaite it with the various locations
  areaInventory <- area_indexer()
  areaInventory$year <- NULL
  areaInventory <- unique(areaInventory)
  assocData <- stats::aggregate(list(datafiles = areaInventory$dataframe), list(mergeName = areaInventory$areaname), paste, collapse="<br><dd>")
  assocData$datafiles <- paste0("<dd>", assocData$datafiles)
  assocData$mergeName <- toupper(assocData$mergeName)
  AZMP_sf$mergeName <- toupper(AZMP_sf$sname)

  AZMP_sf<- merge(AZMP_sf, assocData, all.x =T, by = "mergeName")
  #isolate the various NAFO-related data
  AZMP_NAFO <- AZMP_sf[AZMP_sf$type=="nafo",]
  NAFO_gen <- c("4V", "4W", "4X")
  NAFO_det <- c("4VN", "4VS", "4W", "4X")
  otherNAFO <-AZMP_NAFO[!AZMP_NAFO$sname %in% c(NAFO_gen,NAFO_det),]

  #isolate  the data that is of type = area, and group it
  AZMP_areas <- unique(AZMP_sf[AZMP_sf$type == "area",])
  GE <- c("E Georges Bank", "Georges Basin","Lurcher Shoal", "Misaine Bank","Emerald Basin","Misaine Bank")
  SS <- c("CSS", "ESS","WSS", "GB","Cabot Strait")
  SSB <-c("scotian_shelf_box")
  SSG <-c("scotian_shelf_grid")
  RS <- c("CS_remote_sensing","LS_remote_sensing")
  otherAreas <-AZMP_areas[!AZMP_areas$sname %in% c(GE,SS,SSB,SSG,RS),]

  #add a title
  titleHTML <- paste0("<div style='
  .leaflet-control.map-title {
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px;
    padding-right: 10px;
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 28px;'>azmp map</div>")

  m <- leaflet::leaflet()
  m <- leaflet::addTiles(m)

  m <- leaflet::addWMSTiles(map = m,
                            group = "Bathymetry",
                            baseUrl = "https://services.arcgisonline.com/arcgis/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}.png",
                            layers = "1", options = leaflet::WMSTileOptions(format = "image/png", transparent = T))
  m <- leaflet::addPolygons(map = m, data = AZMP_NAFO[AZMP_NAFO$sname %in% NAFO_gen,],
                            group= "NAFO (gen)", label =~lname,
                            color = 'grey',weight = 1.5,
                            fillColor = sf::sf.colors(12, categorical = TRUE),
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("NAFO (gen):", lname, "<br>Data Collected Here:<br>", datafiles))

  m <- leaflet::addPolygons(map = m, data = AZMP_NAFO[AZMP_NAFO$sname %in% NAFO_det,],
                            group= "NAFO (det)", label =~lname,
                            color = 'grey',weight = 1.5,
                            fillColor = sf::sf.colors(12, categorical = TRUE),
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("NAFO (det):", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% GE,],
                            group= "General Areas", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("General Areas:", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SS,],
                            group= "SS Areas", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Areas:", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SSB,],
                            group= "SS Box", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Box:", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SSG,],
                            group= "SS Grid", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Grid:", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% RS,],
                            group= "Remote Sensing", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("Remote Sensing:", lname, "<br>Data Collected Here:<br>", datafiles))
  if (nrow(otherAreas)>0){
    m <- leaflet::addPolygons(map = m, data = otherAreas,
                              group= "OtherAreas", label =~lname)
    overlayGroups <- c(overlayGroups,"OtherAreas")
  }
  if (nrow(otherNAFO)>0){
    m <- leaflet::addPolygons(map = m, data = otherNAFO,
                              group= "OtherNAFO", label =~lname)
    overlayGroups <- c(overlayGroups,"OtherNAFO")
  }
  m <- leaflet::addPolygons(map = m, data = AZMP_sf[AZMP_sf$type=="section",],
                            group= "Sections", label = ~sname,
                            color="red", weight = 1.5,
                            popup = ~paste0("Section:", lname, "<br>Data Collected Here:<br>", datafiles))
  m <- leaflet::addCircleMarkers(map = m, data = AZMP_sf[AZMP_sf$type=="station",],
                                 group= "Stations", label =~sname,
                                 color = "red",weight = 2, radius = 4,
                                 labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                                 options = leaflet::markerOptions(zIndexOffset = 99),
                                 popup = ~paste0("Station:", lname,"<br>Depth:", depth, "<br>Data Collected Here:<br>", datafiles))

  baseGroups <- c("Bathymetry","None")
  overlayGroups <- c("Stations",  "Sections", "NAFO (gen)","NAFO (det)","SS Box", "SS Grid", "SS Areas","General Areas","Remote Sensing")



  m <- leaflet::hideGroup(map=m, group = overlayGroups[!overlayGroups %in% c("Stations","Sections", "NAFO (gen)")])

  m <- leaflet::addLayersControl(map=m, baseGroups = baseGroups,
                                 overlayGroups = overlayGroups,
                                 position = "topleft",
                                 options = leaflet::layersControlOptions(collapsed = FALSE))
  m <- leaflet::addControl(map=m, html = titleHTML, position = "bottomleft")

  return(m)
}
