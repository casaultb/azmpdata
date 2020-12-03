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
#'    \item{sample_id}{A unique identifier for each sample, sample id
#'    appended by the cruise number to ensure uniqueness}
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
#' Zooplankton data collected at fixed stations during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{sample_id}{A unique identifier for the sample}
#'     \item{depth}{The depth at which data was actually collected}
#'
#'     \item{calanus_finmarchicus_abundance}{Abundance of calanus finmarchicus }
#'     \item{calanus_hyperboreus_abundance}{Abundance of Calanus Hyperboreus}
#'     \item{calanus_glacialis_abundance}{Abundance of Calanus Glacialis}
#'     \item{pseudocalanus_abundance}{Abundance of pseudocalanus}
#'     \item{metridia_longa_abundance}{Abundance of Metridia longa}
#'     \item{metridia_lucens_abundance}{Abundance of Metridia lucens}
#'     \item{metridia_spp_abundance}{Abundance of Metridia spp}
#'     \item{temora_spp_abundance}{Abundance of Temora spp}
#'     \item{microcalanus_spp_abundance}{Abundance of microcalanus}
#'     \item{oithona_spp_abundance}{Abundance of Oithona spp}
#'     \item{oithona_similis_abundance}{Abundance of Oithona similis}
#'     \item{oithona_atlantica_abundance}{Abundance of Oithona atlantica}
#'     \item{paracalanus_spp_abundance}{Abundance of paracalanus}
#'     \item{centropages_typicus_abundance}{Abundance of Centropages typicus}
#'     \item{centropages_spp_abundance}{Abundance of Centropages spp}
#'     \item{scolecithricella_minor_abundance}{Abundance of scolecithricella minor}
#'     \item{larvacae_abundance}{Abundance of larvacae}
#'     \item{gastropoda_abundance}{Abundance of gastropoda}
#'     \item{bivalvia_abundance}{Abundance of bilvalvia}
#'     \item{euphasiacea_abundance}{Abundance of euphasiacea}
#'     \item{zooplankton_abundance}{Abundance of all zooplankton}
#'     \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'     \item{zooplankton_meso_wet_weight}{Wet weight of meso zooplankton}
#'     \item{zooplankton_macro_wet_weight}{Wet weight of macro zooplankton}
#'     \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton}
#'     \item{calanus_abundance_stage_c1}{Stage seperated calanus abundance (stage c1)}
#'     \item{calanus_abundance_stage_c2}{Stage seperated calanus abundance (stage c2)}
#'     \item{calanus_abundance_stage_c3}{Stage seperated calanus abundance (stage c3)}
#'     \item{calanus_abundance_stage_c4}{Stage seperated calanus abundance (stage c4)}
#'     \item{calanus_abundance_stage_c5}{Stage seperated calanus abundance (stage c5)}
#'     \item{calanus_abundance_stage_c6}{Stage seperated calanus abundance (stage c6)}
#'}
#'
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, zooplankton}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
 "Zooplankton_Occupations_Stations"


#' Phytoplankton Occupation Station data
#'
#' Phytoplankton data collected at fixed stations during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{sample_id}{A unique identifier for the sample}
#'     \item{depth}{The depth at which data was actually collected}
#'
#'     \item{microplankton_abundance}{Abundance of microplankton at fixed stations (phytoplankton and protists)}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, phytoplankton}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
"Phytoplankton_Occupations_Stations"


#' Discrete Occupation Station data
#'
#' Discrete data collected at fixed stations during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{sample_id}{A unique identifier for the sample}
#'     \item{depth}{The depth at which data was actually collected}
#'     \item{nominal_depth}{The depth at which data was planned to be collected - sometime differs slightly from actual collection depth}
#'
#'     \item{nitrate}{Discrete measurements of nitrate concentration in the water column at a range of depths }
#'     \item{silicate}{Discrete measurements of silicate concentration in the water column at a range of depths }
#'     \item{phosphate}{Discrete measurements of phosphate concentration in the water column at a range of depths }
#'     \item{chlorophyll}{Discrete measurements of chlorophyll concentration in the water column at a range of depths }
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{density}{Discrete density measurements over a range of depths}
#'
#' }
#'
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, phytoplankton, biochemical, physical}
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

"Discrete_Occupations_Stations"


