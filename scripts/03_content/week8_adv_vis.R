################################################################################
# Scaling up data visualization notes 
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 10/7/2025
#
# Follow along coding. Create complex figures, develop simple documents with
# 
################################################################################

# Load packages
library(tidyverse)
library(EVR628tools)

# Load data 
data(data_lionfish)

# Visualize 
## Plot lionfish data 
ggplot(data_lionfish,
                 aes(x = total_length_mm, 
                     y = total_weight_gr)) + # Option plus UP Arrow moves chunks of code up
  geom_vline(xintercept = c(100, 200),
             linetype = "dashed") +
  geom_smooth(colour = "black",              # Don't use aes to just edit look of line
              linetype = "dashed") +
  geom_point(aes(color = size_class)) +      # Put color inside geom_point so that geom_smooth applies to all data
  labs(x = "Total length (mm)", 
       y = "Total weight (gr)",
       color = "Size class") +
  scale_color_manual(values = palette_UM(3)) +
  theme_bw(base_size = 16) + # base_size makes default font larger
  theme(legend.position = "inside",
        legend.position.inside = c(0,1),
        legend.justification.inside = c(0,1),
        legend.background = element_rect(fill = "transparent", color = "black"))
  

# Exercise 2 
# Build a timeseries with overlapping thresholds 
data("data_mhw_ts")

ggplot(data = data_mhw_ts,
       mapping = aes(x = date, y = temp)) +
  geom_line(mapping = aes(y = thresh), color = "red") +
  geom_line(mapping = aes(y = seas), color = "blue") +
  geom_line() +
  labs(x = "Date", y = "Temperature (°C)") +
  theme_minimal(base_size = 13)


# Exercise 3 
## Lollipop plot 
data("data_mhw_events")

p <- ggplot(data = data_mhw_events,
       mapping = aes(x = date_peak,
                     y = intensity_max,
                     color = intensity_cumulative)) + 
  geom_point() +
  geom_linerange(mapping = aes(ymin = 0, ymax = intensity_max)) +
  scale_color_gradient(low = "gray90", high = "red") +
  theme_bw() +                                # Put general theme above theme modificaitons below
  theme(legend.position = "bottom",           # Otherwise theme_bw would override our customizations
        legend.title.position = "top",
        legend.key.width = unit(x = 1.05, units = "cm")) +
  labs(x = "Date", 
       y = "MHW intensity (°C)",
       color = "MHW cum. intensity (°C days)")
ggsave(plot = p,
       filename = "results/img/mhw_events_plot.png",
       height = 3,
       widtch = 4.5)

# To size figures to a specific aspect ratio, first save as png, mess with
# aspect ratio until you like the look of it. If you have the PNG open,
# it will automaticlaly adjust everytime you change and run the code so dont
# have to close and reopen a bunch of times. Once you like it, save as PDF instead

# When building a figure, edit based on the plots tab, not zoomed in. 