#Prepare data for correlation and descriptive analysis
cf <- df2 %>%
  mutate(CNT_c = cooling_c + thick_portion_c) %>%
  mutate(explode = blister + chipping_off + explode) %>%
  mutate(socket_issue = socket_deform + socket_chip_off + socket_damage + socket_c) %>%
  mutate(other_crack = long_spigot_c + spigot_c + cross_c + body_c + spider_c) %>%
  mutate(other = spigot_deform + hard_clay + pipe_collape + setting_damage + iron_contamination +
           irregular_inc + ring_not_c + body_rough + overfire + spigot_deform)

names(cf)
cf <- cf %>%
  select(-13:-19 & -21:-24 & -26:-36)
cf2 <- cf[,c(1,3,5:7,9:10,12,14,18,13,19:21,15:17)]

#Filter unreasonable row
cf3 <- cf2 %>%
  filter(!is.na(drying_batch)) %>%
  filter(!drying_batch >150) %>%
  filter(!total_pipe == 0) %>%
  filter(!good_pipe < 0)
summary(cf3)

#Convert to percentage defect
cf4 <- cf3 %>%
  mutate(bend_pipe = bend_pipe / total_pipe *100) %>%
  mutate(CNT_c = CNT_c / total_pipe *100) %>%
  mutate(explode = explode / total_pipe *100) %>%
  mutate(socket_issue = socket_issue / total_pipe *100) %>%
  mutate(other_crack = other_crack / total_pipe *100) %>%
  mutate(other = other / total_pipe *100) %>%
  mutate(good_pipe = good_pipe / total_pipe *100)

cf4 %<>%
  mutate(kiln = case_when(kiln == "L" ~ 1, 
                          kiln == "G1" ~ 2, 
                          kiln == "G2" ~ 3)) %>%
  mutate(kiln = as.integer(kiln)) %>%
  print()

cf4 %>%
  select(-8) %>%
  cor() %>%
  round(2)

cf4 %>%
  select(-8 & -15:-17) %>%
  cor() %>%
  round(2) %>%
  corrplot(
    type = 'upper',
    diag = FALSE
  )

#Product DN150
cf4 %>%
  filter(product == "DN150") %>%
  filter(extruder_num == 1 | extruder_num == 3) %>%
  filter(dryer_num > 5) %>%
  select(-8 & -15:-17) %>%
  cor() %>%
  round(2) %>%
  corrplot(
    type = 'upper',
    diag = FALSE
  )

#Product DN225/175
cf4 %>%
  filter(product == "DN225/175") %>%
  filter(extruder_num == 2 | extruder_num == 7) %>%
  filter(dryer_num > 5) %>%
  select(-8 & -15:-17) %>%
  cor() %>%
  round(2) %>%
  corrplot(
    type = 'upper',
    diag = FALSE
  )

#Target product DN150
cf5 <- cf4 %>%
  filter(product == "DN150") %>%
  filter(extruder_num == 1 | extruder_num == 3) %>%
  filter(dryer_num > 5) %>%
  mutate(extruder_num = as.factor(extruder_num)) %>%
  mutate(dryer_num = as.factor(dryer_num)) %>%
  mutate(kiln = as.factor(kiln)) %>%
  mutate(firing_zone = as.factor(firing_zone)) %>%
  group_by(batch) %>%
  print()

#Visualize with boxplot
cf5 %>%
  ggplot(aes(x=extruder_num, y=bend_pipe, fill=kiln)) +
  geom_boxplot()

#t.test for 2 variable
t.test(bend_pipe ~ extruder_num, data=cf5)

#ANOVA analysis
#Relationship between bend pipe and dryer number
fit <-
  aov(
    bend_pipe ~ dryer_num,
    data = cf5
  )
fit
fit %>% summary()
fit %>% TukeyHSD()

#Relationship between bend pipe and kiln
fit2 <-
  aov(
    bend_pipe ~ kiln,
    data = cf5
  )
fit2
fit2 %>% summary()
fit2 %>% TukeyHSD()

#Relationship between bend pipe and kiln
fit3 <-
  aov(
    bend_pipe ~ firing_zone,
    data = cf5
  )
fit3
fit3 %>% summary()
fit3 %>% TukeyHSD()
