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
library(cowplot)
library(patchwork)
library(ggridges)

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

p1 <- ggplot(data = data_mhw_ts,
       mapping = aes(x = date, y = temp)) +
  geom_line(mapping = aes(y = thresh), color = "red") +
  geom_line(mapping = aes(y = seas), color = "blue") +
  geom_line() +
  labs(x = "Date", y = "Temperature (°C)") +
  theme_minimal(base_size = 13)


# Exercise 3 
## Lollipop plot 
data("data_mhw_events")

p2 <- ggplot(data = data_mhw_events,
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
ggsave(plot = p2,
       filename = "results/img/mhw_events_plot.png",
       height = 3,
       widtch = 4.5)

# To size figures to a specific aspect ratio, first save as png, mess with
# aspect ratio until you like the look of it. If you have the PNG open,
# it will automaticlaly adjust everytime you change and run the code so dont
# have to close and reopen a bunch of times. Once you like it, save as PDF instead

# When building a figure, edit based on the plots tab, not zoomed in. 



# Build a data. frame by grouping year and fishery 
data("data_fishing")

total_catch <-  data_fishing |> 
  group_by(year, fishery) |> 
  summarize(total_catch = sum(catch))

ggplot(data = total_catch,
       aes(x = year, 
           y = total_catch)) +
  geom_line() +
  geom_point() +
  facet_wrap(~fishery, 
             ncol = 1, 
             scales = "free_y")

# Example of summarizing data directly in the figure 
## Using summary stats in ggplot 
ggplot(data = data_fishing,
       aes(x = year, 
           y = catch)) +
  stat_summary(geom = "line",
               fun = sum) +         # Can layer stat_summary and can use to visuzlze and summary data without creating a bunch of sub data sets
  stat_summary(geom = "point",
               fun = sum) +
  facet_wrap(~fishery, 
             ncol = 1, 
             scales = "free_y")
        

##Facet wrap 

data("data_kelp")
tidy_kelp <- data_kelp |> 
  filter(genus_species %in% c("Embiotoca jacksoni",
                              "Embiotoca lateralis"),
         location %in% c("ASA", "ERE", "ERO")) |> 
  pivot_longer(cols = starts_with("TL_"),
               names_to = "total_length",
               values_to = "N",
               values_drop_na = T) |> 
  group_by(location, site, transect, genus_species) |> 
  summarize(total_N = sum(N)) |> 
  group_by(location, site, genus_species) |> 
  summarize(mean_N = mean(total_N))

p3 <- ggplot(data = tidy_kelp,
       mapping = aes(x = site, y = mean_N)) +
  geom_col(color = "black") +
  facet_grid(location ~ genus_species) +
  labs(x = "Site", y = "Mean (org / tranect)")

# Combining plots with Cowplot 
P1 <- plot_grid(p1, p2, 
          ncol = 1,
          rel_heights = c(1, 1.5),
          labels = c("B", "C"),
          label_x = 0.01)      # "AUTO" or "auto" to automatically assign 
P1

plot_grid(p3, P1, ncol = 2, labels = "A")

# Combining plots with patchwork 
p1 + p2
p1 / p2
p3 + (p1 / p2)





# Justifying the use of ggridges 
data("data_lionfish")

ggplot(data_lionfish,
       aes(x = total_length_mm)) +   # Try group by site, ugly
  geom_density() +                    # Try facet by site
  facet_wrap(~site, scale = "free_y", ncol = 1). # Ugly

# Now use ggridges 
ggplot(data_lionfish,
       aes(x = total_length_mm,
           y = site,
           fill = site)) +
  geom_density_ridges(alpha = 0.5)
# facet_wrap(~size_class)



# special characters for plots 
# Subindeces go inside "[]"
# superscripts after "^"
# Use "~" for spaces
# greek letters directly typed 
# ?plotmaths for a full list


data <- read_csv(file = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.csv",
                 skip = 32, 
                 col_names = c("year", "month", "day", "decimal", "co2_ppm"))

ggplot(data,
       aes(x = decimal, y = co2_ppm)) + 
  geom_line() +
  theme_minimal(base_size = 10) +
  labs(x = "Year",
       y = quote(~CO[2]~concentration~(ppm)),
       caption = "Data from the Global Monitoring Laboratory")

?plotmath
