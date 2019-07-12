##This code is the framework for the MSE for VS to reproduce the report.ss estimates from years 2010 to 2014. This is used to show that my model can accurately simulate the dynamics as predicted by ss3.24.

library(r4ss)
library(dplyr)
library(purrr)
library(reshape2)
library(here)
library(psych) #for geometric mean
set.seed(50)
setwd(here())

report. <- SS_output(dir = here(), model = "ss3")
source("functions.R")
#Data and parameter setup
Nyrs <- 100 #Double the number of projection years
Year.vec <- seq(2,100, by = 2)
year.seq <- seq(2014, 2014+50, by = .5) #for function
Nfleet <- 6 #ComEIFQ/ComWIFQ/Rec/ShrimpBC/Video/Groundfish
Nages <- 15 #0 to 14+
Nsize <- report.$nlbins
assessYrs <- seq(2019, 2069, by = 5)
trans.prob <- c(.011, 4, 2)

#Number-at-age matrix
N <- data.frame(Year = seq(2010, 2015,by = 0.5), 
                Zero = rep(NA,11), 
                One = rep(NA,11), 
                Two = rep(NA,11), 
                Three = rep(NA,11), 
                Four = rep(NA,11), 
                Five = rep(NA,11), 
                Six = rep(NA,11), 
                Seven = rep(NA,11), 
                Eight = rep(NA,11), 
                Nine = rep(NA,11), 
                Ten = rep(NA,11), 
                Eleven = rep(NA,11), 
                Tweleve = rep(NA,11), 
                Thirteen =rep(NA,11), 
                Fourteen = rep(NA,11))
N[c(1),2:16] <- report.$natage[125,-c(1:11)]


#Recruitment
recruit <- report.$recruit
colnames(recruit) <- c("Year", "spawn_bio", "exp_recr", "with_env", "adjusted", "pred_recr", "dev", "biasedaj", "era"); head(recruit)
rhat <- geometric.mean(recruit$pred_recr[c(39:66)]) #recruitment estimates from 1993 to 2014, prior years were just based on equation
rec.devs <- sample(recruit$dev[c(46:63)], size = 1000, replace = T)

###Natural mortality
M <- report.$M_at_age %>%
  slice(n()) %>%
  select(-c(Bio_Pattern, Gender, Year))
M <- apply(M, 2, rep, 101)
M[,15] <- .204

#Selectivities for each fleet by age
#Used selectivity for post commercial fleets post IFQ 
sel <- report.$ageselex %>% 
  filter(factor == "Asel") %>% 
  filter(year == 2014) %>% 
  select(-c(factor,fleet, year, seas, gender, morph, label)) 
asel <- sel[c(7,8,3,4),] 
#FI surveys are length based selectivity  
lsel <- report.$sizeselex %>% 
  filter(Fleet > 9) %>% 
  filter(year == 2014) %>% 
  select(-c(Factor, Fleet, year, gender, label)) 

catch <- matrix(NA, nrow = 4, ncol = 15)
catch.err <- report.$catch_error[1:4]
catch.by.year <- matrix(data = NA, nrow = Nyrs, ncol = Nages)
catch.by.fleet <- matrix(data = NA, nrow = 4, ncol = Nages)
catch.fleet.year <- matrix(data = NA, nrow = Nyrs, ncol = 4)
.datcatch <- matrix(NA, nrow = 100, ncol = 4)

##Weight-at-length for midpoint lengths
a <- 2.19E-5
b <- 2.916
wtatlen <- a*report.$lbins^b
wtatage <- tail(report.$wtatage[,-c(1:5)], 4)
linf <- report.$Growth_Parameters$Linf
k <- report.$Growth_Parameters$K
t0 <- report.$Growth_Parameters$A_a_L0

#Get age-length key and flip bc it is inverted
ALK <- as.data.frame(report.$ALK)
ALK <- ALK[,c(1:15)]
ALK <- apply(ALK, 2, rev)

##Numbers at length matrix
cvdist <- rnorm(1000, 0, .2535) #create a sample of error for each length with mean = CV of growth .2535 and sd .1
length.list <- list(vector("list", 16))
lbins <- c(report.$lbins,100)
natlen <- matrix(data = NA, nrow = 12, ncol = 12)
Nlen <- matrix(data = NA, nrow = 8, ncol = 12)

##Age and length comp data 
agecomp.list <- list()
len.comps.list <- list()
survey.len <- matrix(NA, nrow = 2, ncol = 12)

##Biomass matrices and set up for IOA (index matrix and qs)
b.age <- matrix(data = NA, nrow = 3, ncol = Nages)
b.len <- matrix(data = NA, nrow = 2, ncol = 12)
I <- matrix(data = NA, nrow = Nyrs, ncol = Nfleet)
q <- as.numeric(report.$index_variance_tuning_check[c(7,8,3,4,10,11),2])
CPUE.dev <- report.$cpue %>%
  group_by(Fleet) %>% 
  select(Fleet,Dev) %>% 
  filter(Fleet == 7 | Fleet == 8 | Fleet == 3 | Fleet == 4 | Fleet == 10|Fleet == 11) %>% 
  sample_n(size = 1000, replace = T) %>% 
  group_split() %>% 
  map(as.data.frame) %>% map(select, -Fleet) %>% map(pull)
