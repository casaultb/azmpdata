# load and pre process the carbonate chemistry variable data

library(tidyverse)
library(here)

data <- readxl::read_xlsx(here('inst', 'extdata', 'oa', 'MAR_all_depths_Means_Climatologies_Anomalies.xlsx'))

# only include mean statistics
Derived_Annual_Carbonate <- data %>%
  select(-"Region",-contains("Anom"), -contains("Clim"))


# rename columns
Derived_Annual_Carbonate <- Derived_Annual_Carbonate %>%
  rename(
    year = Year,
    section_name = Section_Name,
    depth_m = Depth,
    mean_TA_umolkg = mean_TA,
    mean_DIC_umolkg = mean_DIC,
    mean_pH_total = mean_pHt,
    mean_pCO2_uatm = mean_pCO2,
    mean_substrate_inhibitor_ratio = mean_SIR,
    mean_omega_aragonite = mean_OmegaAragonite,
    mean_omega_calcite = mean_OmegaCalcite,
    mean_carbonate_system_vulnerability_index = mean_CSVI
  )


# save as csv
readr::write_csv(Derived_Annual_Carbonate, "inst/extdata/csv/Derived_Annual_Carbonate.csv")

# save as rda
usethis::use_data(Derived_Annual_Carbonate, overwrite = TRUE)
