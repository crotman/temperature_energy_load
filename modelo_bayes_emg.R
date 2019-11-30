
library(tidyverse)
library(rstan)
library(sn)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')


 


cdf_betas <- ecdf(sample_betas)

n_dias <- 100


data <- 1:n_dias %>%
  enframe(value = "dia") %>%
  mutate(
    low = 20 ,
    high = 40
  ) %>%
  mutate( temp = map2_dbl(.x = low ,  .y = high, .f = ~runif(1, low, high)   )  ) %>%
  mutate( on = (cdf_betas((temp-25)/10)  ))



data_stan <- list(
  n_dias = n_dias,
  temp = data$temp,
  on = data$on
)


fit <- stan(file = "simple_test3.stan", data = data_stan, verbose = TRUE, chains = 1)

print(fit)

