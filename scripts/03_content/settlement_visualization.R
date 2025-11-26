################################################################################
# Settlment analysis
################################################################################
#
# Kenzie M. Cooke
# kmc390@miami.edu
# September 2025
#
# Analyzing settlement success in September 2025 pilot OFAV and PSTR pilot trial
#
################################################################################


# Load packages ---------------------------------------------------------------

library(tidyverse)
library(viridis)
library(ggpubr)


# Import and clean data --------------------------------------------------------

data <- read_csv("data/raw/settlement_data.csv")
filter_data <- filter(data, contents != "blank")


# Visualize data ---------------------------------------------------------------

filter_data$rep = factor(filter_data$rep)

# Plot initial settlement count by treatment, wrap species
ggplot(filter_data, aes(x = treat,
                        y = count_init)) +
  stat_summary(geom = "pointrange",
               color = "black",
               size = 0.8) +
  geom_jitter(aes(color = rep),
              alpha = 0.4,
              width = 0.4,
              height = 0) +
  facet_wrap(~species) +
  labs(title = "Initial settlement count",
       x = "Treatment",
       y = "Initial count")


# Plot final settlement count by treatment, wrap species
ggplot(filter_data, aes(x = treat,
                        y = count_fin)) +
  stat_summary(geom = "pointrange",
               color = "black",
               size = 0.8) +
  geom_jitter(alpha = 0.4,
              width = 0.4,
              height = 0,
              aes(color = rep)) +
  facet_wrap(~species) +
  labs(title = "Final settlement count",
       x = "Treatment",
       y = "Final count")


#Plot settlement all species
ggplot(filter_data, aes(x = treat,
                        y = count_fin)) +
  stat_summary(geom = "pointrange",
               color = "black",
               size = 0.8) +
  geom_jitter(aes(alpha = 0.4,
                  width = 0.4,
                  height = 0,
                  color = rep)) +
  labs(title = "Final settlement count",
       x = "Treatment",
       y = "Final count")

#Plot settlement by tile "yes", "no"
ggplot(filter_data, aes(x = treat,
                        y = count_fin)) +
  stat_summary(geom = "pointrange",
               color = "black",
               size = 0.8) +
  geom_jitter(aes(alpha = 0.4,
                  width = 0.4,
                  height = 0,
                  color = rep)) +
  labs(title = "Final settlement count",
       x = "Treatment",
       y = "Final count")

#total settlemrs

totals <- filter_data %>%
  group_by(species, treat) %>%
  summarise(total_settlers = sum(count_fin, na.rm = TRUE), .groups = "drop")

ggplot(totals, aes(x = treat,
                   y = total_settlers,
                   fill = treat)) +
  geom_col() +
  facet_wrap(~ species) +
  labs(x = "Treatment",
       y = "Total settlers") +
  theme_classic()

#percent settlement

filter_data <- filter_data %>%
  mutate(prop_settle = count_init / 20,
         perc_settle = 100 * prop_settle)

 p1 <- ggplot(filter_data, aes(x = treat,
                        y = perc_settle)) +
  stat_summary(geom = "pointrange",
               color = "black",
               size = 0.6) +
  geom_jitter(alpha = 0.4,
              width = 0.4,
              height = 0,
              aes(color = rep)) +
  facet_wrap(~species) +
  labs(color = "Tile replicate",
       x = "Treatment",
       y = "% settlement",
       title = "Percent settled out of 20")

ggsave(filename = "results/img/percent_settled.pdf", plot = p1)
