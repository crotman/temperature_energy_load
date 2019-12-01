// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n_dias;
  real temp[n_dias];
  real on[n_dias];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  
  real xi;
  real<lower=0> omega;
  real alpha;
  real<lower = 0> sigma;
  

}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {

  xi ~ normal(27,100);
  omega ~ normal(2,100);
  alpha ~ normal(3,100);
  sigma ~ uniform(0.01,0.05);
  /*
  {
    vector[n_dias] summands;
    for(i in 1:n_dias){
      summands[i] = normal_lpdf(on[i] | skew_normal_cdf(temp[i], xi, omega, alpha)  , sigma);
    }
    target += sum(summands);
  }
  */

  for(i in 1:n_dias)  
    on[i] ~ normal(skew_normal_cdf(temp[i], xi, omega, alpha), sigma);

}

