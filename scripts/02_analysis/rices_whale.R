################################################################################
# Raster data exercise - Rice's Whale
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 11/6/2025
#
################################################################################
 # Load packages
library(EVR628tools)   # For fishing effort data and color palettes
library(ggspatial)     # To add map elements to a ggplot
library(rnaturalearth) # To add country outlines
library(tidyverse)     # General data wrangling
library(sf)            # Working with vector data
library(terra)         # Working with raster data
library(tidyterra)     # Working with raster data in tidy approach
library(mapview)       # To quickly inspect data

# Processing
## Create rice whale core habitat vector
whale <- read_sf("data/raw/shapefile_Rices_whale_core_distribution_area_Jun19_SERO/")

## Load depth raster
depth <- rast("data/raw/depth_raster.tif")

## Load map vector data
coast <- ne_countries(country = c("United States of America",
                                  "Mexico",
                                  "Belize",
                                  "Guatemala"))

## Load fishing effort data
data("data_fishing_effort")


mapview(list(whale, coast))
plot(depth)

# Data Wrangling
# Create a new object to contain a raster of fishing effort
effort_raster <- data_fishing_effort |>    # Start with my data.frame
  group_by(lon, lat) |>                    # group by lon and lat
  summarize(hours = sum(effort_hours)) |>  # Calculate total effort by pixel
  rast(crs = "EPSG:4326")                  # Build a raster

plot(effort_raster)

# Calculate total fishing in core habitat
extract(effort_raster, whale,
        fun = sum,
        na.rm = T,
        exact = T)

# Cropping layers
# Crop depth raster
gulf_depth <- crop(depth, extend(effort_raster, 10))

# Crop world vector
gulf_coast <- st_crop(coast, extend(effort_raster, 10))

# Visualize my data
ggplot() +
  geom_spatraster_contour(data = gulf_depth,
                          aes(colour = after_stat(level))) +
  geom_spatraster(data = effort_raster) +
  geom_sf(data = gulf_coast, color = "gray") +
  geom_sf(data = whale,
          fill = "transparent",
          color = "black",
          linewidth = 1) +
  scale_color_viridis_c(option = "mako") +
  scale_fill_viridis_c(option = "C",
                       na.value = "transparent") +
  theme_bw() +
  annotation_north_arrow(location = "tl") +
  annotation_scale(location = "bl")



