#Visualizing after group_by and aggregate
df4 %>%
  group_by(defect, product) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=product, y=total,fill = defect)) +
  geom_col() + 
  scale_fill_brewer(palette = "Blues") +
  labs(title = "Total pipe produced by product and defect type", element_text = 20) +
  theme(axis.text.x = element_text(size = 11, face ="bold"),
        legend.text = element_text(size = 11),
        plot.title = element_text(size = 16, hjust=0.5))

df4 %<>%
  mutate(defect = fct_reorder(defect,count, .desc=TRUE)) %>%
  mutate(product = fct_reorder(product,count, .desc=FALSE))

df4 %>%
  filter(defect != 'good_pipe') %>%
  group_by(defect, product) %>%
  summarise(total = sum(count)) %>%
  ggplot(aes(x=defect, y=total,fill = product)) +
  geom_col() + 
  scale_fill_brewer(palette = "Reds") +
  labs(title = "Total pipe rejected by product and defect type") +
  theme(axis.text.x = element_text(size = 11, face ="bold"),
        legend.text = element_text(size = 11),
        plot.title = element_text(size = 16, hjust=0.5))

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
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent)

df6 %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_area(stat = "bin", binwidth = 2, position = "fill") +
  scale_x_continuous(breaks = seq(0, 100, by = 10)) +
  scale_y_continuous(labels = percent) +
  geom_hline(yintercept=0.25, linetype="dashed") + 
  scale_fill_brewer(palette = "Greens") +
  labs(title = "DN150 & DN225/175 defect rate by batch") +
  theme(axis.text.x = element_text(size = 11, face ="bold"),
        legend.text = element_text(size = 11),
        plot.title = element_text(size = 16, hjust=0.5))


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

#Filter DN150 for further analysis
df150 <- df6 %>%
  filter(product == 'DN150') %>%
  filter(!is.na(drying_batch)) %>%
  filter(dryer_num>5) %>%
  filter(extruder_num == 1 | extruder_num == 3) %>%
  mutate(extruder_num = as.factor(extruder_num)) %>%
  mutate(dryer_num = as.factor(dryer_num)) %>%
  select(-2 & -4 & -8 & -11 & -12)

summary(df150)

df150 %>%
  ggplot(aes(x=kiln,fill=defect)) +
  geom_bar()

df150 %>%
  ggplot(aes(x=kiln,fill=defect)) +
  geom_bar(position = "fill")

df150 %>%
  ggplot(aes(x=dryer_num,fill=defect)) +
  geom_bar()

df150 %>%
  ggplot(aes(x=dryer_num,fill=defect)) +
  geom_bar(position = "fill")

df150 %>%
  ggplot(aes(x=extruder_num,fill=defect)) +
  geom_bar()

df150 %>%
  ggplot(aes(x=extruder_num,fill=defect)) +
  geom_bar(position = "fill")

df150 %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)

df150 %>%
  filter(defect == 'good_pipe' | defect == 'CNT_c') %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)

df150 %>%
  filter(defect == 'good_pipe' | defect == 'bend_pipe') %>%
  ggplot(aes(x=batch,fill=defect)) +
  geom_density(alpha = 0.5) +
  facet_grid(defect ~ .)
