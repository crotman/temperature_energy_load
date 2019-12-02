
sample_sn <- rsn(10000,  xi = 23.24, omega = 9.65, alpha = 2.19)


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
  select(temp_comp_media, erro) %>% 
  filter( erro > 0.0001 ) %>% 
  filter(!is.na(temp_comp_media)) %>% 
  filter(!is.na(erro)) %>% 
  mutate(on = erro /  max(erro + 0.0001 ) ) %>% 
  rename(temp = temp_comp_media) 




ggplot(data_cdf) +
  geom_point(aes(x = temp, y = on)) +
  geom_point(data = data_rj, aes(y = on, x = temp), color = "blue" )






