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
#'     \item{microcalanus_spp_abundance}{Abundance of microcalanus  }
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
































