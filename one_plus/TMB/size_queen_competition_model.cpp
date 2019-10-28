#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_MATRIX(Nvs); //Vermilion N
  DATA_MATRIX(Nrs); //Red N
  DATA_INTEGER(Nyear);
  DATA_INTEGER(Nlbin);
  //DATA_INTEGER(Nrlbin);
  DATA_INTEGER(K);
  
  PARAMETER(Sigma_log);
  PARAMETER_VECTOR(Beta);
  PARAMETER(Beta_mu);
  PARAMETER(Sigma_beta);

  matrix<Type> Nfit(Nyear, Nlbin);
  Type Sigma_b = exp(Sigma_beta);
  Type Sigma = exp(Sigma_log);
  
  Type obj_fun;
  Type likebeta;
  Type likeN;

  // compute Nfit
  for(int year = 0; year < Nyear; year ++){
    for(int l = 0; l < Nlbin; l ++){
      //for(int rl = 0; rl < Nrlbin; rl++){
	Nfit(year, l) = Nvs(year, l)* (K - Nrs(year, l) - Beta(l) * Nrs(year, l))/K;
        //}
      }
    }
  
  //Likelihood component

  likebeta = 0;
  
  for(int l = 0; l < Nlbin; l ++){
    likebeta -= dnorm(Beta(l), Beta_mu, Sigma_b, true);

  likeN = 0;

  for(int year = 0; year < Nyear; year ++){
    likeN -= dnorm(Nvs(year,l), Nfit(year,l), Sigma, true);
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
