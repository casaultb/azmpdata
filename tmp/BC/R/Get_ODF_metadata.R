
# required packages
library(dplyr)
library(oce)
library(readr)
library(tibble)
library(tidyr)

# # read list of ODF files - from R. Pettipas
# odf_file <- read_csv("tmp/BC/data/HL2_odf_list.csv") %>%
#   tidyr::unite(odf_file, odf_dir, odf_file, sep="\\") %>%
#   .$odf_file

# read list of ODF files - from C. Layton
odf_file <- read_csv("tmp/BC/data/listOfStation2Filenames.csv") %>%
  .$filename

# empty tibble
df_odf_metadata <- tibble::tibble()

# loop through each odf file
for(i_file in odf_file){
  tmp <- oce::read.odf(i_file)
  df_odf_metadata <- dplyr::bind_rows(df_odf_metadata,
                                      tibble::tibble(station=tmp@metadata$station,
                                                     latitude=tmp@metadata$latitude,
                                                     longitude=tmp@metadata$longitude,
                                                     cruiseNumber=tmp@metadata$cruiseNumber,
                                                     eventNumber=tmp@metadata$eventNumber,
                                                     eventQualifier=tmp@metadata$eventQualifier,
                                                     startTime=tmp@metadata$startTime,
                                                     sounding=tmp@metadata$sounding,
                                                     cruise=tmp@metadata$cruise,
                                                     filename=tmp@metadata$filename))
}

# save data
o_file <- c("~/Projects/azmpdata/tmp/BC/data/HL2_odf_metadata.RData")
save(file=o_file, list=c("df_odf_metadata"))
