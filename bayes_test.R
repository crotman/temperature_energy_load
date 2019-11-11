library(rstan)
library(tidyverse)
library(lubridate)

library(worldmet)

# rio <- worldmet::getMeta("rio de janeiro") 
# 
data_rio <- worldmet::importNOAA(code = "868870-99999", hourly = FALSE, year = 2010:2016)

daily_means <- data_rio %>%
  group_by(date(date)) %>%
  summarise(air_temp = mean(air_temp)) %>% 
  mutate(id = row_number() )

n_days <- nrow(daily_means)

load_no_ac <- rnorm(n_days, 0, 1.05^(1/252)-1 ) %>%
  enframe(name = "id", value = "noise") %>%
  mutate(persistence = rt(n_days,df = 3 ) * (1.1^(1/252)-1) + 1.01^(1/252) - 1  ) %>%
  mutate(fator_ewma = id*(1/0.91)*1e-10) %>%
  mutate(trend = cumsum(fator_ewma * persistence)/cumsum(fator_ewma)) %>%
  mutate(load_no_ac = cumprod((1 + trend) * (1 + noise) ) ) %>%
  mutate(pop = map( .x = NA,   .f = ~ rbeta(1000, shape1 = 1.5, shape2 = 3 ) * 10 + 25  )) %>% 
  unnest(pop) %>% 
  group_by_at(vars(-pop))






