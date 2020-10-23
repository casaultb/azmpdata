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
#' @examples
lookup_variable <- function(variable, keyword, temporal_scale, geographic_scale, category ){
  # read in var table

  vartable <- read.csv('inst/extdata/lookup/variable_look_up.csv')

  # see which search terms user has entered

  allterms <- c('variable', 'keyword', 'time_scale','regional_scale', 'category' )
  searchterms <- list()
  for (i in 1:length(allterms)){
    term <- allterms[[i]]
    eval(parse(text = paste("if(exists(term)){termval <- ", term, "}")))
    searchterms[[i]] <- termval
    if(exists(term)){names(searchterms)[[i]] <- term}
    termval <- NULL
  }

  if('variable' %in% names(searchterms)){
    vartable <- vartable[vartable$variable_name == searchterms$variable,]
  }


  if('keyword' %in% names(searchterms)){
    ind <- grep(vartable$variable_definition, pattern = searchterms$keyword)

    vartable <- vartable[ind, ]
  }

  if('time_scale' %in% names(searchterms)){
    vartable <- vartable[vartable$time_scale == searchterms$time_scale,]
  }

  if('regional_scale' %in% names(searchterms)){
    vartable <- vartable[vartable$regional_scale == searchterms$regional_scale,]
  }

  if('category' %in% names(searchterms)){
    vartable <- vartable[vartable$category == searchterms$category,]
  }

  return(vartable)
}
