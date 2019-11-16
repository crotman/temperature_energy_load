
library(tidyverse)
library(rstan)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')

alpha <- 3
beta <- 2

sample_betas <- rbeta(10000, alpha, beta)

cdf_betas <- ecdf(sample_betas)

n_dias <- 1000


data <- 1:n_dias %>%
  enframe(value = "dia") %>%
  mutate(
    low = 0 ,
    high = 1
  ) %>%
  mutate( temp = map2_dbl(.x = low ,  .y = high, .f = ~runif(1, low, high)   )  ) %>%
  mutate( on = cdf_betas(temp) )



data_stan <- list(
  n_dias = n_dias,
  temp = data$temp,
  on = data$on
)


fit <- stan(file = "simple_test3.stan", data = data_stan)

print(fit)

