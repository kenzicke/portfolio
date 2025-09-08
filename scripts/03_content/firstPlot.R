# Load packages
library(EVR628tools)
library(tidyverse)

# Load data

data("data_lionfish")

# Create simple plot 

ggplot(data = data_lionfish,
       mapping = aes(x = total_weight_gr, y = depth_m)) +
  geom_point() +
  facet_wrap(~site)
