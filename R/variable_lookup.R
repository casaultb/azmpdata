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
variable_lookup <- function(keywords){

  # # required packages
  # library(dplyr)
  # library(tibble)
  # library(stringr)

  # declare empty data frame
  tb_main <- tibble::tibble(variable=character(0),
                            dataframe=character(0),
                            file=character(0))

  # get list of rda files
  file_names <- list.files("data/", pattern="*.rda", full.names=T)

  # loop through files
  for(i_file in file_names){
    load(i_file, tmp_env <- new.env())
    # get list of data frames in each rda file
    df_names <- ls(tmp_env)
    # loop through data frames
    for(i_df in df_names){
      var_names <- names(get(i_df, envir=tmp_env))
      # append to tb_main
      tb_main <- dplyr::bind_rows(tb_main,
                                  tibble::tibble(variable=var_names,
                                                 dataframe=i_df,
                                                 file=basename(i_file)))
    }
  }

  # clean up
  rm("tmp_env")

  # list of variable names not to match with
  no_match <- c("id")

  # rearrange data frame
  tb_main <- tb_main %>%
    dplyr::filter(!(variable %in% no_match)) %>%
    dplyr::distinct() %>%
    dplyr::arrange(variable)

  # find matches
  # keywords <- c("Chl", "no3")
  names(keywords) <- tolower(keywords)
  tb_match <- tb_main %>%
    dplyr::mutate(tmp_variable = tolower(variable)) %>%
    dplyr::mutate(keyword = stringr::str_extract(tmp_variable, paste(tolower(keywords), collapse="|"))) %>%
    dplyr::mutate(keyword = keywords[keyword]) %>%
    dplyr::filter(keyword %in% keywords) %>%
    dplyr::arrange(keyword, variable) %>%
    dplyr::select(keyword, variable, dataframe, file)

  # output
  return(tb_match)
}
