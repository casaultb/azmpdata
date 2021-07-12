#' @title azmpmap
#' @description This generates a leaflet plot of the geospatial files stored at
#' ftp://ftp.dfo-mpo.gc.ca/AZMP_Maritimes/azmpdata/data/lookup/polygons/.
#' @param quiet default is \code{T} This indicates whether or not you want to see messages related
#' to the transformation of data from the ftp site to spatial objects.
#' @examples \dontrun{
#' map <- azmpmap()
#' }
#' @author  Mike McMahon, \email{Mike.McMahon@@dfo-mpo.gc.ca}
#' @export

azmpmap <- function(quiet=T){
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

  #drop rows that show up in attributes that are complete duplicates (ignoring 'record' field)
  regtab_att <- regtab_att[!duplicated(regtab_att[!names(regtab_att) %in% c("record")]), ]

  AZMP <- merge(regtab_att, regtab_geo, all.x = T, by="record")

  #convert it to sf objects
  AZMP_sf = df2sf(input = AZMP, PID = "record", type.field = "type", ORD = "vertice", point.IDs = c("station"), poly.IDs = c("nafo","area", "section"), quiet=quiet)

  # get an inventory of all data that has been collected, and associate it with the various locations
  areaInventory <- area_indexer(doParameters = T)

  assocData_year<- unique(areaInventory[,c("areaType", "areaname","year")])
  assocData_data<- unique(areaInventory[,c("areaType", "areaname","dataframe")])
  assocData_params<- unique(areaInventory[,c("areaType", "areaname","parameter")])

  all_datafiles_Names <- toupper(c(unique(assocData_year$areaname),unique(assocData_data$areaname),unique(assocData_params$areaname)))
  all_AZMP_sf_Names<- toupper(unique(AZMP_sf$sname))
  if(!quiet){
    diff1 <- setdiff(all_datafiles_Names, all_AZMP_sf_Names)
    diff1 <- diff1[!is.na(diff1)]
    diff2 <- setdiff(all_AZMP_sf_Names, all_datafiles_Names)
    diff2 <- diff2[!is.na(diff2)]

    if (length(diff1)>0)message("\nThese named areas from azmp package data files can't be associated with data in the ftp spatial objects.\n\t", paste(diff1, collapse=", "))
    if (length(diff2)>0)message("\nThese named areas from the ftp spatial objects can't be associated with data in the azmp package data files.\n\t", paste(diff2, collapse=", "))
  }

  # this is just for a map, so I don't think we need to list ALL variants of every parameter - drop
  #these bits so we get a nicer list:
  assocData_params$parameter <- gsub("_0_100", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_0_50", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_50_150", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_log10", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_abundance", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_dry_weight", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_wet_weight", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("integrated_", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_90", "", assocData_params$parameter, ignore.case = T)
  assocData_params$parameter <- gsub("_0", "", assocData_params$parameter, ignore.case = T)
  assocData_params <- unique(assocData_params)
  assocData_params <- assocData_params[with(assocData_params, order(parameter)), ]


  assocData_year <- assocData_year[with(assocData_year, order(year)), ]
  assocData_year <- stats::aggregate(list(years = assocData_year$year), list(mergeName = assocData_year$areaname), paste, collapse=", ")

  assocData_data <- stats::aggregate(list(datafiles = assocData_data$dataframe), list(mergeName = assocData_data$areaname), paste, collapse="</dd><dd>")
  assocData_params <- stats::aggregate(list(parameters = assocData_params$parameter), list(mergeName = assocData_params$areaname), paste, collapse="</dd><dd>")
  assocData_data$datafiles <- paste0("<dd>", assocData_data$datafiles,"</dd>")
  assocData_params$parameters <- paste0("<dd>", assocData_params$parameters,"</dd>")

  assocData_year$years <- paste0("<dd>", assocData_year$years,"</dd>")

  assocData_year$mergeName <- toupper(assocData_year$mergeName)
  assocData_data$mergeName <- toupper(assocData_data$mergeName)
  assocData_params$mergeName <- toupper(assocData_params$mergeName)
  AZMP_sf$mergeName <- toupper(AZMP_sf$sname)

  AZMP_sf<- merge(AZMP_sf, assocData_data, all.x =T, by = "mergeName")
  AZMP_sf<- merge(AZMP_sf, assocData_params, all.x =T, by = "mergeName")
  AZMP_sf<- merge(AZMP_sf, assocData_year, all.x =T, by = "mergeName")

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

  #grab the Zooplankton_Occupations_Broadscale data, which will otherwise not be visible (corrds, but no stations)
  Zoo_Occ_Broad <- Zooplankton_Occupations_Broadscale <- latitude<- longitude <- sample_id <-NA
  delayedAssign("Zoo_Occ_Broad", Zooplankton_Occupations_Broadscale)
  Zoo_Occ_Broad$month <- Zoo_Occ_Broad$day <- Zoo_Occ_Broad$season <- NULL
  Zoo_Occ_Broad <- tidyr::gather(Zoo_Occ_Broad, "param", "value", -latitude, -longitude, -year, -sample_id)
  Zoo_Occ_Broad <- Zoo_Occ_Broad[!is.na(Zoo_Occ_Broad$value),]
  Zoo_Occ_Broad$value <- NULL

  Zoo_Occ_Broad_master <- unique(Zoo_Occ_Broad[, c("latitude", "longitude", "sample_id")])
  Zoo_Occ_Broad_params <- unique(Zoo_Occ_Broad[, c("latitude", "longitude", "sample_id", "param")])
  Zoo_Occ_Broad_years <- unique(Zoo_Occ_Broad[, c("latitude", "longitude", "sample_id", "year")])
  Zoo_Occ_Broad_params <- stats::aggregate(list(parameters = Zoo_Occ_Broad_params$param), list(sample_id = Zoo_Occ_Broad_params$sample_id, latitude = Zoo_Occ_Broad_params$latitude, longitude = Zoo_Occ_Broad_params$longitude), paste, collapse="</dd><dd>")
  Zoo_Occ_Broad_years <- stats::aggregate(list(years = Zoo_Occ_Broad_years$year), list(sample_id = Zoo_Occ_Broad_years$sample_id, latitude = Zoo_Occ_Broad_years$latitude, longitude = Zoo_Occ_Broad_years$longitude), paste, collapse="</dd><dd>")

  Zoo_Occ_Broad <- merge(Zoo_Occ_Broad_master, Zoo_Occ_Broad_years, all.x=T)
  Zoo_Occ_Broad <- merge(Zoo_Occ_Broad, Zoo_Occ_Broad_params, all.x=T)
  Zoo_Occ_Broad$years <- paste0("<dd>", Zoo_Occ_Broad$years,"</dd>")
  Zoo_Occ_Broad$parameters <- paste0("<dd>", Zoo_Occ_Broad$parameters,"</dd>")

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
                            popup = ~paste0("NAFO (gen):", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))

  m <- leaflet::addPolygons(map = m, data = AZMP_NAFO[AZMP_NAFO$sname %in% NAFO_det,],
                            group= "NAFO (det)", label =~lname,
                            color = 'grey',weight = 1.5,
                            fillColor = sf::sf.colors(12, categorical = TRUE),
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("NAFO (det):", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% GE,],
                            group= "General Areas", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("General Areas:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SS,],
                            group= "SS Areas", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Areas:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SSB,],
                            group= "SS Box", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Box:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% SSG,],
                            group= "SS Grid", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("SS Grid:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addPolygons(map = m, data = AZMP_areas[AZMP_areas$sname %in% RS,],
                            group= "Remote Sensing", label =~lname,
                            labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                            popup = ~paste0("Remote Sensing:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  if (nrow(otherAreas)>0){
    m <- leaflet::addPolygons(map = m, data = otherAreas,
                              group= "OtherAreas", label =~lname,
                              color="red", weight = 1.5,
                              popup = ~paste0("Section:", lname," (",sname,")<br>",
                                              "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                              "<br>Year(s) Data Collected here:<br>", years,
                                              "<br>Parameter(s) collected here:<br>",parameters))
    overlayGroups <- c(overlayGroups,"OtherAreas")
  }
  if (nrow(otherNAFO)>0){
    m <- leaflet::addPolygons(map = m, data = otherNAFO,
                              group= "OtherNAFO", label =~lname,
                              color="red", weight = 1.5,
                              popup = ~paste0("Section:", lname," (",sname,")<br>",
                                              "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                              "<br>Year(s) Data Collected here:<br>", years,
                                              "<br>Parameter(s) collected here:<br>",parameters))
    overlayGroups <- c(overlayGroups,"OtherNAFO")
  }
  m <- leaflet::addPolygons(map = m, data = AZMP_sf[AZMP_sf$type=="section",],
                            group= "Sections", label = ~sname,
                            color="red", weight = 1.5,
                            popup = ~paste0("Section:", lname," (",sname,")<br>",
                                            "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                            "<br>Year(s) Data Collected here:<br>", years,
                                            "<br>Parameter(s) collected here:<br>",parameters))
  m <- leaflet::addCircleMarkers(map = m, data = AZMP_sf[AZMP_sf$type=="station",],
                                 group= "Stations", label =~sname,
                                 color = "red",weight = 2, radius = 4,
                                 labelOptions = leaflet::labelOptions(noHide = T, textOnly = TRUE),
                                 options = leaflet::markerOptions(zIndexOffset = 99),
                                 popup = ~paste0("Station:", lname," (",sname,")<br><br>Depth:", ifelse(is.numeric(depth),paste0(depth," m"), NA),"<br>",
                                                 "<br>Relevant AZMP datafile(s):<br>", datafiles,
                                                 "<br>Year(s) Data Collected here:<br>", years,
                                                 "<br>Parameter(s) collected here:<br>",parameters))

  m <- leaflet::addCircleMarkers(map = m, data = Zoo_Occ_Broad,lng = ~longitude, lat = ~latitude,
                                 group= "Zooplank (Broad. Occ.)",
                                 color = "blue",weight = 1, radius = 2,
                                 options = leaflet::markerOptions(zIndexOffset = 95),
                                 popup = ~paste0(latitude,"N, ", longitude, "W",
                                                 "<br> (Sample ID:", sample_id,")<br>",
                                                 "<br>Relevant AZMP datafile(s):<br><dd>Zooplankton_Occupations_Broadscale</dd>",
                                                 "<br>Year(s) Data Collected here:<br>", years,
                                                 "<br>Parameter(s) collected here:<br>",parameters))

  baseGroups <- c("Bathymetry","None")
  overlayGroups <- c("Stations",  "Sections", "NAFO (gen)","NAFO (det)","SS Box", "SS Grid", "SS Areas","General Areas","Remote Sensing", "Zooplank (Broad. Occ.)")



  m <- leaflet::hideGroup(map=m, group = overlayGroups[!overlayGroups %in% c("Stations","Sections", "NAFO (gen)")])

  m <- leaflet::addLayersControl(map=m, baseGroups = baseGroups,
                                 overlayGroups = overlayGroups,
                                 position = "topleft",
                                 options = leaflet::layersControlOptions(collapsed = FALSE))
  m <- leaflet::addControl(map=m, html = titleHTML, position = "bottomleft")

  return(m)
}