#' Derived Occupation Monthly data
#'
#' Derived data from fixed stations by month.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#'
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
#' Derived data collected at fixed stations by year.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{temperature_in_air}{Average air temperatures over annual scales at specific stations including Sable Island}
#'     \item{denisty}{Discrete density measurements over a range of depths}
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{integrated_sea_temperature_0_50}{Averages of temperature measurements, integrated between 0 and 50 metres}
#'     \item{integrated_salinity_0_50}{Averages of salinity measurements, integrated between 0 and 50 metres}
#'     \item{integrated_density_0_50}{Averages of density measurements, integrated between 0 and 50 metres}
#'     \item{temperature_0}{Averages for temperature at 0 metres at Prince 5 (P5) and Halifax 2 (HL2) stations}
#'     \item{temperature_90}{Averages for temperature at 90 metres at Prince 5 (P5) and Halifax 2 (HL2) stations}
#'     \item{sea_surface_temperature_from_moorings}{Averages of sea surface temperatures recorded by mooring at Halifax, NS and St. Andrews, NB}
#'     \item{sea_surface_height}{Average of sea surface height at Yarmouth and Halifax NS}
#'     \item{integrated_nitrate_0_50}{Nitrate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_nitrate_50_150}{Nitrate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_phosphate_0_50}{Phosphate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_phosphate_50_150}{Phosphate concentrations integrated between 50 and 150 metres}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, phytoplankton, biochemical, physical}
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
"Derived_Annual_Stations"

#' Zooplankton Annual Stations data
#'
#' Zooplankton data collected at fixed stations by year.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{calanus_finmarchicus_log10}{Abundance of calanus finmarchicus with
#'     a log 10 transform }
#'     \item{calanus_hyperboreus_log10}{Abundance of calanus hyperboreus with a
#'     log 10 transform }
#'     \item{calanus_glacialis_log10}{Abundance of calanus glacialis with a log
#'     10 transform }
#'     \item{pseudocalanus_log10}{Abundance of pseudocalanus  with a log 10 transform }
#'     \item{metridia_longa_log10}{Abundance of metridia longa  with a log 10 transform }
#'     \item{metridia_lucens_log10}{Abundance of metridia lucens  with a log 10 transform }
#'     \item{metridia_spp_log10}{Abundance of metridia spp  with a log 10 transform }
#'     \item{temora_spp_log10}{Abundance of temora spp  with a log 10 transform }
#'     \item{microcalanus_spp_log10}{Abundance of microcalanus  with a log 10 transform }
#'     \item{oithona_spp_log10}{Abundance of oithona species  with a log 10 transform }
#'     \item{oithona_similis_log10}{Abundance of oithona similis  with a log 10 transform }
#'     \item{oithona_atlantica_log10}{Abundance of oithona atlantica  with a log
#'     10 transform }
#'     \item{paracalanus_spp_log10}{Abundance of paracalanus  with a log 10 transform }
#'     \item{centropages_typicus_log10}{Abundance of centropages typicus  with a
#'     log 10 transform }
#'     \item{centropages_spp_log10}{Abundance of centropages species  with a log
#'     10 transform }
#'     \item{scolecithricella_minor_log10}{Abundance of scolecithricella minor
#'     with a log 10 transform }
#'     \item{larvacae_log10}{Abundance of larvacae group  with a log 10 transform }
#'     \item{gastropoda_log10}{Abundance of gastropoda group  with a log 10 transform }
#'     \item{bivalvia_log10}{Abundance of bivalvia group  with a log 10 transform }
#'     \item{euphasiacea_log10}{Abundance of euphasiacea group  with a log 10 transform }
#'     \item{zooplankton_abundance_log10}{Abundance of zooplankton at fixed
#'     stations with a log 10 transform}
#'     \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'     \item{zooplankton_meso_wet_weight}{Wet weight of meso zooplankton}
#'     \item{zooplankton_macro_wet_weight}{Wet weight of macro zooplankton}
#'     \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton from sampling}
#' }
#'
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, zooplankton}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
 "Zooplankton_Annual_Stations"

#' Phytoplankton Annual Station data
#'
#' Phytoplankton data collected at fixed stations by year.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{station}{The name of the station where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{microplankton_abundance_log10}{Abundance of microplankton
#'     (phytoplankton and protists) at fixed stations with a log 10 transform}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Station}
#'    \item{category}{ biological, phytoplankton}
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
"Phytoplankton_Annual_Stations"


#' Derived Occupation Section data
#'
#' Derived data collected along AZMP transects during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{section}{Section name where data was collected}
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{cruise_id}{A unique identifier for the mission/cruise}
#'     \item{odf_filename}{The original data file name}
#'
#'     \item{integrated_nitrate_0_50}{Nitrate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_nitrate_50_150}{Nitrate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_phosphate_0_50}{Phosphate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_phosphate_50_150}{Phosphate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_silicate_0_50}{Silicate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_silicate_50_150}{Silicate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_chlorophyll_0_100}{Chlorophyll concentrations integrated between 0 and 100 metres}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Section}
#'    \item{category}{ biological, biochemical }
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
"Derived_Occupations_Sections"


