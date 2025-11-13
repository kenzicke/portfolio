################################################################################
# Assignment 4: Spatial data visualization
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 11/12/2025
#
################################################################################

# Load packages
library(EVR628tools)
library(ggspatial)     # To add map elements to a ggplot
library(rnaturalearth) # To add country outlines
library(tidyverse)     # General data wrangling
library(sf)            # Working with vector data
library(terra)         # Working with raster data
library(tidyterra)     # Working with raster data in tidy approach
library(mapview)       # To quickly inspect data
library(janitor)

# Create tribble with coordinates of reefs where larvae were collected
reefs <- tribble(~reef, ~lat, ~lon, ~species,
                 "N. Dry Rocks", 25.13617, -80.28987, "Orbicella faveolata",
                 "Elbow Reef", 25.1407, -80.2565, "Pseudodiploria strigosa",
                 "Rosenstiel School", 25.73248, -80.16324, "NA"
                 )

# Convert tribble to an sf object
reefs_sf <- st_as_sf(x = reefs,
                     coords = c("lon", "lat"),
                     crs = 4326)


# Upload Florida county vector data
FL_counties <- read_sf("data/raw/Florida_County_Boundaries_with_FDOT_Districts_-801746881308969010.gpkg") %>%
  clean_names() %>%
  st_set_geometry("geometry") %>%
  select("name", "first_fips") %>%
  rename(county_name = name,
         county_fips = first_fips)

# Shave down to South Florida only
south_FL <- FL_counties |>
  filter(county_name %in% c("Miami-Dade", "Monroe", "Broward")) |>
  st_crop(xmax = -81,
       xmin = -78,
       ymax = 26,
       ymin = 25)

# Load depth raster
depth <- rast("data/raw/depth_raster.tif") %>%
  crop(south_FL)

mapview(reefs_sf)
# labels need to be nudged independently, mutate reefs_sf tribble
reefs_sf <- reefs_sf |>
  mutate(nudge_x = c(-0.1, 0.05, -0.16),
         nudge_y = c(-0.05, 0.05, -0.05))

figure <- ggplot() +
  geom_spatraster_contour(data = depth,
                          aes(colour = after_stat(level))) +
  geom_sf(data = south_FL) +
  geom_sf(data = reefs_sf,
          shape = 23,
          size = 2.5,
          fill = "pink") +
  geom_sf_label(data = reefs_sf,
               aes(label = reef),
               nudge_x = reefs_sf$nudge_x,
               nudge_y = reefs_sf$nudge_y,
               label.size = 0.5,
               size = 3
               ) +
  theme_classic() +
  labs(title = "Source reefs of coral larvae",
       x = "Longitude",
       y = "Latitude",
       colour = "Depth (m)",
       caption = "Coral gametes were collected from reefs off of Key Largo,
       then ransported and fertilized at the Rosenstiel School.
       This data was created by KMC.                    ") +
  annotation_north_arrow(location = "tl") +
  annotation_scale(location = "bl")

figure
ggsave(filename = "results/img/map.pdf", plot = figure)
