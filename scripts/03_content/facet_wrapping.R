library(EVR628tools)
library(tidyverse)

# Build a data. frame by grouping year and fishery 
data("data_fishing")

total_catch <-  data_fishing |> 
  group_by(year, fishery) |> 
  summarize(total_catch = sum(catch))

ggplot(data = total_catch,
       aes(x = year, 
           y = total_catch)) +
  geom_line() +
  geom_point() +
  facet_wrap(~fishery, 
             ncol = 1, 
             scales = "free_y")

# Example of summarizing data directly in the figure 
# Using summary stats in ggplot 

            