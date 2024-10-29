#### Preamble ####
# Purpose: Downloads and saves the data from fivethirtyeight website.
# Author: Parth Samant
# Date: 26 October 2024
# License: MIT
# Pre-requisites: tidyverse must be installed
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
# [...UPDATE THIS...]

#### Download data ####


# [...ADD CODE HERE TO DOWNLOAD...] 
president_polls = read.csv("https://projects.fivethirtyeight.com/polls/data/president_polls.csv", header=T)



#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(president_polls, "data/raw_data/raw_data.csv") 

         
