#' Plot azmpdata dataset variable
#'
#' Plot a variable from a given "timeseries" dataset.
#'
#' @param df_data dataframe loaded from azmpdata
#' @param variable variable from dataframe to be plotted
#'
#' @importFrom tidyr unite
#' @import dplyr
#' @importFrom tibble tibble
#' @import ggplot2
#'
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' "No example"
plot_timeseries <- function(df_data, variable) {

  orig_data <- df_data

  # check that data is correct scale

  if(!'month' %in% names(df_data) && !'day' %in% names(df_data)){
    stop('Data provided is not at occupation scale! Please use a different plotting function or convert data')
  }
  # check variable
  if(!variable %in% names(df_data)){
    stop('Variable not found in dataframe provided!')
  }

  # check for metadata
  metanames <- c('year', 'month', 'day', 'area', 'section', 'station' )
  meta_df <- names(df_data)[names(df_data) %in% metanames]

  group <- meta_df[!meta_df %in% c('year', 'month', 'day')]

  df_data <- df_data %>%
    dplyr::select(., all_of(meta_df), all_of(variable) ) %>%
    dplyr::rename(., 'value' = all_of(variable) ) %>%
    dplyr::rename(., 'group' = all_of(group)) #TODO some dataframes do not have groups!?


  # prepare data
  df_data <- df_data %>%
    tidyr::unite(date, year, month, day, sep="-", remove=F) %>%
    dplyr::mutate(year_dec=lubridate::decimal_date(lubridate::ymd(date))) %>%
    dplyr::select(year, year_dec, value)

  # set x-axis
  x_limits <- c(min(df_data$year), max(df_data$year)+1)
  x_breaks <- seq(x_limits[1]+.5, x_limits[2]-.5, by=1)
  x_labels <- x_breaks-.5

  # set y-axis
  y_limits <- c(min(df_data$value, na.rm=T) - 0.1*mean(df_data$value, na.rm=T),
                max(df_data$value, na.rm=T) + 0.1*mean(df_data$value, na.rm=T))

  ## set shaded rectangles breaks
  df_rectangles <- tibble::tibble(xmin=seq(x_limits[1], x_limits[2], by=2),
                                  xmax=seq(x_limits[1], x_limits[2], by=2)+1,
                                  ymin=y_limits[1], ymax=y_limits[2])

  # plot data
  # TODO need to add groupings and legend
  p <-  ggplot2::ggplot() +
    # plot shaded rectangles
    ggplot2::geom_rect(data=df_rectangles,
                       mapping=ggplot2::aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),
                       show.legend=F,
                       fill="gray90", alpha=0.8) +
    # plot data - line
    ggplot2::geom_line(data=df_data,
                       mapping=ggplot2::aes(x=year_dec, y=value),
                       show.legend=F,
                       colour="black", size=.5) +
    # plot data - dots
    ggplot2::geom_point(data=df_data,
                        mapping=ggplot2::aes(x=year_dec, y=value),
                        show.legend=F,
                        colour="black", size=1) +
    # set coordinates system and axes
    ggplot2::coord_cartesian() +
    ggplot2::scale_x_continuous(name="Year", limits=x_limits, breaks=x_breaks, labels=x_labels, expand=c(0,0)) +
    ggplot2::scale_y_continuous(name="", limits=y_limits, expand=c(0,0))

  # customize theme
  p <- p +
    ggplot2::theme_bw() +
    ggplot2::ggtitle(paste(ls_data$dataset, ls_data$variable, ls_data$units, sep=" : " )) +
    ggplot2::theme(
      text=ggplot2::element_text(size=8),
      axis.text.x=ggplot2::element_text(colour="black", angle=90, hjust=0.5, vjust=0.5),
      plot.title=ggplot2::element_text(colour="black", hjust=0, vjust=0, size=8),
      panel.grid.major=ggplot2::element_blank(),
      panel.border=ggplot2::element_rect(size=0.25, colour="black"),
      plot.margin=grid::unit(c(0.1,0.1,0.1,0.1), "cm"))

  # output
  return(p)
}
