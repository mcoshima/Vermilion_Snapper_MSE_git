##Harvest control rules from MSEtool:


UMSY Estimate of exploitation at maximum sustainable yield.

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