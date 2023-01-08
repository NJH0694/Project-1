#This is the first file to load
#It create loops to call 2 files: "02 Read.R" and "03 Tidy.R"
#Raw data files will be converted into tidy data and stored in "/Tidy Data/"

#Load package
library(pacman)
p_load(tidyverse,readxl,janitor,magrittr)

#Read file list in 'raw data' folder
raw_list <- list.files(path='Raw Data/', pattern="*.xls")

#Create loop to convert all files in raw folder
#Take few minutes to complete 100 files
i = 0
repeat{
  
  i = i+1
  
  source("02 Read.R")
  source("03 Tidy.R")
  
  print(file_tidy)
  
  if(raw_list[i]==last(raw_list)) {
    rm(list = ls())
    break
  }
}

# Clear data
rm(list = ls())  # Removes all objects from environment

# Clear packages
pacman::p_unload(all)  # Remove all contributed packages