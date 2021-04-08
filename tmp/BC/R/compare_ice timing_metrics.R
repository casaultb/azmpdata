# required packages
library(dplyr)
library(tidyr)
library(ggplot2)

##--------------------------------------------------------------
# load data - from Steele
load("~/Projects/Steele/Updated Data/Ice_Timing_20200330.RData")

# clean up
rm(list=setdiff(ls(), "df_norm_anomaly_mean_annual_w"))

# data wrangling
df_data <- df_norm_anomaly_mean_annual_w %>%
  dplyr::filter(region=="GSL_SS") %>%
  dplyr::select(-region) %>%
  dplyr::mutate(label="Steele")

##--------------------------------------------------------------
# load data - from azmpdata
load("~/Projects/azmpdata/data/Ice_Annual_Broadscale.rda")

# data wrangling
Ice_Annual_Broadscale <- Ice_Annual_Broadscale %>%
  dplyr::select(-ice_volume, -ice_area) %>%
  dplyr::rename(day_first=ice_first_day, day_last=ice_last_day, duration=ice_duration) %>%
  tidyr::pivot_longer(cols=c("day_first", "day_last", "duration"),
                      names_to="variable", values_to="value")

# climatology
clim <- Ice_Annual_Broadscale %>%
  dplyr::filter(year>=1999 & year <=2015) %>%
  dplyr::group_by(variable) %>%
  dplyr::summarise(mean=mean(value, na.rm = T), sd=sd(value, na.rm = T)) %>%
  ungroup()

# anomalies
anom <- dplyr::left_join(Ice_Annual_Broadscale,
                         clim, by="variable") %>%
  dplyr::mutate(value=(value-mean)/sd) %>%
  dplyr::select(-mean, -sd) %>%
  tidyr::pivot_wider(names_from="variable", values_from="value") %>%
  dplyr::mutate(label="azmpdata")

# combine data frames
df_data <- dplyr::bind_rows(df_data, anom)

##--------------------------------------------------------------
# plot data - ice duration
p_duration <- ggplot() +
  geom_point(data=df_data,
             mapping=aes(x=year, y=duration, shape=label, colour=label)) +
  scale_shape_manual(values = c(0,1)) +
  scale_color_manual(values=c("blue", "red")) +
  labs(x="Year", y="Normalized Anomaly") +
  ggtitle("Ice duration") +
  theme_bw() +
  theme(
    # axis text
    axis.text.x=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    axis.text.y=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    # border
    panel.border=element_rect(colour="black", size=1),
    legend.title = element_blank()
  )
ggsave("~/Projects/azmpdata/tmp/BC/R/Ice_Duration.png", width=15, height=7.5, units="cm")

# plot data - ice first day
p_first <- ggplot() +
  geom_point(data=df_data,
             mapping=aes(x=year, y=day_first, shape=label, colour=label)) +
  scale_shape_manual(values = c(0,1)) +
  scale_color_manual(values=c("blue", "red")) +
  labs(x="Year", y="Normalized Anomaly") +
  ggtitle("Ice first day") +
  theme_bw() +
  theme(
    # axis text
    axis.text.x=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    axis.text.y=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    # border
    panel.border=element_rect(colour="black", size=1),
    legend.title = element_blank()
  )
ggsave("~/Projects/azmpdata/tmp/BC/R/Ice_First_Day.png", width=15, height=7.5, units="cm")
# ggsave("~/Projects/azmpdata/tmp/BC/R/Ice_First_Day_60d_PhaseShift.png", width=15, height=7.5, units="cm")

# plot data - ice last day
p_last <- ggplot() +
  geom_point(data=df_data,
             mapping=aes(x=year, y=day_last, shape=label, colour=label)) +
  scale_shape_manual(values = c(0,1)) +
  scale_color_manual(values=c("blue", "red")) +
  labs(x="Year", y="Normalized Anomaly") +
  ggtitle("Ice last day") +
  theme_bw() +
  theme(
    # axis text
    axis.text.x=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    axis.text.y=element_text(colour="black", angle=0, hjust=0.5, vjust=0.5),
    # border
    panel.border=element_rect(colour="black", size=1),
    legend.title = element_blank()
  )
ggsave("~/Projects/azmpdata/tmp/BC/R/Ice_Last_Day.png", width=15, height=7.5, units="cm")
