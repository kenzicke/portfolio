# Live coding for ggplot 2 session
# August 28, 2025

# Load packages 
library(EVR628tools)
library(tidyverse)

# Load data
# For data built into packages, can use data() function, but usually lazy loaded already
data("data_lionfish")

# Inspect the data 
glimpse(data_lionfish)

# If the object is in the environment, you don't need "" marks. 


# Start building my plot 
ggplot(data = data_lionfish, 
       mapping = aes(x = depth_m, 
                     y = total_length_mm)) +
  geom_point(shape = 21, fill = "steelblue", size = 3) + 
  labs(x = "Depth (m)",
       y = "Total length (mm", 
       title = "Lionfish length vs depth",
       subtitle = "this is a subtitle",
       caption = "Source: EVR628tools :: ____ ") +
  theme_classic()

# Visualizing distriutions 
# categorical variable 
ggplot(data = data_lionfish,
       mapping = aes(x = fct_infreq(site))) +
  geom_bar() +
  coord_flip()

# Numeric variable 
ggplot(data = data_lionfish,
       mapping = aes(x = total_length_mm)) +
  geom_histogram(bins = 8)

# Visualizing relationships 
# Between two categorical variables 
ggplot(data = data_lionfish, 
       mapping = aes(x = site, size_class)) +
  geom_bin2d() +
  coord_flip()

# shorthand version
ggplot(data_lionfish, aes(x = site, size_class)) +
  geom_bin2d() +
  coord_flip()

# Changing colors 
ggplot(data = data_lionfish, 
       mapping = aes(x = depth_m, 
                     y = total_length_mm,
                     fill = temperature_C)) +
  geom_point(shape = 21, size = 3) + 
  labs(x = "Depth (m)",
       y = "Total length (mm", 
       title = "Lionfish length vs depth",
       subtitle = "this is a subtitle",
       caption = "Source: EVR628tools :: ____ ") +
  theme_classic() +
  scale_fill_viridis_c(option = "plasma")

