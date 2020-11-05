#' Plot azmpdata dataset variable
#'
#' Plot a variable from a given "annual means" dataset.
#'
#' @param df_data dataframe loaded from azmpdata
#' @param variable variable from dataframe to be plotted
#'
#' @import ggplot2
#' @import dplyr
#' @return ggplot2 object
#' @export
#'
#'
plot_annual_means <- function(df_data, variable) {

  # prepare data
  # df_data <- ls_data$data # not relevant to new data format
  orig_data <- df_data

  # check that data is annual # TODO improve system
  if('month' %in% names(df_data) | 'day' %in% names(df_data)){
    stop('Data provided is not annual scale! Please use a different plotting function or convert data')
  }

  # check variable
  if(!variable %in% names(df_data)){
    stop('Variable not found in dataframe provided!')
  }


  # check for metadata
  metanames <- c('year', 'month', 'day', 'area', 'section', 'station' )
  meta_df <- names(df_data)[names(df_data) %in% metanames]

  group <- meta_df[meta_df != 'year']

  df_data <- df_data %>%
    dplyr::select(., all_of(meta_df), all_of(variable) ) %>%
    dplyr::rename(., 'value' = all_of(variable) ) %>%
    dplyr::rename(., 'group' = all_of(group))

  # set x-axis
  x_limits <- c(min(df_data$year)-1, max(df_data$year)+1)
  x_breaks <- seq(x_limits[1], x_limits[2], by=1)
  x_labels <- x_breaks

  # set y-axis
  y_limits <- c(min(df_data$value, na.rm=T) - 0.1*mean(df_data$value, na.rm=T),
                max(df_data$value, na.rm=T) + 0.1*mean(df_data$value, na.rm=T))

  # plot data
  p <-  ggplot2::ggplot() +
    # plot data - line
    ggplot2::geom_line(data=df_data,
                       mapping=ggplot2::aes(x=year, y=value, col = group),
                        size=.5) +
    # plot data - dots
    ggplot2::geom_point(data=df_data,
                       mapping=ggplot2::aes(x=year, y=value, col = group),
                        size=1) +
    # set coordinates system and axes
    ggplot2::coord_cartesian() +
    ggplot2::scale_x_continuous(name="Year", limits=x_limits, breaks=x_breaks, labels=x_labels, expand=c(0,0)) +
    ggplot2::scale_y_continuous(name="", limits=y_limits, expand=c(0,0))

  # customize theme
  p <- p +
    ggplot2::theme_bw() +
    ggplot2::ggtitle(paste(group, variable, sep=" : " )) +
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
