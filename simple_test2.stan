// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n_dias;
  int<lower=0> n_pop_1;
  int<lower=0> n_pop_2;
  real carga_total[n_dias];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> alpha_1;
  real<lower=0> beta_1;
  real<lower=0> alpha_2;
  real<lower=0> beta_2;
  real<lower=0> sigma;
  real<lower=0, upper=1> carga_pop_1[n_dias,n_pop_1];
  real<lower=0, upper=1> carga_pop_2[n_dias,n_pop_2];
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {

  real medias[n_dias];
  
  alpha_1 ~ lognormal(2, 2);
  alpha_2 ~ lognormal(2, 2);
  beta_1 ~ lognormal(2, 2);
  beta_2 ~ lognormal(2, 2);
  
  
  for(i in 1:n_dias){
    carga_pop_1[i] ~ beta(alpha_1, beta_1);    
    carga_pop_2[i] ~ beta(alpha_2, beta_2);    
  }

  for(i in 1:n_dias){
    medias[i] = (sum(carga_pop_1[i]) + sum(carga_pop_2[i]))/2;
  }
  
  carga_total ~ normal(medias, sigma);
    
  
}
