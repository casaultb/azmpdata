#' Search through azmpdata
#'
#' Search through azmpdata datasets by keywords. Defualt searches through all
#' dataset variable names, but options (`help_search`) can be used to search
#' through all `azmpdata` help documentation text including variable definitions
#' and metadata.
#'
#' @param keywords Search keywords (if using multiple, create a vector of character strings using `c()`)
#' @param search_help a logcial value determining whether or not help documentation text should also be searched
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
  # in development

  # search through help files

  # # load all help files
  # datafile <- system.file('man', package = 'azmpdata')
  #
  # # parse help text
  # dd <- roxygen2::parse_file(datafile)
  #
  # # name each chunk based on dataframe name
  # for(i in 1:length(dd)){
  #   names(dd)[i] <- dd[[i]]$call
  # }

    #function from github
    # https://stackoverflow.com/questions/9192589/how-can-i-extract-text-from-rs-help-command
  extract_help <- function(pkg, fn = NULL, to = c("txt", "html", "latex", "ex"))
  {
    to <- match.arg(to)
    rdbfile <- file.path(find.package(pkg), "help", pkg)
    rdb <- tools:::fetchRdDB(rdbfile, key = fn)
    convertor <- switch(to,
                        txt   = tools::Rd2txt,
                        html  = tools::Rd2HTML,
                        latex = tools::Rd2latex,
                        ex    = tools::Rd2ex
    )
    f <- function(x) capture.output(convertor(x))
    if(is.null(fn)) lapply(rdb, f) else f(rdb)
  }

  d <- extract_help(pkg = 'azmpdata')

  d_ans <- list()
  for(i in 1:length(keywords)){
  d_ans[[i]] <- grep(d, pattern = keywords[[i]])
  }
  names(d_ans) <- keywords
  ddf <- as.data.frame(d_ans)
  ddf <- tidyr::gather(ddf, key = keyword)


  help_tb <- data.frame(keyword = ddf$keyword,
                        variable = NA,
                        dataframe = names(d)[ddf$value])

  tb_match <-
    full_join(tb_match, help_tb)

  return(tb_match)

} # end else statement if help is true

}
