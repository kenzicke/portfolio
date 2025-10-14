################################################################################
# objects_and_vectors
################################################################################
#
# Kenzie Cooke
# kmc390@miami.edu
# 9/11/2025
#
# Week 4 exercises 
#
################################################################################
# Load library
library(tidyverse)

# Part B: Create simple objects, check class 
my_name <- "Kenzie Cooke"

my_age <- 33

is_student <- TRUE

class(my_age)
class(my_name)
class(is_student)


# Part C: Object coercion

as.character(my_age) # does not save in environment

my_age_char <- as.character(my_age) # Does transform initial object

as.numeric(is_student)




