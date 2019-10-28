#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_MATRIX(Nvs); //Vermilion N
  DATA_MATRIX(Nrs); //Red N
  DATA_INTEGER(Nyear);
  DATA_INTEGER(Nage);
  DATA_INTEGER(K);
  
  //PARAMETER(dummy);
  PARAMETER(Sigma_log);
  PARAMETER_VECTOR(Beta);
  PARAMETER(Beta_mu);
  PARAMETER(Sigma_beta);

  matrix<Type> Nfit(Nyear, Nage);
  Type Sigma_b = exp(Sigma_beta);
  Type Sigma = exp(Sigma_log);
  
  Type obj_fun;
  Type likebeta;
  Type likeN;

  // compute Nfit
  for(int year = 0; year < Nyear; year ++){
    for(int age = 0; age < Nage; age ++){
	Nfit(year, age) = Nvs(year, age) * (K - Nrs(year, age) - Beta(age) * Nrs(year, age))/K;
      }
    }
  
  //Likelihood component

  likebeta = 0;
  
  for(int age = 0; age < Nage; age ++){
    likebeta -= dnorm(Beta(age), Beta_mu, Sigma_b, true);

  likeN = 0;

  for(int year = 0; year < Nyear; year ++){
    likeN -= dnorm(Nvs(year,age), Nfit(year,age), Sigma, true);
  }
  
  }
  obj_fun = likebeta + likeN;

  REPORT(obj_fun);
  REPORT(likebeta);
  REPORT(likeN);
  ADREPORT(Sigma);
  ADREPORT(Sigma_b);
  ADREPORT(Beta);
  REPORT(Beta_mu);
  
  return(obj_fun);
  }
