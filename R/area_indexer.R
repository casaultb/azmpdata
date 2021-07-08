area_indexer <- function(){
  area_year_df <- data.frame(year = integer(), dataframe = character(), area=character(), section=character(), station=character() )
  area_year_fields <- c("year", "area","section", "station")
  res <- data(package = 'azmpdata')
  file_names <- res$results[,3]
  for(i_file in file_names){
    df <- get(i_file)
    var_names <- names(df)
    if (area_year_fields[1] %in% var_names & any(area_year_fields[2:length(area_year_fields)] %in% var_names)){
      this_df <- df[,names(df) %in% area_year_fields]
      this_df$dataframe <- i_file
      this_df[setdiff(names(area_year_df), names(this_df))]<-NA
      this_df <- this_df[,c("year", "dataframe","area","section", "station")]
      area_year_df <- rbind.data.frame(area_year_df,this_df)
      rm(list = c("var_names","this_df"))
    }
    remove(i_file)
  }
  area_year_df= tidyr::gather(area_year_df, areaType, areaname, area, section, station)
  area_year_df <- area_year_df[!is.na(area_year_df$areaname),]
  return(area_year_df)
}
