# data set documentation


#' Zooplankton seasonal section data
#'
#' A dataframe containing seasonal section zooplankton data.
#' The variables are as follows:
#'
#' @format A dataframe with 152 observations of 6 variables:
#'
#' \describe{
#'    \item{section}{Section name where data was collected}
#'    \item{year}{The year in which data was collected}
#'    \item{season}{The season in which data was collected (Northern Hemisphere)}
#'
#'    \item{Calanus_finmarchicus_log10}{Abundance of Calanus finmarchicus with a log10 transform}
#'    \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'    \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton sampled}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Seasonal}
#'    \item{regional_scale}{Section}
#'    \item{category}{Zooplankton, biological, biochemical}
#'    }
#'
#'
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
"Zooplankton_Seasonal_Sections"

#' Zooplankton seasonal broadscale data
#'
#' A dataframe containing seasonal broadscale zooplankton data.
#' The variables are as follows:
#'
#' @format A dataframe containing 40 observations of 6 variables:
#' \describe{
#'    \item{region}{The region in which data was collected}
#'    \item{year}{The year in which data was collected}
#'    \item{season}{The season in which data was collected (Northern Hemisphere)}
#'
#'
#'    \item{Calanus_finmarchicus_log10}{Abundance of Calanus finmarchicus with a log10 transform}
#'    \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'    \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton sampled}
#' }
#'
#'  @note
#' \describe{
#'    \item{time_scale}{Seasonal}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{Zooplankton, biological, biochemical}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
"Zooplankton_Seasonal_Broadscale"

#' Zooplankton Occupation Broadscale data
#'
#' A dataframe containing seasonal broadscale zooplankton data.
#' The variables are as follows:
#'
#' @format A dataframe containing 1177 obesrvations of 10 variables
#' \describe{
#'    \item{latitude}{The latitude at which data was collected}
#'    \item{longitude}{The longitude at which data was collected}
#'    \item{year}{The year in which data was collected}
#'    \item{month}{The month in which data was collected (numeric)}
#'    \item{day}{The day on which data was collected}
#'    \item{season}{The season in which data was collected (Northern Hemisphere)}
#'    \item{sample_id}{A unique identifier for each sample}
#'
#'    \item{Calanus_finmarchicus_abundance}{Abundance of Calanus finmarchicus}
#'    \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'    \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton sampled}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{Zooplankton, biological, biochemical}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
"Zooplankton_Occupations_Broadscale"

#' Derived Occupation Station data
#'
#' Metrics derived from data collected at fixed station locations during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe with 737 observations of 14 variables
#' \describe{
#'    \item{station}{The name of the station where data was collected}
#'    \item{latitude}{The latitude at which data was collected}
#'    \item{longitude}{The longitude at which data was collected}
#'    \item{year}{The year in which data was collected}
#'    \item{month}{The month in which data was collected (numeric)}
#'    \item{day}{The day on which data was collected}
#'    \item{event_id}{A unique identifier for the sampling event}
#'    \item{sample_id}{A unique identifier for the sample}
#'    \item{depth}{The depth at which data was actually collected}
#'    \item{nominal_depth}{The depth at which data was planned to be collected - sometime differs slightly from actual collection depth}
#'
#'    \item{mixed_layer_depth}{The depth of the well mixed surface layer at fixed stations}
#'    \item{density_gradient_0_50}{An index of stratification, measured as the density difference between 0 and 50 metres}
#'    \item{euphotic_depth}{The depth of the euphotic zone measured at fixed stations}
#'    \item{integrated_nitrate_0_50}{Nitrate concentrations integrated between 0 and 50 metres}
#'    \item{integrated_nitrate_50_150}{Nitrate concentrations integrated between 50 and 150 metres}
#'    \item{integrated_phosphate_0_50}{Phosphate concentrations integrated between 0 and 50 metres}
#'    \item{integrated_phosphate_50_150}{Phosphate concentrations integrated between 50 and 150 metres}
#'    \item{integrated_silicate_0_50}{Silicate concentrations integrated between 0 and 50 metres}
#'    \item{integrated_silicate_50_150}{Silicate concentrations integrated between 50 and 150 metres}
#'    \item{integrated_chlorophyll_0_100}{Chlorophyll concentrations integrated between 0 and 100 metres}
#' }
#'
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, biochemical, physical}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
#'   Hebert, D., Pettipas, R., and Brickman, D. 2020. Physical Oceanographic
#'   Conditions on the Scotian Shelf and in the Gulf of Maine during 2018. DFO
#'   Can. Sci. Advis. Sec. Res. Doc. 2020/036 iv + 52 p.
#'
#'
"Derived_Occupations_Stations"