#' Zooplankton Occupation Section data
#'
#' Zooplankton data collected along AZMP transects during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{section}{Section name where data was collected}
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{season}{The season in which data was collected (Northern Hemisphere)}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{cruise_id}{A unique identifier for the mission/cruise}
#'     \item{sample_id}{A unique identifier for the sample}
#'     \item{depth}{The depth at which data was actually collected}
#'
#'     \item{calanus_finmarchicus_abundance}{Abundance of calanus finmarchicus }
#'     \item{calanus_hyperboreus_abundance}{Abundance of calanus hyperboreus }
#'     \item{calanus_glacialis_abundance}{Abundance of calanus glacialis }
#'     \item{pseudocalanus_abundance}{Abundance of pseudocalanus  }
#'     \item{metridia_longa_abundance}{Abundance of metridia longa  }
#'     \item{metridia_lucens_abundance}{Abundance of metridia lucens  }
#'     \item{metridia_spp_abundance}{Abundance of metridia species  }
#'     \item{temora_spp_abundance}{Abundance of temora species}
#'     \item{microcalanus_spp_abundance}{Abundance of microcalanus}
#'     \item{oithona_spp_abundance}{Abundance of oithona species  }
#'     \item{oithona_similis_abundance}{Abundance of oithona similis}
#'     \item{oithona_atlantica_abundance}{Abundance of oithona atlantica}
#'     \item{paracalanus_spp_abundance}{Abundance of paracalanus  }
#'     \item{centropages_typicus_abundance}{Abundance of centropages typicus  }
#'     \item{centropages_spp_abundance}{Abundance of centropages species  }
#'     \item{scolecithricella_minor_abundance}{Abundance of scolecithricella minor  }
#'     \item{larvacae_abundance}{Abundance of larvacae group}
#'     \item{gastropoda_abundance}{Abundance of gastropoda group}
#'     \item{bivalvia_abundance}{Abundance of bivalvia group}
#'     \item{euphasiacea_abundance}{Abundance of euphasiacea group}
#'     \item{zooplankton_abundance}{Abundance of zooplankton at fixed stations}
#'     \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'     \item{zooplankton_meso_wet_weight}{Wet weight of meso zooplankton}
#'     \item{zooplankton_macro_wet_weight}{Wet weight of macro zooplankton}
#'     \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton from sampling}
#'     \item{calanus_abundance_stage_c1}{Stage seperated calanus abundance (stage c1)}
#'     \item{calanus_abundance_stage_c2}{Stage seperated calanus abundance (stage c2)}
#'     \item{calanus_abundance_stage_c3}{Stage seperated calanus abundance (stage c3)}
#'     \item{calanus_abundance_stage_c4}{Stage seperated calanus abundance (stage c4)}
#'     \item{calanus_abundance_stage_c5}{Stage seperated calanus abundance (stage c5)}
#'     \item{calanus_abundance_stage_c6}{Stage seperated calanus abundance (stage c6)}
#' }
#'
#'
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Section}
#'    \item{category}{ biological, zooplankton }
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
 "Zooplankton_Occupations_Sections"


#' Discrete Occupation Section data
#'
#' Discrete data collected along AZMP transects during individual occupations.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{section}{Section name where data was collected}
#'     \item{station}{The name of the station where data was collected}
#'     \item{latitude}{The latitude at which data was collected}
#'     \item{longitude}{The longitude at which data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{day}{The day on which data was collected}
#'     \item{event_id}{A unique identifier for the sampling event}
#'     \item{cruise_id}{A unique identifier for the mission/cruise}
#'     \item{sample_id}{A unique identifier for the sample}
#'     \item{depth}{The depth at which data was actually collected}
#'     \item{nominal_depth}{The depth at which data was planned to be collected - sometime differs slightly from actual collection depth}
#'     \item{odf_filename}{The original data file name}
#'
#'     \item{nitrate}{Discrete measurements of nitrate concentration in the water column at a range of depths }
#'     \item{silicate}{Discrete measurements of silicate concentration in the water column at a range of depths }
#'     \item{phosphate}{Discrete measurements of phosphate concentration in the water column at a range of depths }
#'     \item{chlorophyll}{Discrete measurements of chlorophyll concentration in the water column at a range of depths }
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{density}{Discrete density measurements over a range of depths}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Occupation}
#'    \item{regional_scale}{Section}
#'    \item{category}{ biological, biochemical, physical }
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
"Discrete_Occupations_Sections"


