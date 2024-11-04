# Starter folder

## Overview

This repository aims to use polling aggregation data from FiveThirtyEight to predict the winner of 2024 U.S. Election. This is done through use of a Bayesian inference model that predicts the winner of key battleground states (as well as other states) for the election. After predicting a winner of each state, the sum of electoral votes for each candidate is found, which determines the winner of the Electoral College (and thus the election). 

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from FiveThirtyEight
-   `data/analysis_data` contains the cleaned dataset that was constructed as well as a prediction dataset that uses the cleaned dataset to predict 
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

The modelling of the dataset (under `scripts/05-model_data.R`) was written with the help of ChatGPT and the entire chat history is available in other/llm_usage/usage.txt.
