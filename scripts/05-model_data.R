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
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

#### Prior ####

Priors = normal(0, 2.5)

#### Model data ####
harris <- harris |>
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    methodology = factor(methodology)
  )

trump <- trump |>
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    methodology = factor(methodology)
  )

# Above factoring done to make bayesian modeling easier


model_bayes <- cbind(num_harris, sample_size - num_harris) ~  end_date_num + (1 | state) + (1 | pollster) + (1 | methodology)

model_bayes_trump <- cbind(num_trump, sample_size - num_trump) ~ end_date_num + (1 | pollster) + (1 | state) + (1 | methodology)

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
    iter = 500,
    adapt_delta = 0.95
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
    iter = 500,
    adapt_delta = 0.95
  )


#### Using models to predict who has more support in each state ####

# Vector of both states sampled and how many electoral votes the state has.

states <- c("Montana", "New Hampshire", "Pennsylvania", "North Carolina", "Wisconsin", 
                      "South Dakota", "Georgia", "Arizona", "Maryland", "Texas", "Michigan", 
                      "Florida", "California", "Washington", "Nevada", "Ohio", "Massachusetts", 
                      "Virginia", "Minnesota", "New York", "Nebraska", 
                      "New Mexico", "Connecticut", "Rhode Island", "Missouri", "Indiana", "Iowa")

electoral_votes <- c(4, 4, 19, 16, 10, 3, 16, 11, 10, 40, 15, 30, 54, 12, 6, 17, 11, 13, 10, 28, 5, 5, 7, 4, 10, 11, 6)


# initializing variables for the for loop below.
state_pred = NULL
state_pred = data.frame(state = character(), 
                        harris_pred = double(),
                        trump_pred = double(),
                        win = integer(),
                        electoral_votes = integer(),
                        electoral_votes_harris = integer(),
                        stringsAsFactors = FALSE)



# end_date_num = 1.08 indicates Nov 5. since the last poll was done 28 October 
# using this data which corresponds to end_date_num = 1. 
# October 28 is 99 days after July 21st, Nov 5th is 108 days after July 21st. Thus,
# 108/99 is approximately 1.08.

i=0
for (state in states){
  i = i+1
  set.seed(538)
  state_data_har = data.frame(num_harris = 50, state = state, 
                  sample_size = 100, pollster = "", end_date_num = 1.08,methodology = "")
  state_data_trump = data.frame(num_trump = 50, state = state, 
                                sample_size = 100, end_date_num = 1.08,pollster = "", methodology = "")
  
  post_har <- posterior_predict(model_har, newdata = state_data_har, draws = 2000)
  post_trump <- posterior_predict(model_trump, newdata = state_data_trump, draws = 2000)
  win <- ifelse(mean(post_har) > mean(post_trump), 1, 0)
  electoral_votes_harris = win * electoral_votes[i]
  state_pred <- rbind(state_pred, data.frame(state = state, 
                                             harris_pred = mean(post_har), 
                                             trump_pred = mean(post_trump),
                                             win,
                                             electoral_votes[i],
                                             electoral_votes_harris = win * 
                                              electoral_votes[i]))
}

state_pred <- state_pred |>
  rename(electoral_votes = electoral_votes.i.)


#### Adding in Missing States ####


states <-c("Alabama", "Alaska", "Arkansas", "Colorado", "Delaware", "Hawaii", "Idaho", "Illinois", 
                   "Kansas", "Kentucky", "Louisiana", "Maine", "Mississippi", "New Jersey", "North Dakota", 
                   "Oklahoma", "Oregon", "South Carolina", "Tennessee", "Utah", "Vermont", "West Virginia", 
                   "Wyoming", "District of Columbia")

electoral_votes <- c(9, 3, 6, 10, 3, 4, 4, 19, 6, 8, 8, 4, 6, 14, 3, 7, 8, 9, 11, 6, 3, 4, 3, 3)

win <- c(0,
         0,
         0,
         1,
         1,
         1,
         0,
         1,
         0,
         0,
         0,
         1,
         0,
         1,
         0,
         0,
         1,
         0,
         0,
         0,
         1,
         0,
         0,
         1) #HARRIS WILL WIN ALL BUT ONE ELECTORAL VOTE IN MAINE


state_pred_missing = data.frame(state = states,
                                harris_pred = 0,
                                trump_pred = 0,
                                
                                
                                  win,
                                electoral_votes,
                                  electoral_votes_harris= electoral_votes * win)


state_pred_combined <- bind_rows(state_pred, state_pred_missing)




  

#### PLOTTING THE MODEL RESULTS ####
library(sf)
library(maps)
us_states <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))

test <- state_pred
test$state <- tolower(test$state)


# Merge your data with the US states shapefile
us_states <- us_states %>%
  left_join(test, by = c("ID" = "state"))

# Plot the map
ggplot(us_states) +
  geom_sf(aes(fill = factor(win)), color = "white", crs = FALSE) +
  scale_fill_manual(values = c("1" = "blue", "0" = "red"),
                    labels = c("0" = "Trump Wins", "1" = "Harris Wins"),
                    name = "Predicted Winner") +
  theme_void() +
  labs(title = "Predicting Winner of State Based on Model")





#### Save model ####
saveRDS(
  model_har,
  file = "models/first_model_kamala.rds"
)

saveRDS(
  model_trump,
  file = "models/first_model_trump.rds"
)

write_parquet(state_pred, "data/analysis_data/prediction_data/models_state_prediction_data.parquet")
write_parquet(state_pred_missing, "data/analysis_data/prediction_data/missing_state_prediction_data.parquet")
write_parquet(state_pred_combined, "data/analysis_data/prediction_data/prediction_data.parquet")

