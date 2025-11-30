################################################################################
# Functions and for loops exercise
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 11/18/2025
#
#
################################################################################
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(EVR628tools)


# User defined functions
# Build function that does the above cleaning of coords based on res
clean_coords <- function(x, res) {
  mult <- ifelse(str_detect(x, "N|E"), 1, -1)
  coord <- as.numeric(str_remove_all(x, "[:alpha:]"))
  out <- (mult * coord) + (res / 2)
  return(out)
}

## Load data -------------------------------------------------------------------
wcpfc <- read_csv("data/raw/WCPFC_S_PUBLIC_BY_1x1_MM_5/WCPFC_S_PUBLIC_BY_1x1_MM.CSV")

# PROCESSING ###################################################################

## Clean data -------------------------------------------------------------------
wcpfc_clean <- wcpfc |>
  select(year = yy,
         lat = lat_short,
         lon = lon_short,
         days) |>
  # WCPFC reports "the latitude of the south-west corner"
  # We need to fix that
  mutate(
    lat = clean_coords(lat, res = 1),
    lon = clean_coords(lon, res = 1))

wcpfc_clean

# Exercise 2 -------------------------------------------------------------------

# Load data
data("data_lionfish")

# This is the verbose way
p1 <- data_lionfish %>%
  filter(site == "Paraiso") %>%
  ggplot(aes(x = total_length_mm)) +
  geom_histogram(binwidth = 50)

p2 <- data_lionfish %>%
  filter(site == "Canones") %>%
  ggplot(aes(x = total_length_mm)) +
  geom_histogram(binwidth = 50)

p3 <- data_lionfish %>%
  filter(site == "Paamul") %>%
  ggplot(aes(x = total_length_mm)) +
  geom_histogram(binwidth = 50)

# Tedious.. Let's create a function instead
site_histogram <- function(data, my_site) {
  plot <- data %>%
    filter(site == my_site) %>%
    ggplot(aes(x = total_length_mm)) +
    geom_histogram(binwidth = 50)

  return(plot)
}

site_histogram(data = data_lionfish, my_site = "Paraiso")

# Create for loop to generate plot for all sites

# How many unique sites are there?
length(unique(data_lionfish$site))

for (site in unique(data_lionfish$site)) {
  print(site)
  Sys.sleep(2) # wait for two seconds
}

for (site in unique(data_lionfish$site)) {
  p <- site_histogram(data = data_lionfish, my_site = site)
  ggsave(plot = p,
         filename = paste0("results/img/", site, ".png"))
}

# Iterating with map in the tidyverse
my_plots <- map(.x = unique(data_lionfish$site),
    .f = site_histogram,
    data = data_lionfish)