#' Zooplankton Occupations Stations data
#'
#' This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * sample_id
#' * depth
#' * nominal_depth
#'
#'
#' _Data_
#' * calanus_finmarchicus_abundance
#' * calanus_hyperboreus_abundance
#' * calanus_glacialis_abundance
#' * pseudocalanus_abundance
#' * metridia_longa_abundance
#' * metridia_lucens_abundance
#' * metridia_spp_abundance
#' * temora_spp_abundance
#' * microcalanus_spp_abundance
#' * oithona_spp_abundance
#' * oithona_similis_abundance
#' * oithona_atlantica_abundance
#' * paracalanus_spp_abundance
#' * centropages_typicus_abundance
#' * centropages_spp_abundance
#' * scolecithricella_minor_abundance
#' * larvacae_abundance
#' * gastropoda_abundance
#' * bivalvia_abundance
#' * euphasiacea_abundance
#' * zooplankton_abundance
#' * zooplankton_meso_dry_weight
#' * zooplankton_meso_wet_weight
#' * zooplankton_macro_wet_weight
#' * zooplankton_total_wet_Weight
#' * calanus_abundance_stage_c1
#' * calanus_abundance_stage_c2
#' * calanus_abundance_stage_c3
#' * calanus_abundance_stage_c4
#' * calanus_abundance_stage_c5
#' * calanus_abundance_stage_c6
#'
#'
 "Zooplankton_Occupations_Stations"


#' Phytoplankton Occupation Station data
#'
#'  This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * sample_id
#' * depth
#' * nominal_depth
#'
#' _Data_
#' * microplankton_abundance
#'
"Phytoplankton_Occupations_Stations"


#' Discrete Occupation Station data
#'
#' This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * sample_id
#' * depth
#' * nominal_depth
#'
#' _Data_
#' * nitrate
#' * silicate
#' * phosphate
#' * chlorophyll
#' * temperature
#' * salinity
#' * density
#'
"Discrete_Occupations_Stations"


#' Derived Occupation Monthly data
#'
#' This data frame includes
#' _Metadata_
#' * station_name
#' * latitude
#' * longitude
#' * year
#' * month
#'
#' _Data_
#' * sea_surface_height
#'
# "Derived_Monthly_Stations"


#' Derived Annual station data
#'
#'  This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#'
#' _Data_
#' * temperature_in_air
#' * denisty
#' * sea_temperature
#' * salinity
#' * integrated_sea_temperature_0_50
#' * integrated_salinity_0_50
#' * integrated_density_0_50
#' * temperature_0
#' * temperature_90
#' * sea_surface_temperature_from_moorings
#' * sea_surface_height
#' * integrated_nitrate_0_50
#' * integrated_nitrate_50_150
#' * integrated_phosphate_0_50
#' * integrated_phosphate_50_150
#'
#'
"Derived_Annual_Stations"

