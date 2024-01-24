

# load cruise lookup table


# load odf metadata
load("~/Projects/azmpdata/tmp/BC/data/HL2_odf_metadata.RData")

# load biochem metadata
load("~/Projects/AZMP_Reporting_2021/data/biochem/HL2/PL/PL_Zoo_Metadata_HL2_20210316.RData")
df_biochem_metadata <- df

# clean up
rm(df, sql_str)
