// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n_dias;
  real temp[n_dias];
  real on[n_dias];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  
  real<lower = 0> alpha;
  real<lower = 0> beta;
  real<lower = 0> sigma;
  real<lower = 0> low;
  real<lower = 0> scale;
  

}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {

  alpha ~ uniform(0,10);
  beta ~ uniform(0,10);
  sigma ~ uniform(0.0,0.5);
  low ~ uniform(20,30);
  scale ~ uniform(5,15);
  for(i in 1:n_dias){
    target += normal_lpdf(on[i] | beta_cdf(fmax(fmin((temp[i]-low)/scale,0.99),0.01), alpha, beta), sigma);
    print(low);
    print(scale);
    print(temp[i]);
    print(fmax(fmin((temp[i]-low)/scale,0.99),0.01));
  }
}

