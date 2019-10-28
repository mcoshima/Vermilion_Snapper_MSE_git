#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_MATRIX(Nvs); //Vermilion N
  DATA_MATRIX(Nrs); //Red N
  DATA_INTEGER(Nyear);
  DATA_INTEGER(Nage);
  DATA_INTEGER(Nage_r);
  DATA_VECTOR(Lvs);
  DATA_VECTOR(Lrs);
  DATA_VECTOR(F);
  DATA_VECTOR(Latage_VS);
  DATA_VECTOR(Latage_RS);
  
  PARAMETER(dummy);
  PARAMETER_VECTOR(M1);
  PARAMETER_MATRIX(M2);
  PARAMETER(q);
  PARAMETER(beta);
  PARAMETER_MATRIX(chi);
  PARAMETER(Sig_log);
  PARAMETER(Sigma_log);
  PARAMETER_MATRIX(Z);
  PARAMETER_MATRIX(Nfit);

  Type Sig = exp(Sig_log);
  Type Sigma = exp(Sigma_log);
  Type obj_fun;
  Type likeNfit;

  //Compute chi
  for(int age = 0; age < Nage; age++){
    for(int r_age = 0; r_age < Nage_r; r_age++){
        chi(age, r_age) = ((Lvs(age) - q * Lrs(r_age))*(Lvs(age) - q * Lrs(r_age)))/(Sig*Sig);
    }
  }

  //Compute M2
  Type temp = 0;
  for(int year = 0; year < Nyear; year++){
    for(int age = 0; age < Nage; age++){
      for(int r_age = 0; r_age < Nage_r; r_age++){
       temp(year) += chi(age, r_age) * Nrs(year, r_age);
      }
     M2(year, age) = beta * temp(year);
    }
  }

  //Compute Z
  //for(int year = 0; year < Nyear; year++){
  //  for(int age = 0; age < Nage; age++){
  //    Z(year, age) = M1(age) + M2(year, age) + F(year, age);
  //  }
  //}

  //Compute N
 // for(int year = 0; year < Nyear; year++){
   // for(int age = 0; age < Nage; age++){
   //   Nfit(year+1, age+1) = Nvs(year-1, age-1)*exp(-Z(year-1, age-1));
   // }
 // }

  //Likelihood components

  likeNfit = 0;
  
 // for(int age = 0; age < Nage; age++){
  //  for(int r_age = 0; r_age < Nage_r; r_age++){
  //      likeNfit -= dnorm(Nvs(year,age), Nfit(year,age), Sigma, true);
  //  }
 // }

  obj_fun = dummy*dummy + likeNfit;

  REPORT(obj_fun);
  REPORT(likeNfit);
  REPORT(M2);
  REPORT(chi);
  REPORT(beta);

  return(obj_fun);

  }








