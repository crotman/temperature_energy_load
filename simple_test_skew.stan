// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> n_dias;
  real temp[n_dias];
  real on[n_dias];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  
  real<lower=15, upper=40> xi;
  real<lower=0, upper=30> omega;
  real<lower=-30, upper=30> alpha;
  real<lower = 0> sigma;
  

}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {

  /*
  {
    vector[n_dias] summands;
    for(i in 1:n_dias){
      summands[i] = normal_lpdf(on[i] | skew_normal_cdf(temp[i], xi, omega, alpha)  , sigma);
    }
    target += sum(summands);
  }
  */

  for(i in 1:n_dias){
    xi ~ uniform(20,30);
    omega ~ uniform(0.1,20);
    alpha ~ uniform(-20,20);
    sigma ~ uniform(0.01,0.20);
    target += normal_lpdf(on[i] | skew_normal_cdf(temp[i], xi, omega, alpha), sigma);
    /*
    print(i)
    print("temp:",temp[i]);
    print("on:",on[i]);
    print("xi:",xi);
    print("omega:",omega);
    print("alpha:",alpha);
    print("skew_normal:",skew_normal_cdf(temp[i], xi, omega, alpha), sigma);
    */
  }
    

}

