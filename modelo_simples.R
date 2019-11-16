
library(tidyverse)
library(rstan)

options(mc.cores = parallel::detectCores())

rstan_options(auto_write = TRUE)

Sys.setenv(LOCAL_CPPFLAGS = '-march=corei7')

alpha <- 1
beta <- 8

sample_betas <- rbeta(10000, alpha, beta)

cdf_betas <- ecdf(sample_betas)
# 
# data_1 <- 1:100 %>% 
#   enframe(value = "dia") %>% 
#   mutate(
#     low = 0 ,
#     high = 1
#   ) %>% 
#   mutate( temp = map2_dbl(.x = low ,  .y = high, .f = ~runif(1, low, high)   )  ) %>% 
#   mutate( beta )
#   View()
#   
#   
#   
# 
# data_2 <- 1:100 %>% 
#   enframe(value = "dia") %>% 
#   mutate(shape1 = 4, shape2 = 5) %>% 
#   mutate(carga_2 = map2( .x = shape1, .y = shape2, .f = ~ rbeta(2, shape1 = .x, shape2 = .y ) )) %>% 
#   unnest(cols = c(carga_2)) %>% 
#   group_by(dia) %>% 
#   summarise(carga_2 = sum(carga_2) )
# 
# data <- data_1 %>% 
#   inner_join(data_2, by = c("dia")) %>% 
#   mutate(carga_total = (carga_1 + carga_2)/2)
#   
# 
# 
# 
# data_stan <- list(
#   n_dias = 100,
#   n_pop_1 = 4,
#   n_pop_2 = 2,
#   carga_total = data$carga_total
# )
# 
# 
# fit <- stan(file = "simple_test2.stan", data = data_stan)
# 
# print(fit)
# 


seq(0,1,0.01) %>% 
  enframe(value = "x") %>% 
  mutate(y = cdf_betas(x)) %>% 
  ggplot() +
  geom_line(aes(x = x, y = y))



