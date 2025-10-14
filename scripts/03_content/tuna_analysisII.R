################################################################################
# tuna_analysis part II
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 10/2/2025
#
# Description
#
################################################################################

# Load packages
library(readxl)
library(janitor)
library(tidyverse)

# Laod data 
tuna_prices <- read_excel("data/raw/Economic-and-Development-Indicators-and-Statistics-Tuna-Fishery-of-the-Western-and-Central-Pacific-Ocean-2024-32765/Compendium of Economic and Development Statistics 2024.xlsx",
                          sheet = "B. Prices",
                          range = "A35:E63",
                          na = "na") |> 
  clean_names()
  

# Inspect data 
colnames(tuna_prices)
dim(tuna_prices)

# check for na's 
tuna_prices |> 
  filter_all(any_vars(is.na(.)))

# What should dataframe look like to answer our question? 
# We will need only two columns, year and price. To get there, we should
# have tidy data with year, market, presentation, and price, and then we can
# use group by and summarise functions. 


tidy_tuna_price <- tuna_prices |> 
  pivot_longer(cols = 2:5,
               names_to = c("market", "presentation"),
               names_sep = "_",
               values_to = "price",
               values_drop_na = TRUE)

# Calculate average price per year 
tuna_price_mean <- tidy_tuna_price |> 
  group_by(year) |> 
  summarise(price = mean(price))

# Append price data to catch data from last week 

# Pipeline 2: Load tuna catch data 
tuna_catch <- read_csv("data/raw/CatchByFlagGear/CatchByFlagGear1918-2023.csv") |> 
  clean_names() |>                    # Clean names with Janitor package
  rename(year = ano_year,             # Rename columns
         flag = bandera_flag, 
         gear = arte_gear,
         species = especies_species, 
         catch = t) 

ps_tuna_catch <- tuna_catch |> 
  filter(species == "BET",
         gear == "PS",
         year >= 2000) |> 
  group_by(year) |> 
  summarise(catch = sum(catch))
  

# Join price data with catch/revenue data 
# Join the two datasets, what I want to end up is year, catch, price, revenue
# Have to join two datasets with left join and create new column for rev
# Left join by year. Rev will be catch * price and then divided by 1e6 to put
# in millions

tuna_join <- left_join(ps_tuna_catch, tuna_price_mean,
                       by = join_by("year")) |> 
  mutate(revenue_mil = catch * price / 1e6)

# Alternate syntax
tuna_join <- ps_tuna_catch |> 
  left_join(tuna_price_mean,
            by = join_by("year")) |> 
   mutate(revenue_mil = catch * price / 1e6)

# How much total revenue since 2000? 
total_rev <- tuna_join |> 
  summarise(rev = sum(revenue_mil))

ggplot(tuna_join,
       aes(x= year, y = revenue_mil)) +
  geom_line() +
  theme_bw()
  

