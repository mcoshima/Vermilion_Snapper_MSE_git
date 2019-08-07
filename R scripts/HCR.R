## Calculate catch given alpha, beta, and Fmsy_proxy values
###Punt et al. 2008. Evaluation of threshold management strategies for groundfish off the U.S. West Coast


HCR_catch <- function(rp = ref.points, HCR_strategy = "HCR_strategy", wtatage = wtatage, N = N, year = year, Z = z){
  
  ref_points <- rp[[year]]
  alpha <- switch(HCR_strategy, 
                  "40_10" = 0.1,
                  "20_60" = 0.2)
  
  beta <- switch(HCR_strategy, 
                 "40_10" = 0.4, 
                 "20_60" = 0.6)
  
  C_f <- matrix(data = NA, nrow= 4, ncol = Nages)
  catch <- matrix(data = NA, nrow = 4, ncol = Nages)
  
  if(ref_points$bratio < alpha){
    catch <- matrix(data = 0, nrow = 4, ncol = 15)
  }
  
  if(alpha <= ref_points$bratio & ref_points$bratio < beta){
    for(i in 1:4){
      
      C_f[i,] <- unlist(wtatage[1,]*N[year,-1]*((sel[i,]*ref_points$Fspr30)/(Z))*(1-exp(-Z)))
      
      catch[i, ] <- (beta*ref_points$SSB0/ref_points$SSB_cur)*((ref_points$bratio-alpha)/(beta-alpha))*(C_f[i, ])

    }
    
  }
  
  if(ref_points$bratio >= beta){
    for(i in 1:4){
      
      catch[i,] <- unlist(wtatage[1,]*N[year,-1]*((sel[i,]*ref_points$Fspr30)/(Z))*(1-exp(-Z)))
    
    }
  }
  return(catch)
}


HCR_catch(ref.points, "40_10", wtatage, N, year, z)


#Empirical rule
##average ratio of current IOAs to previous years times the OFL from SS forecast
newOFL <- mean(I[year,]/I[year-2,])*OFL

com_catch <- newOFL/2


dat.$catch

