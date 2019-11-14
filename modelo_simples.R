

data <- rbeta(n = 10000, shape1 = 1.5, shape2 = 3) %>% 
  enframe(value = "trigger") %>% 
  mutate()


data_stan <- list(N = 10000, y = data)


fit <- stan(file = "simple_test.stan", data = data_stan)

print(fit)


