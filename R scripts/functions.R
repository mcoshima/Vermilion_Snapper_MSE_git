##Functions for the OM

###writing new data files

library(purrr)
library(reshape2)
library(r4ss)

year.seq <- seq(2014, 2014+50, by = .5)

nord_cols <- c("#4C566A", "#8FBCBB", "#88C0D0", "#B48EAD", "#A3BE8C", "#EBCB8B", "#D08770", "#BF616A")




splt.recombine <- function(df1, df2, ind, N){
  require("dplyr")
  
  names <- df2 %>% select_(ind) %>% unique() %>% pull() %>% as.character()
  
  split.dat <- df1 %>% group_by_(ind) %>% group_split() %>% setNames(names)
  
  split.new <- df2 %>% group_by_(ind) %>% group_split() %>% setNames(names)
  
  for(i in 1:N){
    
    x <- which(names(split.dat) == names(split.dat)[i])
    
    split.dat[[x]] <- rbind(as.data.frame(split.dat[x]),as.data.frame(split.new[i]))
    colnames(split.dat[[x]]) <- colnames(df1)
    
  }
  return(do.call(rbind, split.dat))
  
}


rand_intvect <- function(N, M, sd = 1, pos.only = TRUE) {
  vec <- rnorm(N, M/N, sd)
  if (abs(sum(vec)) < 0.01) vec <- vec + 1
  vec <- round(vec / sum(vec) * M)
  deviation <- M - sum(vec)
  for (. in seq_len(abs(deviation))) {
    vec[i] <- vec[i <- sample(N, 1)] + sign(deviation)
  }
  if (pos.only) while (any(vec < 0)) {
    negs <- vec < 0
    pos  <- vec > 0
    vec[negs][i] <- vec[negs][i <- sample(sum(negs), 1)] + 1
    vec[pos][i]  <- vec[pos ][i <- sample(sum(pos ), 1)] - 1
  }
  vec
}

rand_vect_cont <- function(N, M, sd = 1) {
  vec <- rlnorm(N, M/N, sd)
  vec / sum(vec) * M
}

#Deprecated
# age.to.length <- function(N,age,year,cvdist){
#   
#   age <- dat.list$Nages
#   
#   len.vec <- c()
#   for(n in 1:round(N[year,age+2],0)){ 
#     len.vec[n] <- linf*(1-exp(-k*(age-t0)))*exp(sample(cvdist, 1))
#   }
#   return(len.vec)
# }


zatage <- function(dat.list,year,f.by.fleet){
  
  M <- dat.list$M
  asel <- dat.list$age_selectivity
  Nages <- dat.list$Nages
  Nfishfleet <- dat.list$N_fishfleet
  f <- matrix(NA, nrow = Nfishfleet, ncol = Nages)
    for(fleet in 1:Nfishfleet){
  
      f[fleet,] <- as.numeric(asel[fleet,])*as.numeric(f.by.fleet[fleet])
    }
      Z <- as.numeric(M[year,]) + colSums(f)
      
  Z
}

catch.in.biomass <- function(dat.list,N,year,z,f.by.fleet){
  
  sel <- dat.list$age_selectivity
  wtatage <- dat.list$wtatage
  catch <- matrix(data = NA, nrow = 4, ncol = 15)
  for(fleet in 1:2){
    for(age in 1:15){
      
      catch[fleet, age] <-
        ((f.by.fleet[fleet]) / z[age]) * (1 - exp(- z[age])) * sel[fleet, age] * N[year-1, age+1] * wtatage[1  ,age]

    }}
  catch
}

catch.in.number <- function(dat.list,N,year,z,f.by.fleet){
  
  sel <- dat.list$age_selectivity
  bycatch.sel <- sel[4,]
  bycatch.sel[,2] <- .75
  se <- dat.list$catch_se
  catch <- matrix(data = NA, nrow = 4, ncol = 15)
  for(fleet in 1:3){
    for(age in 1:15){
      
      catch[fleet, age] <- ((f.by.fleet[fleet]) / z[age]) * (1 - exp(- z[age])) * sel[fleet, age] * N[year-1, age+1] *exp(rnorm(1,0,se[fleet]))
      
    }
  }
  
  catch[4, ] <- unlist(f.by.fleet[4] * bycatch.sel)
  catch
}
 
num_to_bio <- function(df, dat.list, Natage = T, age0 = F){
  #converts numbers-at-age to biomass-at-age or vice versa.
  #inputs need to be a dataframe, not a matrix
  #if Natage= T, means that you are giving it the N-at-age df to convert to biomass
  #if Natage = F, means that you are giving it the B-at-age df to convert to numbers
  #age0 = F means you don't want to include age0 in calculations, if T you do 
  wtatage <- dat.list$wtatage
  
  if(Natage == T){
    Batage <- matrix(NA, nrow= nrow(df), ncol = ncol(df))
    if(age0 == F){
      for(i in 1:nrow(df)){
        
        Batage[i,] <- unlist(df[i,]*wtatage[1,-1])
        
      }
    } else {
      for(i in 1:nrow(df)){
        
        Batage[i,] <- unlist(df[i,]*wtatage[1,])
        
      }
      
    }
    return(Batage)
  }else {
    Natage <- matrix(NA, nrow= nrow(df), ncol = ncol(df))
    if(age0 == F){
      for(i in 1:nrow(df)){
        
        Natage[i,] <- unlist(df[i,]/wtatage[1,-1])
        
      }
      
    } else {
      for(i in 1:nrow(df)){
        
        Natage[i,] <- unlist(df[i,]/wtatage[1,])
        
      }
      
    }
    
    return(Natage)
    
  }
}



