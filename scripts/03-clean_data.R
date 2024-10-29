#### Preamble ####
# Purpose: Cleans polling dataset for analysis 
# Author: Parth Samant
# Date: 26 October 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse and arrow packages must be installed
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)

#### loading data ####
raw_data <- read.csv("https://projects.fivethirtyeight.com/polls/data/president_polls.csv", header=T)


cleaned_data <- raw_data |>
  filter(numeric_grade >= 2.8,
         answer=="Harris" | answer=="Trump" , # filter for KEY BATTLE GROUND STATES, as the winner of the election is based on electoral college and not sheer popularity. In other words, national polls are not that useful. use facet wrap based on each important state. 
         start_date >= as.Date("2024-07-21")) |> # ("https://abcnews.go.com/538/best-pollsters-america/story?id=105563951" scoring between 2.8 and 3.0 are still very good — just not the best of the best. Most pollsters score between a 1.9 and 2.8, representing what we see as America's core block of good pollsters. Pollsters between 1.5 and 1.9 stars are decent, but they typically score poorly on either accuracy or transparency. )
  select(pollster, methodology, state, sample_size, pct, answer) |>
  mutate(state = if_else(state == "", "National", state)
  )
  


harris <- cleaned_data |>
  filter(answer == "Harris") |>
  mutate(num_harris = round((pct / 100) * sample_size, 0))

trump <- cleaned_data |>
  filter(answer == "Trump") |>
  mutate(num_trump = round((pct / 100) * sample_size, 0))




  






  
#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")

