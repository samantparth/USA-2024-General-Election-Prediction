#### Preamble ####
# Purpose: Tests validity of analysis data
# Author: Parth Samant
# Date: 26 October 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 03.clean_data.R must have been run
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)

cleaned_data <- read_parquet("data/analysis_data/analysis_data.parquet")

states_cleaned <- c("Montana", "New Hampshire", "Pennsylvania", "North Carolina", "Wisconsin", 
                      "South Dakota", "Georgia", "Arizona", "Maryland", "Texas", "Michigan", 
                      "Florida", "California", "Washington", "Nevada", "Ohio", "Massachusetts", 
                      "Virginia", "Minnesota", "New York", "Nebraska", 
                      "New Mexico", "Connecticut", "Rhode Island", "Missouri", "Indiana", "Iowa", "National",
                    "Nebraska CD-2", "Nebraska CD-1", "Nebraska CD-3", "Maine CD-2", "Maine CD-1", "Maine")


#### Test data ####

# Test if the data was successfully loaded
if (exists("cleaned_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

# Check if the pct support for both candidates makes sense

if (all(cleaned_data$pct >=0 & cleaned_data$pct <= 100) ) {
  message("Test Passed: percentages are valid numbers")
} else {
  stop("Test Failed: percentages are not valid numbers")
}


# Check if the 'state' column contains only valid U.S. state names

if (all(cleaned_data$state %in% states_cleaned)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}
# Check that end_date_num is between 0 and 1 

if (all(cleaned_data$end_date_num >=0 & cleaned_data$end_date_num <= 1) ) {
  message("Test Passed: end_date_num contains valid numbers")
} else {
  stop("Test Failed: end_date_num does not contain valid numbers")
}


# Check that analysis data only includes polls with Trump or Harris
candidate <- c("Harris", "Trump")

if (all(cleaned_data$answer %in% candidate) ) {
  message("Test Passed: dataset only includes Trump or Harris data")
} else {
  stop("Test Failed: dataset does not include only Trump or Harris data")
}


# Check that sample size contains only positive integers
if (all(cleaned_data$sample_size > 0) ) {
  message("Test Passed: dataset sample sizes contain only positive integers")
} else {
  stop("Test Failed: dataset sample sizes do not contain only positive integers")
}