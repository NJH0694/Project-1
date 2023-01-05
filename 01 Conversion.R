#Load package
library(pacman)
p_load(tidyverse,rio,readxl,janitor,lubridate,magrittr)
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
