#### Preamble ####
# Purpose: Models And Compares Support for Donald Trump and Kamala Harris by State
# Author: Parth Samant
# Date: 28 October 2024 [...UPDATE THIS...]
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 03-clean_data.R script first
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(modelsummary)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

#### Prior ####

Priors = normal(20, 2.5)

#### Model data ####
harris <- harris |>
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    methodology = factor(methodology)
  )


model_bayes <- cbind(num_harris, sample_size - num_harris) ~  (1 | pollster) + (1 | state) + (1 | methodology)

model_bayes_trump <- cbind(num_trump, sample_size - num_trump) ~  (1 | pollster) + (1 | state) + (1 | methodology)

#### Code for Bayesian Models ####
model_har <-
  stan_glmer(
    formula = model_bayes,
    data = harris,
    family = binomial(link="logit"),
    prior = Priors,
    prior_intercept = Priors,
    seed = 538,
    cores = 4,
    iter = 2000
  )

model_trump <-
  stan_glmer(
    formula = model_bayes_trump,
    data = trump,
    family = binomial(link="logit"),
    prior = Priors,
    prior_intercept = Priors,
    seed = 538,
    cores = 4,
    iter = 2000
  )
trump <- cleaned_data |>
  filter(answer == "Trump")

  
  
harris <- analysis_data |>
  filter(answer == "Harris")


#### Using models to predict who has more support in each state ####

states <- c("Montana", "New Hampshire", "Pennsylvania", "North Carolina", "Wisconsin", 
                      "South Dakota", "Georgia", "Arizona", "Maryland", "Texas", "Michigan", 
                      "Florida", "California", "Washington", "Nevada", "Ohio", "Massachusetts", 
                      "Virginia", "Minnesota", "New York", "Nebraska", 
                      "New Mexico", "Connecticut", "Rhode Island", "Missouri", "Indiana", "Iowa")


harris_prediction = 0
trump_prediction = 0
state_pred = NULL
state_pred = data.frame(state = character(), 
                        harris_pred = double(),
                        trump_pred = double(),
                        win = integer(),
                        stringsAsFactors = FALSE)

for (state in states){
  i = i+1
  set.seed(538)
  state_data_har = data.frame(num_harris = 50, state = state, 
                  sample_size = 100, pollster = "", methodology = "")
  state_data_trump = data.frame(num_trump = 50, state = state, 
                                sample_size = 100, pollster = "", methodology = "")
  
  post_har <- posterior_predict(model_har, newdata = state_data_har)
  post_trump <- posterior_predict(model_trump, newdata = state_data_trump)
  win <- ifelse(mean(post_har) > mean(post_trump), 1, 0)
  
  state_pred <- rbind(state_pred, data.frame(state = state, 
                                             harris_pred = mean(post_har), 
                                             trump_pred = mean(post_trump),
                                             win ))
}




#### Save model ####
saveRDS(
  model_bayes,
  file = "models/first_model_kamala.rds"
)

saveRDS(
  model_bayes_trump,
  file = "models/first_model_trump.rds"
)



