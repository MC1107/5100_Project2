library(tidyverse)
ted_data <- read_csv("ted_main.txt") %>%
  group_by(tag) %>%  
  summarise(sum = n())
write.csv(ted_data, file = "MyData.csv")