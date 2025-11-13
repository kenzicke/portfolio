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

## Load map vector data
florida <- read_sf("data/raw/GOVTUNIT_Florida_State_GPKG/GOVTUNIT_Florida_State_GPKG.gpkg") %>%
  clean_names()

# Create tribble with coordinates of reefs where larvae were collected
reefs <- tribble(~reef, ~lat, ~lon, ~species,
                 "North North Dry Rocks", 25.13617, -80.28987, "Orbicella faveolata",
                 "UM Key Largo", 25.1407, -80.2565, "Pseudodiploria strigosa"
                 )

# Convert tribble to an sf obhject
st_as_sf(x = reefs,
         coords = c("lon", "lat"))

## Load depth raster
depth <- rast("data/raw/depth_raster.tif") %>%
  crop(florida)



ggplot() +
  geom_spatraster(data = depth) +
  geom_sf(data = florida)


