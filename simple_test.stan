// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] trigger;
  vector[N] temperatura;
  vector[N] carga;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  trigger ~ beta(alpha, beta);
}

