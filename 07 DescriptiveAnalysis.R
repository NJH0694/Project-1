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
  mutate(other = other / total_pipe *100)

cf4 %>%
  select(-2 & -8) %>%
  cor() %>%
  round(2)

cf4 %>%
  select(-2 & -8 & -15:-17) %>%
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
  select(-2 & -8 & -15:-17) %>%
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
  select(-2 & -8 & -15:-17) %>%
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
  group_by(batch) %>%
  print()

#Visualize with boxplot
cf5 %>%
  ggplot(aes(x=extruder_num, y=bend_pipe, fill=kiln)) +
  geom_boxplot()

#ANOVA analysis
fit <-
  aov(
    bend_pipe ~ extruder_num,
    data = cf5
  )
fit
fit %>% summary()
fit %>% TukeyHSD()


ggpairs(cf5)
