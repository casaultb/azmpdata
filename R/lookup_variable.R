# get variable name lookup table


#' Search Variable look-up table
#'
#' @param variable search by variable name
#' @param keyword search for a keyword within variable definitions
#' @param time_scale search by temporal scale (options are 'occupations', 'weekly', 'monthly', 'annual')
#' @param regional_scale search by geographic scale (options are 'sections', 'stations', 'broadscale')
#' @param category search by data category (options are 'physical', 'biochemical', 'phenology', 'zooplankton', 'remote sensing')
#'
#' @return a section of the variable look up table based on search parameters
#' @export
#'
#'
lookup_variable <- function(variable, keyword, time_scale, regional_scale, category ){
  # read in var table

  vartable <- read.csv('inst/extdata/lookup/variable_look_up.csv')

  # see which search terms user has entered
  allterms <- c('variable', 'keyword', 'time_scale','regional_scale', 'category' )
  searchterms <- list()
  termval <- NA
  for (i in 1:length(allterms)){
    term <- allterms[[i]]
    eval(parse(text = paste("if(!missing(",term, ")){termval <- ", term, "}")))
    searchterms[[i]] <- termval
    if(!missing(term)){names(searchterms)[[i]] <- term}
    termval <- NA
  }


  if(!is.na(searchterms$variable)){
    vartable <- vartable[vartable$variable_name == searchterms$variable,]
  }


  if(!is.na(searchterms$keyword)){
    ind <- grep(vartable$variable_definition, pattern = searchterms$keyword)

    vartable <- vartable[ind, ]
  }

  if(!is.na(searchterms$time_scale)){
    vartable <- vartable[vartable$time_scale == searchterms$time_scale,]
  }

  if(!is.na(searchterms$regional_scale)){
    vartable <- vartable[vartable$regional_scale == searchterms$regional_scale,]
  }

  if(!is.na(searchterms$category)){
    vartable <- vartable[vartable$category == searchterms$category,]
  }

  return(vartable)
}