CPUE.dev <- list(CPUE.dev[[3]], CPUE.dev[[4]],  CPUE.dev[[1]],  CPUE.dev[[2]],  CPUE.dev[[5]],  CPUE.dev[[6]])


mat_age <- report.$endgrowth$Age_Mat
mat_len <- report.$biology$Mat_len

fecund <- report.$ageselex %>% 
  filter(factor == "Fecund") %>% 
  filter(year == 2014) %>% 
  select(-c(1:7))
ssb_tot <- c()
b.list <- list()
hist.catch.list <- list()

## Start the loop ###############################################

  #####  
  ##Take out later 
for(i in 1:4){
  y <- i #from 1 to 4
  year <- i*2 #from 2 to 8
  f.by.fleet <- report.$timeseries %>% select(contains("F")) %>% tail(n = 5)
  f.by.fleet <-  sapply(f.by.fleet[y,], as.numeric)
  z <- report.$Z_at_age %>% filter(Year > 2009) %>% select(-c(1:3))  
  z[15] <- z[14]
  #### 
  
  ##SSB caluclated at beginning of each year
  ssb_tot[year-1] <- sum(N[year-1,-1]*fecund)

  
  #Catches
  ##Catch removed from year.0, so year.5 shows N-catch
  catch.by.fleet[,] <- catch.in.number(sel,N, year,z[year/2,],f.by.fleet)
  
  #create catch dataframe to put into .dat file bc comm fisheries catch reported in biomass
  .datcatch[year, c(1:2)] <- apply(catch.in.biomass(sel,N, year,z[year/2,],f.by.fleet)[c(1:2),], 1, sum)
  .datcatch[year, c(3:4)] <- apply(catch.by.fleet[c(3:4),], 1, sum)

  catch.by.year[year, ] <- apply(catch.by.fleet, 2, sum)  #catch from 2014.0 N
  catch.fleet.year[year, ] <- apply(catch.by.fleet, 1, sum)
  
  hist.catch.list[[year]] <- catch.by.fleet
  
  ### simulate age comps for fleets 1 - 3
  if(sum(catch.fleet.year[year,]) > 0.001){
    agecomp.list[[year]] <- simAgecomp(catch.by.fleet, year)
  }
  
  N[year, -1] <- N[year-1,-1]*exp(-z[year/2,]/2)
  
  ## Proportion of numbers in each age and length bins
  
  for(i in 1:nrow(ALK)){
    
    natlen[i,] <- N[year-1,i+1]*ALK[,i]
    
  }
  
  Nlen[year-1,] <- colSums(natlen)
  
  new.num <- Nlen[year-1,c(1,2,3)]*trans.prob
  Nlen[year,] <- c(new.num, Nlen[year-1,-c(1:3)])
  
  
  #IOA
  
  ##Calculate biomass avaiable for surveys
  
  b.age <- simBatage(N,3,asel,year)
  b.len <- simBatlen(Nlen,2,lsel,year)
  byc.bio <- smpbyc.F
  
  b <- c(apply(b.age, 1, sum), as.numeric(f.by.fleet[4]), apply(b.len, 1, sum))

  b.list[[year]] <- sum(N[year,-1]*wtatage[1,-1])
  I[year,] <- simIndex(q,b,CPUE.dev,year)
  
  
  #Length-comps for FI surveys
  compinfo.list<- list(
    Yr = rep(floor(year.seq[year]),2),
    Seas = rep(1,2),
    FltSvy = seq(11,10),
    Gender = rep(0,2),
    Part = rep(2,2),
    Nsamp = runif(2, 1, 100))
  
  
  
  flt11comp <- c(rand_vect_cont(6, 1),rep(0,6))
  flt10comp <- c(rep(0,2), rand_vect_cont(9, 1), 0)
  
  
  comps <- rbind(flt11comp, flt10comp)
  colnames(comps) <- paste0("l",c(1,seq(5,55,by=5)))
  compinfo.list <- as.data.frame(do.call(cbind, compinfo.list))
  len.comps.list[[year]] <- cbind(compinfo.list, comps)
  
  
  
  #N-at-age     
  #Age-0 year.0
  N[year+1,2] <- rhat*exp(sample(rec.devs, 1))
  
  #Age 1 to 14
  for(age in 3:ncol(N)){
    if(age < ncol(N)){
      N[year+1,age] <- N[year,age-1]*exp(-(z[year/2,age-2])/2) #for year.0
    }else{
      N[year+1,age] <- N[year,age]*exp(-(z[year/2,age-2])/2)+N[year,age]*exp(-z[year/2,age-1]/2) #plus age group
    }
  }
}  

### Run after you go through year = 8

write.csv(N[c(1:9),], "N.csv", row.names = F)
I <- head(na.omit(I))
Idf <- data.frame(fleet = rep(c(3,4,7,8,10,11),each = 4), ind. = c(I[,3], I[,4], I[,1], I[,2], I[,5], I[,6]))
write.csv(Idf, "I.csv", row.names = F)
write.csv(catch.by.fleet, "catch.by.fleet.csv", row.names = F)
write.csv(catch.by.year, "catch.by.year.csv", row.names = F)
save(hist.catch.list, file = "hist.catch.Rdat")
write.csv(Nlen, "natlen.csv")
save(b.list, file = "b.list.Rdat")
