#### Preamble ####
# Purpose: Simulates an imaginary dataset of political polling data and winners of states.
# Author: Parth Samant
# Date: 26 October 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)


#### Simulate Prediction data ####
# Initializing variables
states_simulation <- c(
  "Georgia",
  "California",
  "Nevada",
  "Florida",
  "New York"
)

#### Simulate Analysis Data ####

pollsters <- c("Emerson College", "Siena/NYT", "YouGov", "SurveyUSA")
methodology <- c("Live Phone", "Online Panel", "Live Phone/Text to Web", "Probability Panel")
dates_num <- seq(from = 0, to = as.numeric(as.Date("2024-10-28"))-as.numeric(as.Date("2024-07-21")), by = 1)
dates <-seq(from = as.Date("2024-07-21"), to = as.Date("2024-10-28"), by = 1)
candidate <- c("Harris", "Trump")
sample_size <- round(rexp(50, rate=1/500))

n = 500
x = sample(dates, n, replace= TRUE)
x_num <- as.numeric(x)-as.numeric(min(x))
x_num <- x_num/99


simulation_analysis_data <- data.frame(
  "pollster" = sample(pollsters, n, replace = TRUE),
  "methodology" = sample(methodology, n, replace = TRUE),
  "state" = sample(states_simulation, n, replace = TRUE),
  "sample_size" = sample(sample_size, n, replace=TRUE),
  "pct" = rnorm(n, 50, 2),
  "answer" = sample(candidate, n, replace = TRUE),
  "end_date" =  x,
  "end_date_num" = x_num
)



# Simulating Trump Polling Data

simulation_trump <-simulation_analysis_data |>
  mutate(num_trump = round((pct / 100) * sample_size, 0)) |>
  filter(
    answer == "Trump"
  )


# Simulating Harris Polling Data

simulation_harris <-simulation_analysis_data |>
  mutate(num_harris = round((pct / 100) * sample_size, 0)) |>
  filter(
    answer == "Harris"
  )






#### Save data ####
write_csv(simulation_analysis_data, "data/simulated_data/simulated_data.csv")