#' Zooplankton Annual Stations data
#'
#' This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#'
#' _Data_
#' * calanus_finmarchicus_log10
#' * calanus_hyperboreus_log10
#' * calanus_glacialis_log10
#' * pseudocalanus_log10
#' * metridia_longa_log10
#' * metridia_lucens_log10
#' * metridia_spp_log10
#' * temora_spp_log10
#' * microcalanus_spp_log10
#' * oithona_spp_log10
#' * oithona_similis_log10
#' * oithona_atlantica_log10
#' * paracalanus_spp_log10
#' * centropages_typicus_log10
#' * centropages_spp_log10
#' * scolecithricella_minor_log10
#' * larvacae_log10
#' * gastropoda_log10
#' * bivalvia_log10
#' * euphasiacea_log10
#' * zooplankton_abundance_log10
#' * zooplankton_meso_dry_weight
#' * zooplankton_meso_wet_weight
#' * zooplankton_macro_wet_weight
#' * zooplankton_total_wet_weight
#'
 "Zooplankton_Annual_Stations"

#' Phytoplankton Annual Station data
#'
#' This data frame includes
#' _Metadata_
#' * station
#' * latitude
#' * longitude
#' * year
#'
#' _Data_
#' * microplankton_abundance_log10
#'
"Phytoplankton_Annual_Stations"


#' Derived Occupation Section data
#'
#' This data frame includes
#' _Metadata_
#' * section
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * cruise_id
#' * sample_id
#' * depth
#' * nominal_depth
#' * odf_filename
#'
#' _Data_
#' * integrated_nitrate_0_50
#' * integrated_nitrate_50_150
#' * integrated_phosphate_0_50
#' * integrated_phosphate_50_150
#' * integrated_silicate_0_50
#' * integrated_silicate_50_150
#' * integrated_chlorophyll_0_100
#'
"Derived_Occupations_Sections"


#' Zooplankton Occupation Section data
#'
#' This data frame includes
#' _Metadata_
#' * section
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * cruise_id
#' * sample_id
#' * depth
#' * nominal_depth
#' * odf_filename
#'
#' _Data_
#' * calanus_finmarchicus_abundance
#' * calanus_hyperboreus_abundance
#' * calanus_glacialis_abundance
#' * pseudocalanus_abundance
#' * metridia_longa_abundance
#' * metridia_lucens_abundance
#' * metridia_spp_abundance
#' * temora_spp_abundance
#' * microcalanus_spp_abundance
#' * oithona_spp_abundance
#' * oithona_similis_abundance
#' * oithona_atlantica_abundance
#' * paracalanus_spp_abundance
#' * centropages_typicus_abundance
#' * centropages_spp_abundance
#' * scolecithricella_minor_abundance
#' * larvacae_abundance
#' * gastropoda_abundance
#' * bivalvia_abundance
#' * euphasiacea_abundance
#' * zooplankton_abundance
#' * zooplankton_meso_dry_weight
#' * zooplankton_meso_wet_weight
#' * zooplankton_macro_wet_weight
#' * zooplankton_total_wet_Weight
#' * calanus_abundance_stage_c1
#' * calanus_abundance_stage_c2
#' * calanus_abundance_stage_c3
#' * calanus_abundance_stage_c4
#' * calanus_abundance_stage_c5
#' * calanus_abundance_stage_c6
#'
 "Zooplankton_Occupations_Sections"


#' Discrete Occupation Section data
#'
#' This data frame includes
#' _Metadata_
#' * section
#' * station
#' * latitude
#' * longitude
#' * year
#' * month
#' * day
#' * event_id
#' * cruise_id
#' * sample_id
#' * depth
#' * nominal_depth
#' * odf_filename
#'
#' _Data_
#' * nitrate
#' * silicate
#' * phosphate
#' * chlorophyll
#' * temperature
#' * salinity
#' * density
#'
"Discrete_Occupations_Sections"


#' Derived Annual Section data
#'
#' _Metadata_
#' * section
#' * year
#'
#' _Data_
#' * density
#' * temperature
#' * salinity
#' * integrated_nitrate_0_50
#' * integrated_nitrate_50_150
#' * integrated_phosphate_0_50
#' * integrated_phosphate_50_150
#' * integrated_silicate_0_50
#' * integrated_silicate_50_150
#' * integrated_chlorphyll_0_100
#'
"Derived_Annual_Sections"


