# derived monthly broadscale data
cat('Sourcing Derived_Monthly_Broadscale.R', sep = '\n')
library(dplyr)
library(tidyr)
library(readr)
library(usethis)
library(RCurl)
library(rvest)

# get river flux data
cat('    reading in river flux data', sep = '\n')

webpage <- read_html("https://ogsl.ca/app-debits/en/tables.html")

tbls <- html_nodes(webpage, "table")
tbls_ls <- webpage %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)

# remove model predictions
curr_year <- format(Sys.Date(), '%Y')

idx <- vector()
for (i in 1:length(tbls_ls)){
  names(tbls_ls)[[i]] <- unique(names(tbls_ls[[i]]))
  names(tbls_ls[[i]]) <- c('month', 'river_flux')
  tbls_ls[[i]] <- tbls_ls[[i]][-1,]
  tbls_ls[[i]] <- tbls_ls[[i]] %>% dplyr::mutate(year = names(tbls_ls)[[i]])
  if(names(tbls_ls)[[i]] > curr_year){
    idx <- c(idx, i)
  }
}

data_tbls <- tbls_ls[-idx]

df <- do.call('rbind', data_tbls)
rownames(df) <- NULL
df$year <- as.numeric(df$year)

river_flux <- df %>%
  dplyr::mutate(area = 'Gulf of St. Lawrence')

# assemble data
Derived_Monthly_Broadscale <- dplyr::bind_rows(river_flux)

# save data
# save data to csv
readr::write_csv(Derived_Monthly_Broadscale, "inst/extdata/csv/Derived_Monthly_Broadscale.csv")
# save data to rda
usethis::use_data(Derived_Monthly_Broadscale, overwrite = TRUE)