#' Derived Annual Section data
#'
#' Derived data collected along AZMP transects each year.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{section}{Section name where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{density}{Discrete density measurements over a range of depths}
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{integrated_nitrate_0_50}{Nitrate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_nitrate_50_150}{Nitrate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_phosphate_0_50}{Phosphate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_phosphate_50_150}{Phosphate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_silicate_0_50}{Silicate concentrations integrated between 0 and 50 metres}
#'     \item{integrated_silicate_50_150}{Silicate concentrations integrated between 50 and 150 metres}
#'     \item{integrated_chlorphyll_0_100}{Chlorophyll concentrations integrated between 0 and 100 metres}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Section}
#'    \item{category}{ biological, biochemical, physical }
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
"Derived_Annual_Sections"


#' Zooplankton Annual Section data
#'
#' Zooplankton data collected along AZMP transects each year.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{section}{Section name where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{calanus_finmarchicus_log10}{Abundance of calanus finmarchicus with a log 10 transform }
#'     \item{calanus_hyperboreus_log10}{Abundance of calanus hyperboreus with a log 10 transform }
#'     \item{calanus_glacialis_log10}{Abundance of calanus glacialis with a log 10 transform }
#'     \item{pseudocalanus_log10}{Abundance of pseudocalanus  with a log 10 transform }
#'     \item{metridia_longa_log10}{Abundance of metridia longa  with a log 10 transform }
#'     \item{metridia_lucens_log10}{Abundance of metridia lucens  with a log 10 transform }
#'     \item{metridia_spp_log10}{Abundance of metridia spp  with a log 10 transform }
#'     \item{temora_spp_log10}{Abundance of temora spp  with a log 10 transform }
#'     \item{microcalanus_spp_log10}{Abundance of microcalanus  with a log 10 transform }
#'     \item{oithona_spp_log10}{Abundance of oithona species  with a log 10 transform }
#'     \item{oithona_similis_log10}{Abundance of oithona similis  with a log 10 transform }
#'     \item{oithona_atlantica_log10}{Abundance of oithona atlantica  with a log 10 transform }
#'     \item{paracalanus_spp_log10}{Abundance of paracalanus  with a log 10 transform }
#'     \item{centropages_typicus_log10}{Abundance of centropages typicus  with a log 10 transform }
#'     \item{centropages_spp_log10}{Abundance of centropages species  with a log 10 transform }
#'     \item{scolecithricella_minor_log10}{Abundance of scolecithricella minor  with a log 10 transform }
#'     \item{larvacae_log10}{Abundance of larvacae group  with a log 10 transform }
#'     \item{gastropoda_log10}{Abundance of gastropoda group  with a log 10 transform }
#'     \item{bivalvia_log10}{Abundance of bivalvia group  with a log 10 transform }
#'     \item{euphasiacea_log10}{Abundance of euphasiacea group  with a log 10 transform }
#'     \item{zooplankton_abundance_log10}{Abundance of zooplankton at fixed stations with a log 10 transform}
#'     \item{zooplankton_meso_dry_weight}{Dry weight of meso zooplankton}
#'     \item{zooplankton_meso_wet_weight}{Wet weight of meso zooplankton}
#'     \item{zooplankton_macro_wet_weight}{Wet weight of macro zooplankton}
#'     \item{zooplankton_total_wet_weight}{Wet weight of all zooplankton from sampling}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Section}
#'    \item{category}{ biological, biochemical, zooplankton }
#'    }
#'
#' @details The data can be cited as follows:
#'   Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
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
#' Derived data averaged over broad regions and years.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{area}{Area name where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{sea_temperature_at_sea_floor_july}{Temperature at sea floor during the month of July, averaged over NAFO areas 4X, 4W and 4V.}
#'     \item{sea_surface_temperature}{Temperature at sea surface averaged over NAFO regions 4V, 4X and 4W as well as regional areas (Bay of Fundy + Gulf of Maine)}
#'     \item{north_atlantic_oscillation}{North Atlantic Oscillation Index (NAO), calculated using sea level pressure difference between subtropical high and subpolar low}
#'     \item{atlantic_multidecadal_oscillation}{Atlantic Multidecadal Oscillation Index (AMO), based on anomalies of sea surface temperatures in North Atlantic basin. }
#'     \item{river_flux}{A measure of the flux exiting from the St. Lawrence river into the Gulf of St. Lawrence. }
#'     \item{cold_intermediate_layer_volume}{A measure of the volume of the cold intermediate layer throughout the Gulf of St. Lawrence}
#'     \item{sea_ice_volume}{Average ice volume for January - March in the Gulf of St. Lawrence, can be reasonably used as a proxy to represent sea ice volume on the Scotian Shelf. }
#'     \item{density_gradient_0_50}{An index of stratification, measured as the density difference between 0 and 50 metres}
#'     \item{temperature_at_sea_floor}{Averaged water temperatures at sea floor, over NAFO areas 4X, 4V and 4W}
#'     \item{minimum_temperature_in_cold_intermediate_layer}{Minimum temperature in the cold intermediate layer within the Gulf of St. Lawrence }
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#'     \item{sea_surface_temperature_from_satellite}{Averages of sea surface temperatures infered from remote sensing (satellite) measurements}
#'     \item{sea_surface_temperature_warming}{Derived metric calculating the warming of sea surface temperature averages over the Scotian Shelf}
#'     \item{final_day_of_sea_ice}{The final day of sea ice observed in the Gulf of St. Lawrence. Note that this metric can be used as a reasonable proxy for the Scotian Shelf}
#'     \item{sea_ice_area}{Average  of sea ice area, seaward of Cabot Strait}
#'     \item{start_of_phytoplankton_bloom}{The timing (start) of the phytoplankton bloom on the Scotian Shelf}
#'     \item{duration_of_phytoplankton_bloom}{The duration of the Scotian Shelf phytoplankton bloom}
#'     \item{amplitude_of_phytoplankton_bloom}{An average measure of the amplitude of the phytoplankton bloom on the Scotian Shelf}
#'     \item{magnitude_of_phytoplankton_bloom}{An average measure of the magnitude of the phytoplankton bloom on the Scotian Shelf}
#'     \item{nitrate_at_sea_floor}{Nitrate concentrations at the bottom of the water column}
#'     \item{primary_production_from_satellite}{Average primary production as inferred from satellite (remote sensing) measurements}
#'     \item{oxygen_at_sea_floor}{Oxygen concentrations at the bottom of the water column}
#'     \item{surface_chlorphyll}{Average surface chlorophyll as inferred from satellite (remote sensing) measurements}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{ biological, biochemical, physical }
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
"Derived_Annual_Broadscale"



