################################################################################
# Assignment 3 - Data Visualization
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# 10/28/2025
#
# Visualizing data collected from my alkalinity enrichment~coral
# settlement trial. Exploring the stability of the alkalinity treatments
# over time as well as treatment stat summaries
################################################################################

# Load libraries
library(tidyverse)

# Load data from previous assignment
data <- read_rds("data/processed/all_data.rds")

# Convert date column to Date class
data <- data %>%
  mutate(date = as.Date(date, format =  "%m/%d/%y"))


# Calculate treatment statistics
data |>
  group_by(treatment) |>
  summarise(mean = mean(ta_av, na.rm = TRUE),
            pH = mean(p_h_pico, na.rm = TRUE),
            sd = sd(ta_av, na.rm = TRUE),
            n = sum(!is.na(ta_av)))

# Visualize the chemistry over time
p1 <- ggplot(
  data = data %>%
    filter(!treatment %in% c("source_a", "source_d")),
  aes(x = date, y = ta_av, color = treatment)) +
  geom_jitter(width = 0.2) +
  geom_smooth(method = lm) +
  theme_bw() +
  scale_color_discrete(labels = c("ambient",
                                 "+ 300 umol",
                                 "+ 600 umol",
                                 "+ 900 umol",
                                 "source low",
                                 "source high")) +
  labs(x = "Date",
       y = "Total alkalinity (umol/kg)")

# Transform data to assign "blank" content to samples that came from sumps
data_filtered <- data %>%
  filter(date >= as.Date("8/28/2025", format = "%m/%d/%Y")) %>%
  mutate(content = case_when(str_starts(string = vessel,
                                        pattern = "s") ~ "blank", # Replace NAs with blank in sump smaples
                             TRUE ~ content)) # otherwise keep original

# Visualize treatment statistics via boxplot
p2 <- ggplot(data = data_filtered %>%
                filter(!vessel %in% c("sump_sw", "sump_esw")),  # Take out sumps afterall
       aes(x = treatment, y = ta_av, fill = treatment)) +
  geom_boxplot() +
  geom_point() +
  facet_wrap(~content) +
  theme_bw() +
  scale_fill_discrete(labels = c("ambient",
                                 "+ 300 umol",
                                 "+ 600 umol",
                                 "+ 900 umol"
                                 )) +
  labs(x = "Treatment",
       y = "Total alkalinity (umol/kg)",
       fill = "Treatment")


# Save and export figures
ggsave(filename = "alkalinity_time.pdf",
       plot = p1, path = "results/img/", height = 4, width = 5)

ggsave(filename = "alkalinity_summary.pdf",
       plot = p2, path = "results/img/", height = 4, width = 5)



