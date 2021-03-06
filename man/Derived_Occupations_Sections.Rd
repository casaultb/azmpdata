% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{Derived_Occupations_Sections}
\alias{Derived_Occupations_Sections}
\title{Derived Occupation Section data}
\format{
A dataframe
\describe{
    \item{section}{Section name where data was collected}
    \item{station}{The name of the station where data was collected}
    \item{latitude}{The latitude at which data was collected}
    \item{longitude}{The longitude at which data was collected}
    \item{year}{The year in which data was collected}
    \item{month}{The month in which data was collected (numeric)}
    \item{day}{The day on which data was collected}
    \item{event_id}{A unique identifier for the sampling event}
    \item{cruise_id}{A unique identifier for the mission/cruise}
    \item{odf_filename}{The original data file name}

    \item{integrated_nitrate_0_50}{Nitrate concentrations integrated between 0 and 50 metres}
    \item{integrated_nitrate_50_150}{Nitrate concentrations integrated between 50 and 150 metres}
    \item{integrated_phosphate_0_50}{Phosphate concentrations integrated between 0 and 50 metres}
    \item{integrated_phosphate_50_150}{Phosphate concentrations integrated between 50 and 150 metres}
    \item{integrated_silicate_0_50}{Silicate concentrations integrated between 0 and 50 metres}
    \item{integrated_silicate_50_150}{Silicate concentrations integrated between 50 and 150 metres}
    \item{integrated_chlorophyll_0_100}{Chlorophyll concentrations integrated between 0 and 100 metres}
}
}
\usage{
Derived_Occupations_Sections
}
\description{
Derived data collected along AZMP transects during individual occupations.
}
\details{
The data can be cited as follows:
  Casault, B., Johnson, C., Devred, E., Head, E., Cogswell, A., and
  Spry, J. 2020. Optical, Chemical, and Biological Oceanographic Conditions
  on the Scotian Shelf and in the Eastern Gulf of Maine during 2018. DFO Can.
  Sci. Advis. Sec. Res. Doc. 2020/037. v + 66 p.
}
\note{
\describe{
   \item{time_scale}{Occupation}
   \item{regional_scale}{Section}
   \item{category}{ biological, biochemical }
   }
}
\keyword{datasets}