#' Remote sensing weekly broadscale data
#'
#' Remote Sensing data averaged over broad regions and weeks.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{area}{Area name where data was collected}
#'     \item{year}{The year in which data was collected}
#'     \item{month}{The month in which data was collected (numeric)}
#'     \item{week}{The week in which data was collected (numeric)}
#'
#'     \item{surface_chlorophyll}{Average surface chlorophyll as inferred from satellite (remote sensing) measurements}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Weekly}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{ biological, biochemical, satellite }
#'    }
#'
#' @details The data can be cited as follows:
#' Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
#'
 "RemoteSensing_Weekly_Broadscale"




#' Discrete annual broadscale data
#'
#' Discrete data averaged over broad regions and years.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{year}{The year in which data was collected}
#'     \item{area}{Area name where data was collected}
#'
#'     \item{salinity}{Discrete salinity measurements over a range of depths}
#'     \item{sea_temperature}{Discrete sea temperature measurements over a range of depths}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{ physical }
#'    }
#'
#' @details The data can be cited as follows:
#' Hebert, D., Pettipas, R., and Brickman, D. 2020. Physical Oceanographic
#'   Conditions on the Scotian Shelf and in the Gulf of Maine during 2018. DFO
#'   Can. Sci. Advis. Sec. Res. Doc. 2020/036 iv + 52 p.
#'
"Discrete_Annual_Broadscale"


#' Remote sensing Annual broadscale data
#'
#' Remote Sensing data averaged over broad regions and years.
#'
#' The variables are as follows:
#'
#' @format A dataframe
#' \describe{
#'     \item{area}{Area name where data was collected}
#'     \item{year}{The year in which data was collected}
#'
#'     \item{surface_chlorophyll_log10}{Average surface chlorophyll as inferred from satellite (remote sensing) measurements, with a log 10 transform}
#'     \item{bloom_start}{Start of pythoplankton bloom, from satellite}
#'     \item{bloom_duration}{Length of phytoplankton bloom, from satellite}
#'     \item{bloom_amplitude}{Amplitude of phytoplankton bloom, from satellite}
#'     \item{bloom_magnitude}{Magnitude of phytoplankton bloom, from satellite}
#' }
#'
#' @note
#' \describe{
#'    \item{time_scale}{Annual}
#'    \item{regional_scale}{Broadscale}
#'    \item{category}{ biolgocial, biochemical, satellite }
#'    }
#'
#' @details The data can be cited as follows:
#' Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
#'   Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
#'   on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
#'   Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
#'
"RemoteSensing_Annual_Broadscale"
































