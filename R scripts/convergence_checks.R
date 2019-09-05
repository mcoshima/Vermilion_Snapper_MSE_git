calc_ABC <- function(OFL, P_star, dat.list){
  
  ABC <- OFL - (OFL*P_star)
  catch <- ABC*flt_prop
  
}


hist.F %>% filter(Yr > 2011) %>% select(-1) %>% colMeans() %>% sum()

f_prop <- c(0.05778353, 0.05120693, 0.05743683, 0.05248127, 0.07423790)/ 0.2931465

0.0334460 * f_prop

#code taken from mseSS by Hicks et al. 

Numextract <- function(string){
  as.numeric(unlist(regmatches(string,gregexpr("\\-*[[:digit:]]+\\.*[[:digit:]]*",string))))
}

check_convergence <- function(dir.){
  
  par.file <- paste0(dir., "/ss3.par")
  convCheck <- readLines(par.file,n=1)
  convCheck <- Numextract(convCheck)
  
  if(length(convCheck) > 3){
    convCheck <- gsub("-", "e-", convCheck)
    convCheck[3] <- paste0(convCheck[3], convCheck[4]) 
    convCheck[4] <- NULL
      }
  # convCheck is now a vector of three values:
  # 1. Number of parameters
  # 2. Objective function value
  # 3. Maximum gradient component
  
  return(convCheck)
  
  }

jit_for_converg <- function(convCheck, dir.){
  
  .CONV_CRITERIA         <- 0.1
  .MAX_ITERATIONS        <- 3
  .JITTER                <- 1e-5
  .JITTER_MULTIPLIER     <- 10
  
  iteration <- 1
  jit <- .JITTER
  while(as.numeric(convCheck[3]) > .CONV_CRITERIA & iteration < .MAX_ITERATIONS){
    # Redo the assessment with jitter if gradient is less than the convergence criterion
    iteration <- iteration + 1
    print("Redoing assessment due to non-convergence")
    starter <- SS_readstarter(paste0(dir., "/starter.ss"))
    starter$jitter_fraction <- jit
    SS_writestarter(starter,dir=dir.,file="starter.ss",overwrite=T)
    shell(paste("cd/d", dir., "&& ss3", sep = " "))
    
    convCheck <- check_convergence(dir.)
    
    jit <- jit * .JITTER_MULTIPLIER
  }
  if(convCheck < .CONV_CRITERIA){
    converged <- T
  }else{
    converged <- F
  }
  
  return(converged)
  
}

##Function to copy files over to new folder after assessment
copy_files <- function(year, dat.list, dir.){
  assess.yr <- dat.list$year_seq[year]
  current.dir <- dir.
  new.path <- paste0(dir., "/assessments", "/Year_", assess.yr)
  dir.create(new.path)
  assess.files <- list("forecast.ss", 
                       "starter.ss", 
                       "VS.dat", 
                       "VS.ctl", 
                       "Report.sso", 
                       "Forecast-report.sso", 
                       "ss3.PAR")
  file.copy(file.path(current.dir, assess.files), new.path)
  
}
