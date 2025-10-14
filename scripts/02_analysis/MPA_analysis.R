################################################################################
# MPA_analysis.R
################################################################################

# Kenzie Cooke
# kmc390@miami.edu
# 9/18/2025

################################################################################

# Set up #######################################################################

# Load packages 
library(EVR628tools)
library(tidyverse)

# Load data 
data("data_MPA")

# Inspect data process 

?data_MPA. # Inspect variables 
class(data_MPA) 

# What are the dimensions of the data? 
dim(data_MPA)

# what are the colmn names 
colnames(data_MPA)

# How many unique() sites are there? 
data_MPA$id |> 
  unique() |> 
  length()

# How many unique years? 
data_MPA$time |> 
  unique() |> 
  length()


# Visualize the trends in biomass through time across site protection level
ggplot(data = data_MPA, 
       aes(x = time, y = biomass, color = protected ==1 , shape = id)) +
  #geom_line()
  geom_smooth(se = FALSE) +
  theme_bw()

# another version 
ggplot(data = data_MPA, 
       aes(x = time, y = biomass, 
           color = protected ==1)) +
  geom_point(aes(shape = after == 1)) +
  geom_smooth() +
  theme_bw()

# Create four objects containing 
## Mean biomass inside the MPA before it was protected 
### My attempt 

inside_before <-  data_MPA |> 
  filter(time == 0) |> 
  filter(after == 0)

### jcv attempt 
inside_before <-data_MPA$biomass[data_MPA$protected == 1 & data_MPA$after == 0] |> 
  mean()

## Mean biomass inside the MPA after it was protected
inside_after <- data_MPA$biomass[data_MPA$protected == 1 & data_MPA$after == 1] |> 
  mean()

## Mean biomass outside the MPA before the MPA was created 
outside_before <-  data_MPA$biomass[data_MPA$protected == 0 & data_MPA$after == 0] |> 
  mean()

## Mean biomass outside the MPA after the MPA was created 
outside_after <-  data_MPA$biomass[data_MPA$protected == 0 & data_MPA$after == 1] |> 
  mean()


# Calculate change after vs before for protected side 
inside_change <- inside_after - inside_before

# Calculate change after vs before for unprotected side 
outside_change = outside_after - outside_before

# net change 
# Calculate the difference through time and treatments  
net_change <- inside_change - outside_change

# The final step -- another way to do it using fixest package
library(fixest). #fixed effect estimation package 
feols(biomass ~ protected * after, data = data_MPA) |> 
  etable()