simBatage <- function(N, dat.list, year){
  #Flt is the max = 3
  #asel is the age selectivity matrix

  wtatage <- dat.list$wtatage
  asel <- dat.list$age_selectivity
  Nages <- dat.list$Nages
  Flt <- dat.list$N_fishfleet
  b.age <- matrix(data = NA, nrow = 3, ncol = 15)
  for(fleet in 1:Flt){ 
    for(age in 1:Nages){#for fishery dependent surveys
      if(fleet < 3){
        
        b.age[fleet,age] <- N[year,age+1] *wtatage[,age] * asel[fleet,age]
      
        }else{
       
        b.age[fleet,age] <- N[year,age+1] * asel[fleet,age] 
        
      }
    }
  } 
  
  b.age
}

simBatlen <- function(Nlen, dat.list, year){
  #Flt is the number of fishery-independent surveys
  
  Flt <- dat.list$N_survey
  lsel <- dat.list$length_selectivity
  b.len <- matrix(NA, nrow = 2, ncol =12)
  for(fleet in 1:Flt){ 
    for(len in 1:ncol(Nlen)){
    if(fleet == 1){
      b.len[fleet,len] <- Nlen[year-1,len]*lsel[fleet,len]
    }else{
        b.len[fleet,len] <- Nlen[year,len]*lsel[fleet,len]
    }
    }
  }
  b.len
}



simAgecomp <-  function(catch.by.fleet, year, dat.list){
  year.seq <- dat.list$year_seq
  ageerror <- dat.list$ageerror
  agecompinfo.list<- list(
    Yr = rep(floor(year.seq[year]),3),
    Seas = rep(1,3),
    FltSvy = seq(1,3),
    # Gender = rep(0,3),
    Part = rep(2,3),
    Ageerr = rep(1,3),
    Lbin_lo = rep(-1,3),
    Lbin_hi = rep(-1,3),
    Nsamp = rep(75,3)) 
  
  n = 500
  prob <- catch.by.fleet[,-1]/apply(catch.by.fleet[,-1], 1, sum)
  flt1comp <- rmultinom(1, size = n, prob = prob[1,]*ageerror)/n
  flt2comp <- rmultinom(1, size = n, prob = prob[2,]*ageerror)/n
  flt3comp <- rmultinom(1, size = n, prob = prob[3,]*ageerror)/n
  
 
  comps <- rbind(t(flt1comp), t(flt2comp), t(flt3comp))
  colnames(comps) <- paste0("a",1:14)
  compinfo.list <- as.data.frame(do.call(cbind, agecompinfo.list))
  agecomp.list[[year]] <- cbind(compinfo.list, comps)
  return(agecomp.list[[year]])
  
}



simIndex <- function(dat.list,b){
  
  q <- dat.list$q
  se <- dat.list$CPUE_se
  I <- matrix(data = NA, nrow =1, ncol = 6)
  for(fleet in 1:6){
    
    I[, fleet] <- rlnorm(1,log(q[fleet]*b[fleet]),as.numeric(se[fleet,2]^2))

  }
 return(I)
}


simCompetition <- function(r, beta, N, sigma, K, Nj, year){
  
  Ni <- sum(N[year,-1])
  exp.N <- r*Ni*(1-(K - Ni - beta*Nj)/K)
  
}

num.fun <- function(year, dat.list){
  
  year.seq <- as.numeric(dat.list$year_seq)
  yr <- floor(year.seq[year])
  rows <- seq(year-9,year) 
  
  ans. <- list(yr, st.yr, class(st.yr))
  
  return(ans.)

  
}

# Function to solve for F by fleet based on catch for that year
# function was adapted from ZTA code calculate_F_proj written in ADMB
solve_for_f <- function(proj_catch, fleet, dat.list, year, N){
  
  F_upper <- 2
  F_lower <- 0
  test_f <- (F_upper + F_lower)/2
  est_catch <- c()
  Nages <- dat.list$Nages
  M <- dat.list$M
  S <- dat.list$age_selectivity
  ii <- 1
  
  estz <- M[year,-1] + S[fleet,] * test_f
  est_catch <- sum(S[fleet,] * test_f * N[year,-1] * (1-exp(-estz))/estz)
  catch_diff <- est_catch - proj_catch
  
  while(abs(catch_diff) > 1e-6  & ii < 200){
    
    if(catch_diff > 0){
      F_upper <- test_f
    }else{
      F_lower <- test_f
    }
    test_f <- (F_upper + F_lower)/2
    est_catch <- 0
    estz <- M[year,] + S[fleet,] * test_f
    est_catch <- sum( S[fleet,] * test_f * N[year,-1] * (1-exp(-estz))/estz)
    catch_diff <- est_catch - proj_catch
    ii <- ii + 1
    
  }
  
  Fproj <- test_f
  return(Fproj)
  
}


