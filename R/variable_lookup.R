#' Search through azmpdata
#'
#' Search through azmpdata datasets by keywords. Default searches through all
#' dataset variable names, but options (`help_search`) can be used to search
#' through all `azmpdata` help documentation text including variable definitions
#' and metadata.
#'
#' @param keywords Search keywords (if using multiple, create a vector of character strings using `c()`)
#' @param search_help a logical value determining whether or not help documentation text should also be searched
#' @param lib.loc (optional) passed to find.package to find help documentation
#'   through which to search - a character vector describing the location of R
#'   library trees to search through, or NULL. The default value of NULL
#'   corresponds to checking the loaded namespace, then all libraries
#'   currently known in .libPaths().
#' @examples
#' \dontrun{
#' res <- variable_lookup('nitrate')

#' res2 <- variable_lookup("nitrate", search_help = T)
#' }
#'
#' @import dplyr
#' @importFrom tibble tibble
#' @importFrom stringr str_extract
#' @importFrom utils capture.output help ls.str data
#'
#'
#' @export
#'
#'
variable_lookup <- function(keywords, search_help = FALSE, lib.loc = NULL){


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

 # deprecated this method in favor of less buggy new version below
    #function from github
    # https://stackoverflow.com/questions/9192589/how-can-i-extract-text-from-rs-help-command
    # this function only works if the package is found in the actual library and not the unbuilt version from github
  # extract_help <- function(pkg, fn = NULL, to = c("txt", "html", "latex", "ex"), lib.loc = NULL)
  # {
  #   to <- match.arg(to)
  #   rdbfile <- file.path(find.package(pkg, lib.loc = lib.loc), "help", pkg)
  #   rdb <- tools:::fetchRdDB(rdbfile, key = fn)
  #   convertor <- switch(to,
  #                       txt   = tools::Rd2txt,
  #                       html  = tools::Rd2HTML,
  #                       latex = tools::Rd2latex,
  #                       ex    = tools::Rd2ex
  #   )
  #   f <- function(x) capture.output(convertor(x))
  #   if(is.null(fn)) lapply(rdb, f) else f(rdb)
  # }
  # d <- extract_help(pkg = 'azmpdata')


  ## attempt to work around bug here function above can't find built package with help file

    # use function from utils which is not exported
    # https://rdrr.io/cran/shinyAce/src/R/utils.R
    .utils <- asNamespace("utils")
    get_help_file <- function(...) {
      dots <- list(...)
      if (is.character(dots$package) && nchar(dots$package) == 0)
        dots$package <- NULL

      tryCatch({
        h <- do.call(help, dots)
        if (length(h) > 1) h <- do.call(structure, c(h[1], attributes(h)))
        if (!length(h)) NULL
        else .utils$.getHelpFile(h)
      }, error = function(e) {
        #shinyAce_debug("Error while trying to retrieve help files: \n", e$message)
        NULL
      })
    }


  d <- ls.str('package:azmpdata') # sometimes this pulls other libraries? TODO fix this bug

  help_list <- list()
  for(i in 1:length(d)){
    # help_list[[i]] <- d[i] %>%
      # help(azmpdata)%>%
      #utils:::.getHelpFile()
      help_list[[i]] <- get_help_file(d[i]) # this solution avoids build check error but slows down SIGNIFICANTLY
  }
  names(help_list) <- d



   # original solution from stack! (if you want to target search to specific sections of help file)
  # lsf.str("package:azmpdata") %>%
  #   help("azmpdata") %>%
  #   utils:::.getHelpFile() %>%
  #   keep(~attr(.x, "Rd_tag") == "\\format") %>%
  #   map(as.character) %>%
  #   flatten_chr() %>%
  #   paste0(., collapse="")lsf.str("package:azmpdata") %>%
  #   help("azmpdata") %>%
  #   utils:::.getHelpFile() %>%
  #   keep(~attr(.x, "Rd_tag") == "\\format") %>%
  #   map(as.character) %>%
  #   flatten_chr() %>%
  #   paste0(., collapse="")



  d_ans <- list()
  for(i in 1:length(keywords)){
  ind <- grep(help_list, pattern = keywords[[i]], ignore.case = TRUE)
  d_ans[[i]] <- names(help_list)[ind]
  }

  names(d_ans) <- keywords
  # pad with NAs for dataframe
  ll <- lengths(d_ans)
  if(diff(range(ll)) != 0){
    lmax <- max(ll)
    ddf <- as.data.frame(lapply(d_ans, `length<-`, lmax))

  }else{
  ddf <- as.data.frame(d_ans)
  }
  ddf <- tidyr::gather(ddf, key = keyword)


  help_tb <- data.frame(keyword = ddf$keyword,
                        variable = NA,
                        dataframe = ddf$value)

  tb_match <-
    full_join(tb_match, help_tb)

  return(tb_match)

} # end else statement if help is true

}
