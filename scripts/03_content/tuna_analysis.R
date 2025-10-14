################################################################################
# Blue Fin Tuna exercise 
################################################################################
#
# Kenzie Cooke
# kmc390@miami.edu
# 9/25/2025
#
# Class exercise. How much money did purse seine fishermen make since catching
# Blue Eye Tuna since the year 2000?
#
################################################################################
# Load libraries
library(tidyverse)
library(EVR628tools)
library(janitor)

# Load data, tidy data 
# Tip: Press tab after first " to navigate through file directory
tuna_data <- read_csv("data/raw/CatchByFlagGear/CatchByFlagGear1918-2023.csv") |> 
  clean_names() |>                    # Clean names with Janitor package
  rename(year = ano_year,             # Rename columns
         flag = bandera_flag, 
         gear = arte_gear,
         species = especies_species, 
         catch = t)

# Better to do above operations rather than override: 
# tuna_data <- tuna_data |> 
#     clean_names() |> 
#     rename(...)
# Because if you re-run that override later, you will get an error because
# those column names no longer exist 

# Check the column names 
colnames(tuna_data)

# Explore data 
## What are unique species and gear types? 
unique(tuna_data$species)
unique(tuna_data$gear)

# Other syntax that would also work 
tuna_data |> 
  select(species) |> 
  unique()

tuna_data$species |> 
  unique() 

# Filter data 
ps_tuna_data <- tuna_data |> 
  filter(species == "BET",
         gear == "PS",
         year >= 2000) |> 
  mutate(revenue = (1000 * catch) * 2 /1e6)  |> 
  group_by(year) |> 
  summarise(revenue = sum(revenue))

# Check that it did what you think it did 
unique(ps_tuna_data$species)
unique(ps_tuna_data$gear)
range(ps_tuna_data$year)

# What is total revenue? 
sum(ps_tuna_data$revenue)

# What is the mean annual revenue? 
mean(ps_tuna_data$revenue)

ggplot(ps_tuna_data,
       aes(x = year, y = revenue)) +
  geom_line()
