# Exercise 2
# Create numeric vector
length_m <- c(6, 4.1, 2.78, 5.5, 3.9, 5.8)

# Create character vector
shark_species <- c("Great White Shark", "Lemon Shark", "Bull Shark", 
                   "Hammerhead Shark", "Mako Shark", "Great White Shark")

# Use length function to calculate num of length observations
length(length_m)

# How many unique species are there? 
shark_species |> 
  unique() |> 
  length()

############################################
# how to remove object from environment 

## created mispelled vector 
lengt <-  c(4, 5, 6)

## remove
rm(lengt)
############################################

# Calculate mean length of all sharks 
## Option 1
mean(x = length_m) # Naming X argument is good practice
mean(length_m)     # But not necessary

## Option 2 
length_m |> 
  mean()

# Find max length 
max(x = length_m)

# Extract first 3 shark spp and save as object
first_3 <-  shark_species[1:3]
first_3 <-  shark_species[c(1, 2, 3)] # Equivalent to above

# Extract shark spp where max length > 4 m 
shark_species[length_m > 4]
####################################################

# Find shark spp that is largest
shark_species[max(length_m)]
shark_species[6]
# right for the wrong reasons. Not correct way 


# Correct way.. Build a logical vector 
shark_species[length_m == max(length_m)]


# Smallest shark? 
shark_species[length_m == min(length_m)]

# Calculate mean length for all great white sharks 
# Option 1
mean_great <- length_m[shark_species == "Great White Shark"] |> 
  mean()
  
 

