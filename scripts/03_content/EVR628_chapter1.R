plot(mtcars) # plot any data set, it will create a grid that plots all columns ~ all collumns 
# Viewer pane similar to Plots pane, but viewer is interactive 
# Ctrl + L clears console pane
# ?known function -- get information on funciton 
# ??phrase -- search entire program for key word or phrase 
# if sharing code and some table or plot comes out slightly different, check using same v package 
# check v in package pane
# Source button -- sends all content in script and sends it to the console. Runs entire code
# command + A -- select all.. command + enter to run all code 
#install.packages in the console, doesn't need to be in script 
# conflict when load package : 
#  dplyr::filter() masks stats::filter(), means the default filter() will be the dplyr
#install.packages("remotes) -- allows you to install "weird" packages
# i.e.   remotes::install_github('jcvdav/EVR628tools')


# Chapter 1 exercises "R for datascience" 

library(tidyverse)
library(palmerpenguins)
library(ggthemes)

glimpse(penguins) 
?penguins

#create canvas. dataset is first argument
plot <- ggplot(data = penguins) 

#aes goes within mapping argument

ggplot(data = penguins, 
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = bill_depth_mm)) +
  geom_smooth(method = loess) +
  labs( title = "Body mass and flipper length", x = "Flipper length (mm)", 
        y = "Body mass (g)", subtitle = "example plot", caption = 'caption goes here') +
  scale_color_continuous()


#data won't appear til it's assigned a geometrical object (how to represent the data)
nrow(penguins)

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species)) + 
  geom_smooth(method = lm)

#fct_infreq -- turns categorical variable to factor and infreq orders based on count

ggplot(penguins, aes( x = fct_infreq(species))) +
  geom_bar()

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 3)

#density plot alternative to histogram. Good for continuous data with an underlying
#smooth distribution 

ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

ggplot(penguins, aes(y = fct_infreq(species))) +
  geom_bar(aes(fill = 'red'))

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density()

#opaque the fill with alpha argument
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.2)


ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
  
         

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

ggplot(mpg, aes(x = displ, y = hwy, linewidth = year)) +
  geom_point() 


ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species", , shape = "Species")


# class chapter 1 exercises 

