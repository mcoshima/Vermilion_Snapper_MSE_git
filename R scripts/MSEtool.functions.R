##Harvest control rules from MSEtool:

#function that gives a vector of lognormal estimates or if reps = 1, returns the mean. From DLMtool
trlnorm <- function(reps, mu, cv) {
  if (all(is.na(mu))) return(rep(NA, reps))
  if (all(is.na(cv))) return(rep(NA, reps))
  if (reps == 1)  return(mu)
  return(rlnorm(reps, mconv(mu, mu * cv), sdconv(mu, mu * cv)))
}

#' Calculate MSY-based TAC from Assessment object
#'
#' A function to calculate the total allowable catch (TAC). Based on the MSY (maximum
#' sustainable yield) principle, the TAC is the product of
#' either UMSY or FMSY and the available biomass, i.e. vulnerable biomass, in terminal year.
#'
#' @param Assessment An Assessment object with estimates of UMSY or FMSY and
#' terminal year vulnerable biomass.
#' @param reps The number of stochastic draws of UMSY or FMSY.
#' @param MSY_frac The fraction of FMSY or UMSY for calculating the TAC (e.g. MSY_frac = 0.75 fishes at 75\% of FMSY).

#UMSY Estimate of exploitation at maximum sustainable yield.

TAC_MSY <- function(Assessment, reps, MSY_frac = 1) {
  has_UMSY <- length(Assessment@UMSY) > 0
  has_FMSY <- length(Assessment@FMSY) > 0
  has_VB <- length(Assessment@VB) > 0

  if(Assessment@conv && has_VB && (has_UMSY || has_FMSY)) {
    VB_current <- Assessment@VB[length(Assessment@VB)]
    if(has_UMSY) {
      if(length(Assessment@SE_UMSY) > 0) {
        SE_UMSY <- Assessment@SE_UMSY
      } else SE_UMSY <- 1e-8
      UMSY_vector <- trlnorm(reps, Assessment@UMSY, SE_UMSY)
      TAC <- MSY_frac * UMSY_vector * VB_current
    }
    if(has_FMSY) {
      if(length(Assessment@SE_FMSY) > 0) {
        SE_FMSY <- Assessment@SE_FMSY
      } else SE_FMSY <- 1e-8
      FMSY_vector <- trlnorm(reps, Assessment@FMSY, SE_FMSY)
      TAC <- (1 - exp(-MSY_frac * FMSY_vector)) * VB_current
    }
  } else {
    TAC <- rep(NA, reps) # Missing estimates for HCR.
  }
  return(as.numeric(TAC))
}



HCR_MSY <- function(Assessment, reps =1, MSY_frac = 1, ...){
	
	TAC <- TAC_MSY(Assessment, reps, MSY_frac)
	Rec <- new("Rec")
	Rec@TAC <- TACfilter(TAC)
	return(Rec)
}

#' Generic linear harvest control rule based on biomass
#'
#' A general function used by HCR_ramp that adjusts the TAC by a linear ramp based on estimated biomass.
#'
#' @param Brel Improper fraction: An estimate of biomass (either absolute
#' or relative, e.g. B/BMSY or B/B0).
#' @param LRP Improper fraction: the Limit Reference Point, the biomass
#' below which the adjustment is at its minimum, e.g. zero, no fishing. Same units as \code{Brel}.
#' @param TRP Improper fraction: the Target Reference Point, the biomass
#' above which the adjustment is at its maximum. Same units as \code{Brel}.
#' @param rel_min The relative maximum value (e.g. a multiple of FMSY) if \code{Brel < LRP}.
#' @param rel_max The relative maximum value (e.g. a multiple of FMSY) if \code{Brel > TRP}.
#' @return a TAC or TAE adjustment factor.
#' @author T. Carruthers
#' @export HCRlin
#' @examples
#' #40-10 linear ramp
#' Brel <- seq(0, 1, length.out = 200)
#' plot(Brel, HCRlin(Brel, 0.1, 0.4), xlab = "Estimated B/B0", ylab = "Relative change in F",
#' main = "A 40-10 harvest control rule", type = 'l', col = 'blue')
#' abline(v = c(0.1,0.4), col = 'red', lty = 2)
#' 
HCRlin <- function(Brel, LRP, TRP, rel_min = 0, rel_max = 1){
  adj <- rep(rel_max, length(Brel))
  adj[Brel <= LRP] <- rel_min
  cond <- Brel>LRP & Brel<TRP
  adj[cond] <- (rel_max - rel_min)/(TRP - LRP) * (Brel[cond] - LRP) + rel_min
  adj
}


