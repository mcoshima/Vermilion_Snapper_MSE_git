##Functions for the OM

###writing new data files

library(purrr)
library(reshape2)
library(r4ss)

year.seq <- seq(2014, 2014+50, by = .5)

split.recombine <- function(df1, df2, ind, N){
  
  split.dat <- df1 %>% split(.[,ind]) 
  
  split.new <- df2 %>% split(.[,ind])
  
  for(i in 1:N){
    
    x <- which(names(split.dat) == names(split.new)[i])
    
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


age.to.length <- function(N,age,year,cvdist){
  len.vec <- c()
  for(n in 1:round(N[year,age+2],0)){ 
    len.vec[n] <- linf*(1-exp(-k*(age-t0)))*exp(sample(cvdist, 1))
  }
  return(len.vec)
}


zatage <- function(M,sel,f.by.fleet){
  f <- matrix(NA, nrow = length(f.by.fleet), ncol = Nages)
    for(fleet in 1:4){
  
      f[fleet,] <- as.numeric(asel[fleet,])*as.numeric(f.by.fleet[fleet])
    }
      Z <- as.numeric(M[year,]) + colSums(f)
      
  Z
}

catch.in.biomass <- function(sel,N,year,z,f.by.fleet){
  for(fleet in 1:2){
    for(age in 1:15){
      
      catch[fleet, age] <-
        ((f.by.fleet[fleet]) / z[age]) * (1 - exp(- z[age])) * sel[fleet, age] * N[year-1, age+1] * wtatage[1  ,age]

    }}
  catch
}

catch.in.number <- function(fsel,N,year,z,f.by.fleet,se){
  for(fleet in 1:4){
      for(age in 1:15){
     
        catch[fleet, age] <- ((f.by.fleet[fleet]) / z[age]) * (1 - exp(- z[age])) * sel[fleet, age] * N[year-1, age+1] *exp(rnorm(1,0,se[fleet]))
        
        
      }
    } 
  catch
  }
 
num_to_bio <- function(df, wtatage, Natage = T, age0 = F){
  #converts numbers-at-age to biomass-at-age or vice versa.
  #inputs need to be a dataframe, not a matrix
  #if Natage= T, means that you are giving it the N-at-age df to convert to biomass
  #if Natage = F, means that you are giving it the B-at-age df to convert to numbers
  #age0 = F means you don't want to include age0 in calculations, if T you do 
  
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



simBatage <- function(N, Flt, asel, year){
  #Flt is the max = 3
  #asel is the age selectivity matrix
  
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

simBatlen <- function(Nlen, Flt, lsel, year){
  #Flt is the number of fishery-independent surveys
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



simAgecomp <-  function(catch.by.fleet, year, ageerror){
  agecompinfo.list<- list(
    Yr = rep(floor(year.seq[year]),3),
    Seas = rep(1,3),
    FltSvy = seq(1,3),
    Gender = rep(0,3),
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



simIndex <- function(q,b,se,year){
  
  for(fleet in 1:6){
    
    I[year, fleet] <- rlnorm(1,log(q[fleet]*b[fleet]),as.numeric(CPUE.se[fleet,2]^2))

  }
 return(I[year,])
}


simCompetition <- function(r, beta, N, sigma, K, Nj){
  
  Ni <- sum(N[year,-1])
  exp.N <- r*Ni*(1-(K - Ni - beta*Nj)/K)
  
}




dat.update <- function(year, dat., agecomp.list, I, .datcatch, comp.I, dir., write = T){
  
  
  yr <- floor(year.seq[year])
  rows <- seq(year-9,year) #rows from the past 4 years
  
  #Add catch for past 5 years 
  
  new.catch <- 
    .datcatch %>% 
    as.data.frame() %>%  
    slice(rows)  %>% 
    na.omit() %>% 
    mutate(
      COMP = rep(0.001,5),
      year = seq(yr-4,yr), 
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
      Yr = seq(yr-4,yr),
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
      year = rep(seq(yr-4,yr),7),
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
  
  new.cpue <- split.recombine(dat.$CPUE, new.index, 3, N = length(unique(new.index$index)))
  
  dat.$CPUE <- new.cpue[which(new.cpue$obs > 0),]
  
  dat.$CPUE <- dat.$CPUE %>% 
    group_by(index) %>% 
    distinct(year, .keep_all = T) %>% 
    as.data.frame()
  
  dat.$N_cpue <- nrow(dat.$CPUE)
  
  ##Input RS biomass/K as another effort index
  
  #Add length comps
  
  # sub.lcomps <- compact(len.comps.list[rows])
  # new.lencomp <- do.call(rbind, sub.lcomps)
  # lencomp <- split.recombine(dat.$lencomp, new.lencomp, 3, 2)
  # 
  # dat.$lencomp <- lencomp %>% 
  #   group_by(FltSvy) %>% 
  #   distinct(Yr, .keep_all = T) %>% 
  #   as.data.frame()
  # 
  # dat.$N_lencomp <- nrow(dat.$lencomp)
  
  #Add age comps
  if(!is_empty(agecomp.list)){
  
    sub.acomps <- compact(agecomp.list[rows])
    new.acomp <- do.call(rbind, sub.acomps)
    agecomp <- split.recombine(dat.$agecomp, new.acomp, 3, N=3)
    
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

# for(age in 1:Nages){
#   #if(year %% 2 != 0){
#   #subtract catch from 2014.0 N to get 2014.5 N 
#   N[year,age+1] <- (N[year-1,age+1]-catch.by.year[year,age])*exp(-(M[year-1,age]/2))
#   
#   #}
# }


# length.list[[1]] <- age.to.length(N,0,year,cvdist)
# 
# for(a in 1:Nages-1){
#   length.list[[a+1]] <- age.to.length(N,a,year,cvdist)
# }
# 
# for(i in 1:length(length.list)){
#   natlen[i,] <- as.vector(unlist(table(cut(length.list[[i]], breaks = lbins, right = F, include.lowest = T))))
# }



# SE <- se_log %>%
#   as.data.frame() %>%
#   slice(rows)  %>%
#   na.omit() %>%
#   rename(
#     "7" = V1,
#     "8" = V2,
#     "3" = V3,
#     "4" = V4,
#     "10" = V5,
#     "11" = V6
#   ) %>%
#   melt() %>% 
#   group_by(variable) %>% 
#   mutate(value = ifelse(variable == 4, 0.2, value))
# 