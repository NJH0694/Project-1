#Group defects by batch and convert to percentage
bf <- cf3 %>%
  group_by(batch) %>%
  summarise(bend_pipe = sum(bend_pipe),
            CNT_c = sum(CNT_c),
            explode = sum(explode),
            socket_issue = sum(socket_issue),
            other_crack = sum(other_crack),
            other = sum(other),
            good_pipe = sum(good_pipe),
            total_pipe = sum(total_pipe)) %>%
  mutate(bend_pipe = bend_pipe / total_pipe *100) %>%
  mutate(CNT_c = CNT_c / total_pipe *100) %>%
  mutate(explode = explode / total_pipe *100) %>%
  mutate(socket_issue = socket_issue / total_pipe *100) %>%
  mutate(other_crack = other_crack / total_pipe *100) %>%
  mutate(other = other / total_pipe *100) %>%
  mutate(good_pipe = good_pipe / total_pipe *100)%>%
  print()

ggpairs(bf)

bf2 <- bf %>%
  select(-9) %>%
  pivot_longer(cols=2:8,names_to = "defect", values_to = "percentage") %>%
  mutate(defect = as.factor(defect))

#Visualize
bf2 %>%
  ggplot(aes(x=batch,y=percentage)) +
  geom_point(size = 3, mapping = aes(color=defect)) +
  geom_smooth(mapping = aes(color=defect), size = 1)

#Filter bend pipe (major defect)
bf2 %>%
  filter(defect == 'bend_pipe') %>%
  ggplot(aes(x=batch,y=percentage)) +
  geom_point(size = 3) +
  geom_smooth(method = lm,size = 1)

#Create linear model
reg <- bf2 %>%
  filter(defect == 'bend_pipe') %>%
  select(percentage, batch) %>%
  lm()

reg
reg %>% summary()
reg %>% confint()
reg %>% predict()
reg %>% plot()

#Filter yield
bf2 %>%
  filter(defect == 'good_pipe') %>%
  ggplot(aes(x=batch,y=percentage)) +
  geom_point(size = 3) +
  geom_smooth(method = lm,size = 1)

reg2 <- bf2 %>%
  filter(defect == 'good_pipe') %>%
  select(percentage, batch) %>%
  lm()

reg2
reg2 %>% summary()
reg2 %>% confint()
reg2 %>% predict()
reg2 %>% plot()

#Multiple regression
bf3 <- bf %>%
  select(-8:-9)
bf3 %>% lm()
lm(batch ~ ., data = bf3)
reg3 <- lm(batch ~ bend_pipe + CNT_c + explode +
     socket_issue + other_crack + other, data = bf3)

reg3
reg3 %>% summary()
reg3 %>% confint()
reg3 %>% predict()
reg3 %>% plot()

