
data <- rbeta(n = 1000, shape1 = 1.5, shape2 = 3) %>% 
  enframe(value = "trigger") 

temperaturas <- rnorm(1000, mean = 0.5, sd = 0.3 ) %>% 
  enframe(value = "temperatura")

# data %<>% 
#   inner_join(temperaturas) %>% 
#   mutate(carga = (temperatura > trigger) * 1 ) %>% 
#   mutate(diff = temperatura - trigger )

data_1 <- 1:100 %>% 
  enframe(value = "dia") %>% 
  mutate(shape1 = 1.5, shape2 = 3) %>% 
  mutate(carga_1 = map2( .x = shape1, .y = shape2, .f = ~ rbeta(100, shape1 = 1.5, shape2 = 3 ) )) %>% 
  unnest(cols = c(carga_1)) %>% 
  group_by(dia) %>% 
  summarise(carga_1 = sum(carga_1) ) 

data_2 <- 1:100 %>% 
  enframe(value = "dia") %>% 
  mutate(shape1 = 1.5, shape2 = 3) %>% 
  mutate(carga_2 = map2( .x = shape1, .y = shape2, .f = ~ rbeta(50, shape1 = 4, shape2 = 5 ) )) %>% 
  unnest(cols = c(carga_2)) %>% 
  group_by(dia) %>% 
  summarise(carga_2 = sum(carga_2) )

data <- data_1 %>% 
  inner_join(data_2, by = c("dia")) %>% 
  mutate(carga_total = carga_1 + carga_2)
  


data_stan <- list(
  N = 1000,
  trigger = data$trigger,
  temperatura = data$temperatura,
  carga = data$carga
)


fit <- stan(file = "simple_test.stan", data = data_stan)

print(fit)