#' Zooplankton Annual Section data
#'
#'  _Metadata_
#' * section
#' * year
#'
#' _Data_
#'  * calanus_finmarchicus_log10
#' * calanus_hyperboreus_log10
#' * calanus_glacialis_log10
#' * pseudocalanus_log10
#' * metridia_longa_log10
#' * metridia_lucens_log10
#' * metridia_spp_log10
#' * temora_spp_log10
#' * microcalanus_spp_log10
#' * oithona_spp_log10
#' * oithona_similis_log10
#' * oithona_atlantica_log10
#' * paracalanus_spp_log10
#' * centropages_typicus_log10
#' * centropages_spp_log10
#' * scolecithricella_minor_log10
#' * larvacae_log10
#' * gastropoda_log10
#' * bivalvia_log10
#' * euphasiacea_log10
#' * zooplankton_abundance_log10
#' * zooplankton_meso_dry_weight
#' * zooplankton_meso_wet_weight
#' * zooplankton_macro_wet_weight
#' * zooplankton_total_wet_weight
#'
 "Zooplankton_Annual_Sections"


#' Derived monthly broadscale data
#'
#' _Metadata_
#' * area
#' * year
#' * month
#'
#' _Data_
#' * sea_surface_temperature_from_satellite
#' * sea_ice_area
#'
#' Data variables are described in more detail in variable look-up table (see \code{\link{lookup_variable}})
# "Derived_Monthly_Broadscale"


#' Derived annual broadscale data
#'
#' _Metadata_
#' * area
#' * year
#'
#' _Data_
#' * sea_temperature_at_sea_floor_july
#' * sea_surface_temperature
#' * north_atlantic_oscillation
#' * atlantic_multidecadal_oscillation
#' * river_flux
#' * cold_intermediate_layer_volume
#' * sea_ice_volume
#' * density_gradient_0_50
#' * temperature_at_sea_floor
#' * minimum_temperature_in_cold_intermediate_layer
#' * salinity
#' * temperature
#' * sea_surface_temperature_from_satellite
#' * sea_surface_temperature_warming
#' * final_day_of_sea_ice
#' * sea_ice_area
#' * start_of_phytoplankton_bloom
#' * duration_of_phytoplankton_bloom
#' * amplitude_of_phytoplankton_bloom
#' * magnitude_of_phytoplankton_bloom
#' * nitrate_at_sea_Floor
#' * primary_production_from_satellite
#' * oxygen_at_sea_floor
#' * surface_chlorphyll_from_satellite
#'
"Derived_Annual_Broadscale"


#' Remote Sensing Annual Broadscale data
#'
#'
#' _Metadata_
#' * area
#' * year
#'
#' _Data_
#' * surface_chlorophyll_log10
#' * bloom_start
#' * bloom_duration
#' * bloom_amplitude
#' * bloom_magnitude
#'
#' Data variables are described in more detail in variable look-up table (see \code{\link{lookup_variable}})
# "RemoteSensing_Annual_Broadscale"


#' Remote sesning weekly broadscale data
#'
#' _Metadata_
#' * area
#' * year
#' * month
#' * week
#'
#' _Data_
#' * surface_chlorophyll
#'
#'
 "RemoteSensing_Weekly_Broadscale"




#' Discrete annual broadscale data
#'
#' _Metadata_
#' * year
#' * area
#'
#' _Data_
#' * salinity
#' * sea_temperature
#' Data variables are described in more detail in variable look-up table (see \code{\link{lookup_variable}})
"Discrete_Annual_Broadscale"

#' Remote sensing Annual broadscale data
#'
#' _Metadata_
#' * area
#' * year
#'
#' _Data_
#' * surface_chlorophyll_log10
#' * bloom_start
#' * bloom_duration
#' * bloom_amplitude
#' * bloom_magnitude
#'
"RemoteSensing_Annual_Broadscale"
































