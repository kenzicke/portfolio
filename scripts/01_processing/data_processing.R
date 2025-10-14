################################################################################
# Assignment2 - Data Wrangling
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 10/14/2025
#
# This script imports raw data from the Methrom alkalinity titrator and
# appends it to coral and bottle metadata
################################################################################

# Load libraries
library(tidyverse)
library(janitor)
library(plotly)
library(seacarb)

# Import and inspect raw alkalinity data
alk_data <- read_csv("data/raw/settlement_alk_data.csv")
View(alk_data)
colnames(alk_data)

# I need to cut down and rename the Sample_ID column so it only includes the bottle number
# so I can join it to my coral metadata. Each Sample_ID has two replicates.
# I also need to take the average of these ("Final_TA") and create a new column
# so that each bottle sample only has one TA value when I join it to my coral
# metadata. I only want the bottle sample ID and the average Final_TA of the two
# replicates from this dataset.

# Clean alkalinity data
alk_data_clean <- alk_data |>
  clean_names() |>
  mutate(sample_num = str_extract(sample_id, "^\\d+")) |>   # ^ start of string, \\d a digit + one or more of the preceding thing
  group_by(sample_num) |>
  summarise(ta_av = mean(final_ta, na.rm = TRUE),
             ta_sd = sd(final_ta, na.rm = TRUE),
         n_reps = n())  # num of rows in current group

# This dataset has information on the treatment/coral each water sample was collected from
# Import and inspect bottle/coral meta data
bottle_data <- read_csv("data/raw/bottle.csv")
View(bottle_data)
colnames(bottle_data)

# Clean bottle data
bottle_data_clean <-  bottle_data |>
   clean_names() |>
  rename(sample_num = bottle_id) |>
  mutate(sample_num = as.character(sample_num))


# Join alkalinity data to bottle metadata
all_data <- bottle_data_clean |>
  left_join(
    alk_data_clean |>
      select(sample_num, ta_av, ta_sd),
    by = "sample_num"
  )


# Export cleaned data as .rds
write_rds(x = all_data,
          file = "data/processed/all_data.rds")

# Calculate treatment statistics
all_data |>
  group_by(treatment) |>
  summarise(mean = mean(ta_av, na.rm = TRUE),
            pH = mean(p_h_pico, na.rm = TRUE),
            sd = sd(ta_av, na.rm = TRUE),
            n = sum(!is.na(ta_av)))

# Visualize the data
ggplot(all_data,
       aes(x = date, y = ta_av, color = treatment)) +
  geom_jitter(width = 0.2) +
  theme_bw()

# Boxplot of traetment statistics
ggplot(all_data, aes(x = treatment, y = ta_av, fill = treatment)) +
  geom_boxplot() +
  theme_bw() +
  scale_fill_discrete(labels = c("2700 umol", "3000 umol", "3300 umol", "3600 umol", "source low", "source high")) +
  labs(x = "Treatment", y = "Total alkalinity (umol/kg)")


