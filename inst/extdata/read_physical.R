#' @title Read in physical data
#'
#' @description This function reads in all data associated with the physical oceanographic annual reporting data.
#'
#' @details This function reads in all data associated with the physical oceanographic annual reporting data as
#' a list with metadata information and associated data.
#'
#' @param file a connection or a character string giving the name of the file to read.
#'
#' @author Chantelle Layton
#'

read.physical <- function(file){
  # 1. read in data with read lines

  rl <- readLines(file)

  # 2. find which lines start with a #
  #    these are the metadata lines

  metaLines <- grep('^\\#', rl)

  # 3. read in the data, the start line is the next one after the final metadata
  #    line and always has a 'header'

  data <- utils::read.table(file, header = TRUE, skip = metaLines[length(metaLines)], sep = ',') #  colClasses = numeric breaks some files with dates // , colClasses = 'numeric'

  # 4. get all the metadata

  md <- rl[metaLines]
  # remove the hash
  md <- trimws(gsub('\\#', '', md))
  # split it up into names and data
  ssmd <- strsplit(md, split = ': ')
  # get metadatanames from the first index,
  #   and then paste the data in the event that there was a ': ' in the data portion
  metaDataNames <- unlist(lapply(ssmd, function(k) gsub('\\:', '', k[1])))
  # we want the metadata names to be nice and in camel case for easy use
  camelCase <- function(x){
    s <- strsplit(x, "[^[:alnum:]]")
    sapply(s, function(y) {
      if (any(is.na(y))) {
        y
      }
      else {
        first <- substring(y, 1, 1)
        first <- tolower(first)
        first[-1] <- toupper(first[-1])
        paste(first, substring(y, 2), sep = "", collapse = "")
      }
    })
  }
  metaDataNames <- unlist(lapply(metaDataNames, camelCase))
  metaDataData <- unlist(lapply(ssmd, function(k) ifelse(length(k) == 1, '',paste0(k[2:length(k)], collapse = ''))))
  names(metaDataData) <- metaDataNames
  d <- as.list(metaDataData)
  d[['data']] <- data

  d
}
