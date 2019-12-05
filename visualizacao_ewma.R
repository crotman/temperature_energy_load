
sample_sn <- rsn(10000,  xi = 26.50, omega = 4.73, alpha = 0.76)


sample_sn %>%
  enframe() %>% 
  ggplot() +
  geom_density(aes(x = value))


cdf_sn <- ecdf(sample_sn)

n_dias <- 5000


data_cdf <- 1:n_dias %>%
  enframe(value = "dia") %>%
  mutate(
    mu = 27 ,
    sigma = 4
  ) %>%
  mutate( temp = map2_dbl(.x = mu ,  .y = sigma, .f = ~rnorm(1, .x, .y)   )  ) %>%
  mutate( on = cdf_sn(temp)) %>% 
  filter(on > 0.01 & on < 0.99 )

data_cdf <- 1:n_dias %>%
  enframe(value = "dia") %>%
  mutate(
    mu = 27 ,
    sigma = 4
  ) %>%
  mutate( temp = map2_dbl(.x = mu ,  .y = sigma, .f = ~rnorm(1, .x, .y)   )  ) %>%
  mutate( on = cdf_sn(temp)) %>% 
  filter(on > 0.01 & on < 0.99 )


data_rj <- read_rds("dados_rj.rds") %>% 
  select(temp_ewma, erro) %>% 
  filter( erro > 0.0001 ) %>% 
  filter(!is.na(temp_ewma)) %>% 
  filter(!is.na(erro)) %>% 
  mutate(on = erro /  max(erro + 0.0001 ) ) %>% 
  rename(temp = temp_ewma) 




ggplot(data_cdf) +
  geom_point(aes(x = temp, y = on)) +
  geom_point(data = data_rj, aes(y = on, x = temp), color = "blue" )





