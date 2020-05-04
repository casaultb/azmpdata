#' Plot azmpdata dataset variable
#'
#' Plot a variable from a given "annual means" dataset.
#'
#' @param ls_data list
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' "No example"
plot_annual_means <- function(ls_data) {

  # prepare data
  df_data <- ls_data$data

  # set x-axis
  x_limits <- c(min(df_data$year)-1, max(df_data$year)+1)
  x_breaks <- seq(x_limits[1], x_limits[2], by=1)
  x_labels <- x_breaks

  # set y-axis
  y_limits <- c(min(df_data$value, na.rm=T) - 0.1*mean(df_data$value, na.rm=T),
                max(df_data$value, na.rm=T) + 0.1*mean(df_data$value, na.rm=T))

  # ploat data
  p <-  ggplot2::ggplot() +
    # plot data - line
    ggplot2::geom_line(data=df_data,
                       mapping=ggplot2::aes(x=year, y=value),
                       show.legend=F,
                       colour="black", size=.5) +
    # plot data - dots
    ggplot2::geom_point(data=df_data,
                       mapping=ggplot2::aes(x=year, y=value),
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
