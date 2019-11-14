library(rstan)
library(tidyverse)
library(lubridate)
library(magrittr)

library(worldmet)

# rio <- worldmet::getMeta("rio de janeiro") 
# 
# data_rio <- worldmet::importNOAA(code = "868870-99999", hourly = FALSE, year = 2010:2019)

daily_means <- data_rio %>%
  group_by(date = date(date)) %>%
  summarise(air_temp = mean(air_temp)) %>% 
  mutate(id = row_number() )

n_days <- nrow(daily_means)

n_pop <- 1000



aleat <- rnorm(n_days * n_pop,mean = 0.1, sd = 0.2) %>% 
  enframe(name = "line", value = "increase_air" )

load_aleat <- rnorm(n_days * n_pop,mean = 1, sd = 0.2) %>% 
  enframe(name = "line", value = "load_no_air" )

aleat %<>% inner_join(load_aleat, by = c("line"))  


aleat_d <-  rnorm(n_days, mean = 1, sd = 0.03) %>% 
  enframe(name = "id", value = "aleat_daily" )


load_no_ac <- rnorm(n_days, 0, 1.05^(1/252)-1 ) %>%
  enframe(name = "id", value = "noise") %>%
  inner_join(aleat_d, by = c("id")) %>% 
  mutate(persistence = rt(n_days,df = 3 ) * (1.1^(1/252)-1) + 1.01^(1/252) - 1  ) %>%
  mutate(fator_ewma = id*(1/0.91)*1e-10) %>%
  mutate(trend = cumsum(fator_ewma * persistence)/cumsum(fator_ewma)) %>%
  mutate(load_no_ac = cumprod((1 + trend) * (1 + noise) ) ) %>%
  inner_join(daily_means, by = c("id")) %>% 
  mutate(shape1 = 1.5, shape2 = 3) %>% 
  mutate(pop = map2( .x = shape1, .y = shape2, .f = ~ rbeta(n_pop, shape1 = .x, shape2 = .y ) * 10 + 22 )) %>% 
  unnest(pop) %>% 
  mutate(line = row_number()) %>% 
  inner_join(aleat, by = c("line")) %>%
  mutate(turn_on = air_temp > pop ) %>% 
  mutate(load = turn_on * increase_air + load_no_air ) %>% 
  select(c(-turn_on,-increase_air,-line, -load_no_air)) %>%
  group_by_at(vars(-one_of("load", "pop", "aleat_daily"))) %>%
  summarise(
    aleat_daily = mean(aleat_daily), 
    n = n(), 
    turned_on = (sum(load) - mean(aleat_daily) * n_pop   )/n_pop ) 



ggplot(load_no_ac, aes(x = air_temp, y = turned_on)) +
  geom_point() +
  geom_smooth()
