#' A Harvest Control Rule using B/BMSY and F/FMSY to adjust TAC or TAE.
#'
#' @param Brel improper fraction: an estimate of Biomass relative to BMSY
#' @param Frel improper fraction: an estimate of Fishing mortality rate relative to FMSY
#' @param Bpow non-negative real number: controls the shape of the biomass adjustment, when zero there is no adjustment
#' @param Bgrad non-negative real number: controls the gradient of the biomass adjustment
#' @param Fpow non-negative real number: controls the adjustment speed relative to F/FMSY. When set to 1, next recommendation is FMSY. When less than 1 next recommendation is between current F and FMSY.
#' @param Fgrad improper fraction: target Fishing rate relative to FMSY
#' @return a TAC or TAE adjustment factor.
#' @author T. Carruthers
#' @references Made up for this package
#' @export
#' @examples
#' res <- 100
#' Frel <- seq(1/2, 2, length.out = res)
#' Brel <- seq(0.05, 2, length.out=res)
#' adj <- array(HCR_FB(Brel[rep(1:res, res)], Frel[rep(1:res, each = res)],
#'                     Bpow = 2, Bgrad = 1, Fpow = 1, Fgrad = 0.75), c(res, res))
#' contour(Brel, Frel, adj, nlevels = 20, xlab = "B/BMSY", ylab = "F/FMSY",
#'         main = "FBsurface TAC adjustment factor")
#' abline(h = 1, col = 'red', lty = 2)
#' abline(v = 1, col = 'red', lty = 2)
#' legend('topright', c("Bpow = 2", "Bgrad = 1", "Fpow = 1", "Fgrad = 0.75"), text.col = 'blue')
#' 
HCR_FB<-function(Brel,Frel,Bpow=2,Bgrad=1,Fpow=1,Fgrad=1){
  Fresp <- exp(log(1/Frel)*Fpow)
  Bresp <- exp(powdif(Brel-1,Bpow,Bgrad))
  Fgrad*Bresp*Fresp
}




getF <- function(nsim,Esd,nyears,dFmin,dFmax,bb,scale){
  ne<-nsim*10
  dEfinal<-runif(ne,dFmin,dFmax)                        # Sample the final gradient in effort
  a<-(dEfinal-bb)/nyears                                # Derive slope to get there from intercept
  a<-array(a,dim=c(ne,nyears))                          # Slope array
  bb<-array(bb,dim=c(ne,nyears))                        # Intercept array
  x<-array(rep(1:nyears,each=ne),dim=c(ne,nyears))      # Year array
  dE<-a*x+bb                                            # Change in effort
  E<-array(NA,dim=c(ne,nyears))                         # Define total effort array
  E[,1]<-dE[,1]
  for(y in 2:nyears){
    E[,y]<-apply(dE[,1:y],1,sum)
  }
  
  E<-scale*E/array(apply(E,1,mean),dim=c(ne,nyears))          # Standardise Effort to average 1
  
  cond<-apply(E,1,min)>0
  pos<-(1:ne)[cond]
  pos<-pos[1:nsim]
  
  E<-E[pos,]                                            # Sample only those without negative effort
  Emu<--0.5*Esd^2
  Eerr<-array(exp(rnorm(nyears*nsim,rep(Emu,nyears),rep(Esd,nyears))),c(nsim,nyears))
  E*Eerr
}



