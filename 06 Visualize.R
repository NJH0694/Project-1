#Visualizing after group_by and aggregate
df4 %>%
  group_by(batch, defect) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=batch, y=total,fill = defect)) +
  geom_area(position = "fill")

df4 %>%
  group_by(batch, defect) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=batch,y=total)) +
  geom_line(mapping = aes(color=defect), size = 1)

df4 %>%
  group_by(batch, defect, kiln) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=batch,y=total, fill=defect)) +
  geom_area() +
  facet_grid(kiln ~ .)

df4 %>%
  group_by(defect, kiln) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=kiln, y=total, fill = defect)) +
  geom_col()

df4 %>%
  group_by(defect, dryer_num) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=dryer_num, y=total, fill = defect)) +
  geom_col()

df4 %>%
  group_by(defect, firing_zone, kiln) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=firing_zone, y=total, fill = defect)) +
  geom_col() +
  facet_grid(kiln ~ .)

df4 %>%
  filter(defect != 'good_pipe') %>%
  group_by(defect, product) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=defect, y=total, fill = product)) +
  geom_col()

#Filter DN150 and DN225/175 for further analysis (main product)
df5 <- df4 %>%
  filter(product == 'DN150' | product == 'DN225/175') %>%
  droplevels()

df5 %>%
  filter(defect != 'good_pipe') %>%
  group_by(defect, product) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=defect, y=total, fill = product)) +
  geom_col()

df5 %>%
  group_by(batch, defect) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=batch,y=total)) +
  geom_line(mapping = aes(color=defect), size = 1)

df5 %>%
  filter(defect != 'good_pipe') %>%
  group_by(batch, defect) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=batch,y=total)) +
  geom_smooth(mapping = aes(color=defect), size = 1)

#Uncount data
summary(df5)
df6 <- df5 %>%
  filter(!count<0) %>%
  uncount(count)

#Further Visualize
summary(df6)

df6 %>%
  ggplot(aes(product, fill = defect)) +
  geom_bar()

df6 %>%
  ggplot(aes(product, fill = defect)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent)

df6 %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_area(stat = "bin", binwidth = 3, position = "fill") +
  scale_y_continuous(labels = percent)

df6 %>%
  ggplot(aes(x=batch,fill=product)) +
  geom_area(stat = "bin", binwidth = 3, position = "fill") +
  scale_y_continuous(labels = percent)

df6 %>%
  ggplot(aes(x=batch,fill=product)) +
  geom_histogram(binwidth = 2)

df6 %>%
  ggplot(aes(x=batch,fill=kiln)) +
  geom_histogram(binwidth = 2) +
  facet_grid(kiln ~ .)

df6 %>%
  ggplot(aes(x=batch,fill=product)) +
  geom_histogram(binwidth = 2) +
  facet_grid(kiln ~ .)

df6 %>%
  ggplot(aes(x=dryer_num,fill=defect)) +
  geom_histogram(binwidth = 2) +
  facet_grid(kiln ~ .)

#Filter DN225/175 for further analysis (main product)
df225 <- df6 %>%
  filter(product == 'DN225/175') %>%
  filter(!is.na(drying_batch)) %>%
  filter(dryer_num>5) %>%
  filter(extruder_num == 2 | extruder_num == 7) %>%
  mutate(extruder_num = as.factor(extruder_num)) %>%
  mutate(dryer_num = as.factor(dryer_num)) %>%
  select(-2 & -4 & -8 & -11 & -12)

summary(df225)

df225 %>%
  ggplot(aes(x=kiln,fill=defect)) +
  geom_bar()

df225 %>%
  ggplot(aes(x=kiln,fill=defect)) +
  geom_bar(position = "fill")

df225 %>%
  ggplot(aes(x=dryer_num,fill=defect)) +
  geom_bar()

df225 %>%
  ggplot(aes(x=dryer_num,fill=defect)) +
  geom_bar(position = "fill")

df225 %>%
  ggplot(aes(x=extruder_num,fill=defect)) +
  geom_bar()

df225 %>%
  ggplot(aes(x=extruder_num,fill=defect)) +
  geom_bar(position = "fill")

df225 %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)

df225 %>%
  filter(defect == 'good_pipe' | defect == 'CNT_c') %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)

df225 %>%
  filter(defect == 'good_pipe' | defect == 'bend_pipe') %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)
