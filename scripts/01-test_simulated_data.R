#### Preamble ####
# Purpose: Tests validity of simulated data
# Author: Rohan Alexander
# Date: 26 October 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

simulated_data <- read_csv("data/simulated_data/simulated_data.csv")


states_simulation <- c(
  "Georgia",
  "California",
  "Nevada",
  "Florida",
  "New York"
)

# Test if the data was successfully loaded
if (exists("simulated_analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test Simulation data ####

# Check if the pct support for both candidates makes sense

if (all(simulated_data$pct >=0 & simulated_data$pct <= 100) ) {
  message("Test Passed: percentages are valid numbers")
} else {
  stop("Test Failed: percentages are not valid numbers")
}


# Check if the 'state' column contains only valid U.S. state names

if (all(simulated_data$state %in% states_simulation)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}
# Check that end_date_num is between 0 and 1 

if (all(simulated_data$end_date_num >=0 & simulated_data$end_date_num <= 1) ) {
  message("Test Passed: end_date_num contains valid numbers")
} else {
  stop("Test Failed: end_date_num does not contain valid numbers")
}


# Check that analysis data only includes polls with Trump or Harris
candidate <- c("Harris", "Trump")

if (all(simulated_data$answer %in% candidate) ) {
  message("Test Passed: simulated_data only includes Trump or Harris data")
} else {
  stop("Test Failed: simulated_data does not include only Trump or Harris data")
}


# Check that sample size contains only positive integers
if (all(simulated_data$sample_size > 0) ) {
  message("Test Passed: simulated_data sample sizes contain only positive integers")
} else {
  stop("Test Failed: simulated_data sample sizes do not contain only positive integers")
}




