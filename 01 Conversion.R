#Load package
library(pacman)
p_load(tidyverse,rio,readxl,janitor,lubridate,magrittr)
#Read file list in 'raw data' folder
raw_list <- list.files(path='Raw Data/', pattern="*.xls")

#Create loop to convert all files in raw folder
i = 0
repeat{
  
  i = i+1
  
  source("Separate.R")
  source("Tidy.R")
  

  if(raw_list[i]==last(raw_list)) {
    rm(list = ls())
    break
  }
}