
library(tidyverse)
library(rstan)
library(sn)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')


data <- read_rds("dados_rj.rds") %>% 
  select(temp_comp_media, erro) %>% 
  filter( erro > 0.0001 ) %>% 
  filter(!is.na(temp_comp_media)) %>% 
  filter(!is.na(erro)) %>% 
  mutate(on = erro /  max(erro + 0.0001 ) ) %>% 
  rename(temp = temp_comp_media) 


n_dias <- nrow(data)


ggplot(data) +
  geom_point(aes(x = temp, y = on))



data_stan <- list(
  n_dias = n_dias,
  temp = data$temp,
  on = data$on
)


initf1 <- function() {
  list(xi = runif(1,20,30), omega = runif(1,0.1,20), alpha = runif(1,-20,20), sigma = runif(1,0.1,0.20))
}


fit <- stan(
  file = "simple_test_skew.stan", 
  data = data_stan, 
  verbose = TRUE, 
  chains = 4,
  iter = 4000
  # ,
  # control = list(adapt_delta = 0.99)
  ,
  init = initf1
  
)

print(fit)

