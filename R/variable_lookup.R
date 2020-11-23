#' Search through RDA variable names
#'
#' @param keywords Search keywords
#'
#'
#' @import dplyr
#' @import tibble
#' @import stringr
#'
#'
#'
#' @export
#'
#'
variable_lookup <- function(keywords, search_help = FALSE){


  # declare empty data frame
  tb_main <- tibble::tibble(variable=character(0),
                            dataframe=character(0)
                            #,
                            #file=character(0)
                            )

  # get list of rda files
  # this method doesn't work through colab
  # fp <- system.file('data', package = 'azmpdata') # make generic file path
  # file_names <- list.files(fp, pattern="*.rda", full.names=T)
  #
  # TODO find a method that works when package is downloaded to colab, will be more robust

  res <- data(package = 'azmpdata')

  file_names <- res$results[,3]

  # loop through files

  for(i_file in file_names){
    df <- get(i_file)
    #load(i_file, tmp_env <- new.env())
    # get list of data frames in each rda file
    # removed: there should only be one dataframe in each datafile
    # df_names <- ls(tmp_env)
    # loop through data frames
    #for(i_df in df_names){
      #var_names <- names(get(i_df, envir=tmp_env))
      var_names <- names(df)
      # append to tb_main
      tb_main <- dplyr::bind_rows(tb_main,
                                  tibble::tibble(variable=var_names,
                                                 dataframe=i_file #,
                                                 #file=basename(i_file)
                                                 ))
    #}
      # clean up
      remove(i_file)
  }

  # clean up
  # rm("tmp_env")

  # list of variable names not to match with
  no_match <- c("id")

  # rearrange data frame
  tb_main <- tb_main %>%
    dplyr::filter(!(variable %in% no_match)) %>%
    dplyr::distinct() %>%
    dplyr::arrange(variable)

  # find matches (only searches variable names)
  names(keywords) <- tolower(keywords)
  tb_match <- tb_main %>%
    dplyr::mutate(tmp_variable = tolower(variable)) %>%
    dplyr::mutate(keyword = stringr::str_extract(tmp_variable, paste(tolower(keywords), collapse="|"))) %>%
    dplyr::mutate(keyword = keywords[keyword]) %>%
    dplyr::filter(keyword %in% keywords) %>%
    dplyr::arrange(keyword, variable) %>%
    dplyr::select(keyword, variable, dataframe)

  # output
  if(search_help == FALSE){
  return(tb_match)
  }else{
  # development

  # search through help files

  # load all help files
  datafile <- system.file('R/data.r', package = 'azmpdata')

  # parse help text
  dd <- parse_file(datafile)

  # name each chunk based on dataframe name
  for(i in 1:length(dd)){
    names(dd)[i] <- dd[[i]]$call
  }


} # end else statement if help is true

}
