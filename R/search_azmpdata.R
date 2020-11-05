#' Search the azmpdata dataset
#'
#' Find variables in the azmpdata dataset that match a given keyword.
#'
#' @param str string (lowercase only)
#'
#' @importFrom utils data
#' @importFrom stringr str_remove
#' @return character vector
#' @export
#'
#' @examples
#' search_azmpdata("chlorophyll")
search_azmpdata <- function(str) {

  # lookup .rda files in /data
  rda_list <- utils::data(package="azmpdata")
  rda_list <- rda_list$results[,3]

  # lookup files that match "str" keyword, and remove .rda extension
  matches <- stringr::str_remove(rda_list[stringr::str_detect(rda_list, str)], ".rda")

  # output
  if (length(matches) == 0) {
    matches <- paste("No variables matching ", str, ".", sep="")
  }

  print(matches)
}
