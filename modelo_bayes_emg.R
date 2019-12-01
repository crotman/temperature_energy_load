
library(tidyverse)
library(rstan)
library(sn)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')


sample_sn <- rsn(10000,  xi = 27, omega = 3, alpha = 3)



sample_sn %>%
  enframe() %>% 
  ggplot() +
  geom_density(aes(x = value))



cdf_sn <- ecdf(sample_sn)

n_dias <- 5000


data <- 1:n_dias %>%
  enframe(value = "dia") %>%
  mutate(
    mu = 27 ,
    sigma = 4
  ) %>%
  mutate( temp = map2_dbl(.x = mu ,  .y = sigma, .f = ~rnorm(1, .x, .y)   )  ) %>%
  mutate( on = cdf_sn(temp)) %>% 
  filter(on > 0.01 & on < 0.99 )

n_dias <- nrow(data)


ggplot(data) +
  geom_point(aes(x = temp, y = on))



data_stan <- list(
  n_dias = n_dias,
  temp = data$temp,
  on = data$on
)


initf1 <- function() {
  list(xi = rnorm(1,28,2), omega = 3, alpha = 3, sigma = 0.02)
}


fit <- stan(
  file = "simple_test_skew.stan", 
  data = data_stan, 
  verbose = TRUE, 
  chains = 1,
  iter = 1000
  ,
  control = list(adapt_delta = 0.99),
  init = initf1
  
)

print(fit)