dat.update <- function(year, dat.list, dat., agecomp.list, I, .datcatch, comp.I, dir., write = T){
  
  year.seq <- as.numeric(dat.list$year_seq)
  yr <- floor(year.seq[year])
  rows <- seq(year-9,year) #rows from the past 4 years
  yrs. <- year.seq[rows]
  yrs. <- yrs.[which((yrs. %% 1) %in% 0)]
  
  
  #Add catch for past 5 years 
  
  new.catch <-
    .datcatch %>%
    as.data.frame() %>%
    slice(rows)  %>%
    na.omit() %>%
    mutate(
      COMP = rep(0.001,1),
      year = yrs.,
      seas = rep(1,5)) %>%
    rename(CM_E = V1,
           CM_W = V2,
           REC = V3,
           SMP_BYC = V4) %>%
    mutate(SMP_BYC = rep(0.001,5),
           CM_E = ifelse(CM_E > 0, CM_E, 0.001),
           CM_W = ifelse(CM_W > 0, CM_W, 0.001),
           REC = ifelse(REC > 0, REC, 0.001))
  
  dat.$catch <- rbind(dat.$catch, new.catch)
  
  dat.$catch <- dat.$catch %>% distinct(year, .keep_all = T)
  
  dat.$N_catch <- nrow(dat.$catch)
  
  #Add Shrimp bycatch as discard
  new.discard <-
    catch.fleet.year %>%
    as.data.frame() %>%
    slice(rows) %>%
    select(4) %>%
    na.omit() %>%
    mutate(
      Yr = yrs.,
      Seas = rep(1,5),
      Flt = rep(-4,5),
      Discard = V4,
      Std_in = rep(0.5,5)
    ) %>%
    select(-1)
  
 dat.$discard_data <- rbind(dat.$discard_data, new.discard)

 dat.$discard_data <- dat.$discard_data %>% distinct(Yr, .keep_all = T)

 old.tail <-which(dat.$discard_data$Seas < 1)[2]

 dat.$discard_data$Seas[old.tail] <- 1

 dat.$N_discard <- nrow(dat.$discard_data)

 dat.$discard_data$Seas[dat.$N_discard] <- -1


 #Add CPUE

 comp.index <- comp.I %>%
   filter(Year > yr - 5 & Year <= yr) %>%
   select(-Year) %>%
   rename("obs" = RS_relative) %>%
   as.data.frame()

  new.index <-  I %>%
    as.data.frame() %>%
    slice(rows)  %>%
    na.omit() %>%
    bind_cols(comp.index) %>%
    rename("7" = V1,
           "8" = V2,
           "3" = V3,
           "4" = V4,
           "11" = V5,
           "12" = V6,
           "5" = obs) %>%
    melt() %>%
    mutate(
      year = rep(yrs.,7),
      seas = rep(1,35),
      variable = as.factor(variable),
      se_log = c(rep(CPUE.se$SE, each = 5), rep(0.01, 5))
           ) %>%
    select(year,
           seas,
           variable,
           value,
           se_log) %>%
    rename(index = variable,
           obs = value)

 
  new.cpue <- splt.recombine(dat.$CPUE, new.index, 'index', N = length(unique(new.index$index)))

  dat.$CPUE <- new.cpue[which(new.cpue$obs > 0),]

  dat.$CPUE <- dat.$CPUE %>%
    group_by(index) %>%
    distinct(year, .keep_all = T) %>%
    as.data.frame()

  dat.$N_cpue <- nrow(dat.$CPUE)

  #Add age comps
  if(!is_empty(agecomp.list)){

    sub.acomps <- compact(agecomp.list[rows])
    new.acomp <- do.call(rbind, sub.acomps)
    agecomp <- splt.recombine(dat.$agecomp, new.acomp, 'FltSvy', N=3)

    dat.$agecomp <- agecomp %>%
      group_by(FltSvy) %>%
      distinct(Yr, .keep_all = T) %>%
      as.data.frame()

    dat.$N_agecomp <- nrow(dat.$agecomp)
  }

  dat.$endyr <- yr

  if(write == T){
  SS_writedat(dat., outfile = paste0(dir.,"/VS.dat"), version = "3.24", overwrite = T)
    
  ct. <- readLines(paste0(dir.,"/VS.ctl"),-1)
  ct.[83] <- paste(yr, "# last year of main recr_devs; forecast devs start in following year", sep = " ")
  writeLines(ct., paste0(dir., "/VS.ctl"))
  }
  
}


### Deprecated for loops

