#This file is followed by '04 Combine.R'
#The database included some blank columns and contain too many defect types
#It needs further cleaning and simplification before visualizing

#Read packages
library(pacman)
p_load(tidyverse,rio,readxl,janitor,lubridate,magrittr,GGally,scales,corrplot,RColorBrewer)

#Load database
type <- 'icfiiiiiiicfiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii'
df <- as_tibble(read_csv('database.csv', col_types = type))

#Check 0 sum columns
summary(df)
rdf <- df[,13:53] %>%
  select_if(colSums(.) == 0)
#Remove 0 defect columns
df2 <- df %>%
  select(-names(rdf))

#Same method but manually
#df2 <- df %>%
#  select(-c(drying_c,body_dented,between_car_damage,limestone,insp_damage,
#            neck_crack,radial_c,lamination,lab_test,glaze_crawl,
#            remain_clay,gross_grog))

df2 %>%
  group_by(product) %>%
  summarise(total = sum(total_pipe))

#Visualize
qplot(product, data=df2, geom="bar")
qplot(extruder_num, data=df2, geom="bar")
qplot(kiln, data=df2, geom="bar")
qplot(dryer_num, data=df2, geom="bar")
qplot(firing_zone, data=df2, geom="bar")

#Merge similar defects
df3 <- df2 %>%
  mutate(CNT_c = cooling_c + thick_portion_c) %>%
  mutate(explode = blister + chipping_off + explode) %>%
  mutate(socket_issue = socket_deform + socket_chip_off + socket_damage + socket_c) %>%
  mutate(other_crack = long_spigot_c + spigot_c + cross_c + body_c + spider_c) %>%
  mutate(other = spigot_deform + hard_clay + pipe_collape + setting_damage + iron_contamination +
           irregular_inc + ring_not_c + body_rough + overfire + spigot_deform)

#Remove extra columns and rearrange
names(df3)
df3 <- df3 %>%
  select(-13:-19 & -21:-24 & -26:-36)
df3 <- df3[,c(1:12,14,18,13,19:21,16)]
summary(df3)

#Convert to long data
names(df3)
df4 <- df3 %>%
  pivot_longer(cols=13:19,names_to = "defect", values_to = "count") %>%
  mutate(defect = as.factor(defect))

df4 %<>%
  mutate(defect = fct_reorder(defect,count, .desc=FALSE))
