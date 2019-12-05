
library(tidyverse)
library(rstan)
library(sn)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')


data_ewma <- read_rds("dados_rj.rds") %>% 
  select(temp_ewma, erro) %>% 
  filter( erro > 0.0001 ) %>% 
  filter(!is.na(temp_ewma)) %>% 
  filter(!is.na(erro)) %>% 
  mutate(on = erro /  max(erro + 0.0001 ) ) %>% 
  rename(temp = temp_ewma) 


n_dias <- nrow(data_ewma)


ggplot(data_ewma) +
  geom_point(aes(x = temp, y = on))



data_stan <- list(
  n_dias = n_dias,
  temp = data_ewma$temp,
  on = data_ewma$on
)


initf1 <- function() {
  list(xi = runif(1,20,30), omega = runif(1,0.1,20), alpha = runif(1,-5,5), sigma = runif(1,0.1,0.20))
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


write_rds(fit,"fit_ewma_4_xi2030_omega_0_20_alpha_5_5_sigma_020_iguais.rds" ) 


