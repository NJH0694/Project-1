#Load package
library(pacman)
p_load(tidyverse,rio,readxl,janitor,lubridate,magrittr)

#Column names
name <- c("batch","date","kiln","kiln_car","firing_zone","drying_batch",
       "dryer_num","dryer_car","dryer_car_pos","extruder_num","extruder_date",
       "product","thick_portion_c","spigot_c","cross_c","cooling_c","long_spigot_c",
       "body_c","blister","explode","ring_not_c","chipping_off","irregular_inc",
       "body_rough","bend_pipe","socket_deform","setting_damage","hard_clay",
       "iron_contamination","drying_c","body_dented","between_car_damage",
       "spider_c","socket_chip_off","limestone","underfire","insp_damage",
       "spigot_deform","overfire","neck_crack","radial_c","lamination",
       "lab_test","glaze_crawl","remain_clay","socket_damage","gross_grog",
       "firing_damage","pipe_collape","socket_c","reject_pipe","good_pipe","total_pipe")

#Column type
type <- 'icfiiiiiiicfiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii'

#Read file list in folder
tidy_list <- list.files(path='Tidy Data/', pattern="*.csv")
file_tidy <- paste0('Tidy Data/',tidy_list)

#Read all tidy file into a single dataframe
ds <- read_csv(file_tidy, col_names=name, col_types = type, skip = 1)

#Convert date to proper format
ds2 <- ds %>%
  mutate(date = my(ds$date))
ds3 <- ds2 %>%
  mutate(extruder_date = dmy(paste0(test0$extruder_date,"/",year(test1$date))))

#Save to single database file
write_csv(ds3,path='database.csv', append = FALSE)

# Clear data
rm(list = ls())  # Removes all objects from environment

# Clear packages
pacman::p_unload(all)  # Remove all contributed packages