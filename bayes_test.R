library(rstan)
library(tidyverse)
library(lubridate)

library(worldmet)

# rio <- worldmet::getMeta("rio de janeiro") 
# 
#data_rio <- worldmet::importNOAA(code = "868870-99999", hourly = FALSE, year = 2010:2019)

daily_means <- data_rio %>%
  group_by(date = date(date)) %>%
  summarise(air_temp = mean(air_temp)) %>% 
  mutate(id = row_number() )

n_days <- nrow(daily_means)

n_pop <- 1000

aleat <- rnorm(n_days * n_pop,mean = 0.05, sd = 0.01) %>% 
  enframe(name = "line", value = "increase_air" )


load_no_ac <- rnorm(n_days, 0, 1.05^(1/252)-1 ) %>%
  enframe(name = "id", value = "noise") %>%
  mutate(persistence = rt(n_days,df = 3 ) * (1.1^(1/252)-1) + 1.01^(1/252) - 1  ) %>%
  mutate(fator_ewma = id*(1/0.91)*1e-10) %>%
  mutate(trend = cumsum(fator_ewma * persistence)/cumsum(fator_ewma)) %>%
  mutate(load_no_ac = cumprod((1 + trend) * (1 + noise) ) ) %>%
  inner_join(daily_means, by = c("id")) %>% 
  mutate(pop = map( .x = NA,   .f = ~ rbeta(1000, shape1 = 1.5, shape2 = 3 ) * 10 + 25  )) %>% 
  unnest(pop) %>% 
  mutate(line = row_number()) %>% 
  inner_join(aleat, by = c("line")) %>%   
  mutate(turn_on = air_temp > pop ) %>% 
  mutate(load = turn_on * aleat + 1 ) %>% 
  select(c(-turn_on, -aleat )) %>% 
  group_by_at(vars(c(-pop, -load))) %>% 
  summarise(n = n(), turned_on = sum(load) )






