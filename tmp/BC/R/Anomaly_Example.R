
# load required
library(dplyr)
library(tidyr)

# load data (from rda file)
load("~/Projects/azmpdata/data/Derived_Annual_Sections.rda")

# convert data to long format
Derived_Annual_Sections <- Derived_Annual_Sections %>%
  tidyr::gather(variable, value, 3:9)

# calculate climatology
df_climatology <- Derived_Annual_Sections %>%
  dplyr::filter(year >= 1999 & year <= 2015) %>%
  dplyr::group_by(section, variable) %>%
  dplyr::summarise(mean=mean(value, na.rm=T), sd=sd(value, na.rm=T)) %>%
  dplyr::ungroup()

# calculate anomalies
Derived_Annual_Sections_Anomalies <- dplyr::left_join(Derived_Annual_Sections,
                                 df_climatology,
                                 by = c("section", "variable")) %>%
  dplyr::mutate(value = (value - mean)/sd) %>%
  dplyr::select(section, variable, year, value)

# convert data to wide format
Derived_Annual_Sections_Anomalies <- Derived_Annual_Sections_Anomalies %>%
  tidyr::spread(variable, value)

