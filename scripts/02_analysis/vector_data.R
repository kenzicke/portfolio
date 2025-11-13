################################################################################
# Vector Data Lesson
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 10/30/2025
#
################################################################################

# Load packages
library(EVR628tools)
library(tidyverse)
library(janitor)
library(sf)
library(rnaturalearth)
library(mapview)
library(EVR628tools)

FL_counties <- read_sf("data/raw/Florida_County_Boundaries_with_FDOT_Districts_-801746881308969010.gpkg") %>%
  clean_names() %>%
  st_set_geometry("geometry") %>%
  select("name", "first_fips") %>%
  rename(county_name = name,
         county_fips = first_fips)

# Insepct counties
dim(FL_counties)
colnames(FL_counties)

# Visualize
plot(FL_counties, max.plot = 1)
mapview(FL_counties, max.plot = 1)

# Way to quickly glimpse data frame by removing spatial data
FL_counties %>% st_drop_geometry()

# Load hurricane data
data("data_hurricanes")

dim(data_hurricanes)
colnames(data_hurricanes)

mapview(data_hurricanes)

# Join the two spatial datsets where they intersect
county_hur <- st_join(x = FL_counties,
                      y = data_hurricanes) %>%
  group_by(county_name, county_fips) %>%
  summarize(n_storms = n_distinct(name,
                                  na.rm = TRUE))

# Visualize hurricane exposure by county
ggplot(data = county_hur) +
  geom_sf(aes(fill = n_storms),
          color = "black",
          linewidth = 0.1) +
  #them_void() +
  theme_minimal()


# Part 2: Spatial filter
# Which hurricanes affected FL counties?
FL_hurricanes <- st_filter(x = data_hurricanes,
                           y = FL_counties) %>%
  st_crop(FL_counties)

ggplot(FL_hurricanes) +
  geom_sf(data = county_hur, aes(fill = n_storms),
          color = "black",
          linewidth = 0.1) +
  scale_fill_continuous(type = "viridis") +
  geom_sf(aes(color = name)) +
  theme_minimal() +
  labs(x = "Lon", y = "Lat", title = "Storm exposure by county",
       subtitle = "Named storms between 2022 and 2024",
       color = "Storm name",
       fill = "# storms")

mapview(FL_hurricanes)

# What are min and max coordinates for FL
st_bbox(FL_counties) # Bounding box also listed at top of dataframe


