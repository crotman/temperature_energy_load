//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n_dias;
  int<lower=0> n_pop;
  vector[n_dias] air_temp;
  vector[n_dias] load_increase;
  
}
transformed data{
  
}
parameters {
  real mu_daily_load;
  real<lower=0> sigma_daily_load;
  real<lower=0> alpha_beta;
  real<lower=0> beta_beta;
  real<lower=0> range_beta;
  real start_beta;
  real theta;
  real turn_on[n_dias, n_pop];
}
transformed parameters {
  
}
model {
  for(i in 1:n_dias)
    turn_on[i] ~ beta(alpha_beta, beta_beta);
  for(i in )  
  
  
}

