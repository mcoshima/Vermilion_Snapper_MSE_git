##This code is the framework for the MSE for VS

library(r4ss)
library(dplyr)
library(purrr)
library(reshape2)
library(here)
library(psych) #for geometric mean
set.seed(50)

#system2("ss3")
rep. <- SS_output(dir = here(),forefile = "Forecast-report.sso", covar = F)
#report. <- SS_output(dir = here("Environ_index_runs", "Age_sel_tests", "one_plus"), model = "ss3", forecast = F, covar = F)
source("functions.R")

#Data and parameter setup
Nyrs <- 100 #Double the number of projection years
Year.vec <- seq(2,100, by = 2)
year.seq <- seq(2014, 2014+50, by = .5) #for function
Nfleet <- 6 #ComEIFQ/ComWIFQ/Rec/ShrimpBC/Video/Groundfish
Nages <- 15 #0 to 14+
Nsize <- report.$nlbins
assessYrs <- seq(2019, 2069, by = 5)

#fracfem <- 0.5
#Number-at-age matrix
N <- data.frame(Year = seq(2014, 2064,by = 0.5), 
                Zero = rep(NA,101), 
                One = rep(NA,101), 
                Two = rep(NA,101), 
                Three = rep(NA,101), 
                Four = rep(NA,101), 
                Five = rep(NA,101), 
                Six = rep(NA,101), 
                Seven = rep(NA,101), 
                Eight = rep(NA,101), 
                Nine = rep(NA,101), 
                Ten = rep(NA,101), 
                Eleven = rep(NA,101), 
                Tweleve = rep(NA,101), 
                Thirteen =rep(NA,101), 
                Fourteen = rep(NA,101))
N[c(1),2:16] <- tail(report.$natage[,-c(1:11)], 2)[1,]

#Recruitment
recruit <- report.$recruit
colnames(recruit) <- c("Year", "spawn_bio", "exp_recr", "with_env", "adjusted", "pred_recr", "dev", "biasedaj", "era"); head(recruit)
rhat <- geometric.mean(recruit$pred_recr[c(39:66)]) #recruitment estimates from 1993 to 2014, prior years were just based on equation
rsig <- report.$parameters[which(report.$parameters$Label == "SR_sigmaR"),3]
rec.dev <- rsig*rnorm(1000,0,1) - (rsig^2/2)

##Population dynamics

##Mortality
###Fishing mortality
#f.by.fleet <- report.$timeseries %>% select(contains("F")) %>% slice(n())   
#f.by.fleet <- sapply(f.by.fleet, as.numeric) #values from SEDAR 45
#f.by.fleet <- rep(0,3) #values from SEDAR 45
hist.F <- report.$timeseries %>% filter(Yr > 1994 & Yr < 2015) %>% select("Yr", "F:_1", "F:_2", "F:_3", "F:_4")

F_1 <- hist.F %>% filter(Yr > 2009) %>% select("F:_1") %>% pull() 
F_1_mu <- mean(log(F_1))
F_1_sd <- sd(log(F_1))
F_2 <- hist.F %>% filter(Yr > 2000) %>% select("F:_2") %>% pull() 
F_2_mu <- mean(log(F_2))
F_2_sd <- sd(log(F_2))
F_3 <- hist.F %>% filter(Yr > 2000) %>% select("F:_3") %>% pull() 
F_3_mu <- mean(log(F_3))
F_3_sd <- sd(log(F_3))
F_4 <- hist.F %>% filter(Yr > 2006) %>% select("F:_4") %>% pull() 
F_4_med <- median(log(F_4))
F_4_sd <- sd(log(F_4))

harvest.rate <- c()

#catch.se <- c(report.$catch_error[1:3],.01)
catch.se <- c(exp(.05), exp(.05), .15,.01)

f.list <- list()

###Natural mortality
M <- report.$M_at_age %>%
     slice(n()) %>%
     select(-c(Bio_Pattern, Gender, Year))
M <- apply(M, 2, rep, 101)
M[,15] <- .204
###Total mortality
#z <- report.$Z_at_age %>% filter(Year == 2013) %>% select(-c(1:3))  
#z[15] <- z[14]

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

##Catch dataframes
catch <- matrix(NA, nrow = 4, ncol = 15)
###Maybe try reintroducing this but change the shrimp bycatch value from -2
catch.err <- report.$catch_error[1:4]
catch.by.year <- matrix(data = NA, nrow = Nyrs, ncol = Nages)
catch.by.fleet <- matrix(data = NA, nrow = 4, ncol = Nages)
catch.fleet.year <- matrix(data = NA, nrow = Nyrs, ncol = 4)
.datcatch <- matrix(NA, nrow = 100, ncol = 4)

##Weight-at-length for midpoint lengths
a <- 2.19E-5
b <- 2.916
wtatlen <- a*report.$lbins^b
wtatage <- tail(report.$wtatage[,-c(1:6)], 1)
linf <- report.$Growth_Parameters$Linf
k <- report.$Growth_Parameters$K
t0 <- report.$Growth_Parameters$A_a_L0

#Get age-length key and flip bc it is inverted
ALK <- as.data.frame(report.$ALK)
ALK <- ALK[,c(1:15)]
ALK <- apply(ALK, 2, rev)
trans.prob <- c(.011, 4, 2)

##Numbers at length matrix
cvdist <- rnorm(1000, 0, .2535) #create a sample of error for each length with mean = CV of growth .2535 and sd .1
length.list <- list(vector("list", 16))
lbins <- c(report.$lbins,100)
natlen <- matrix(data = NA, nrow = 12, ncol = 12)
Nlen <- matrix(data = NA, nrow = Nyrs, ncol = 12)

##Age and length comp data 
agecomp.list <- list()
len.comps.list <- list()
survey.len <- matrix(NA, nrow = 2, ncol = 12)

##Biomass matrices and set up for IOA (index matrix and qs)
b.age <- matrix(data = NA, nrow = 3, ncol = Nages)
b.len <- matrix(data = NA, nrow = 2, ncol = 12)
Index.list <- list()
I <- matrix(data = NA, nrow = Nyrs, ncol = Nfleet)
q <- as.numeric(report.$index_variance_tuning_check[c(7,8,3,4,10,11),2])
dat.$CPUE %>% group_by(index) %>% summarise(mean = mean(se_log))
SE <- c(0.369, 0.138, 0.200, 0.2, 0.200, 0.200)
se_log <- matrix(data = NA, nrow = Nyrs, ncol = Nfleet)
CPUE.dev <- report.$cpue %>%
  group_by(Fleet) %>% 
  select(Fleet,Dev) %>% 
  filter(Fleet == 7 | Fleet == 8 | Fleet == 3 | Fleet == 4 | Fleet == 10|Fleet == 11) %>% 
  sample_n(size = 1000, replace = T) %>% 
  group_split() %>%  
  map(as.data.frame) %>% map(select, -Fleet) %>% map(pull)
CPUE.dev <- list(CPUE.dev[[3]], CPUE.dev[[4]],  CPUE.dev[[1]],  CPUE.dev[[2]],  CPUE.dev[[5]],  CPUE.dev[[6]])

#spawn <- report.$biology$Spawn
fecund <- report.$ageselex %>% 
  filter(factor == "Fecund") %>% 
  filter(year == 2014) %>% 
  select(-c(1:7))
ssb_tot <- c()
b.list <- list()
hist.catch.list <- list()


dir. <- here("Environ_index_runs", "Age_sel_tests", "one_plus")

#### Start the loop ###############################################

F.scenario = 2

system.time(for(year in Year.vec){

##SSB caluclated at beginning of each year
ssb_tot[year-1] <- sum(N[year-1,-1]*fecund)

if(F.scenario == 1) {
  f.by.fleet[1:3] <- 0
  f.by.fleet[4] <- rlnorm(1, mean = F_4_med, sd = F_4_sd)
}

if(F.scenario == 2){
  f.by.fleet[1] <- rlnorm(1, F_1_mu, 0.01)
  f.by.fleet[2] <- rlnorm(1, F_2_mu, 0.01)
  f.by.fleet[3] <- rlnorm(1, F_3_mu, 0.01)
  f.by.fleet[4] <- rlnorm(1, F_4_med, 0.01)
 }
# if(F.scenario == 3){
#   
# }

f.list[[year]] <- f.by.fleet

z <- zatage(M,asel,f.by.fleet)
  
#Catches
  ##Catch removed from year.0
catch.by.fleet[,] <- catch.in.number(sel,N, year,z,f.by.fleet,catch.se)

.datcatch[year, c(1:2)] <- apply(catch.in.biomass(sel,N, year,z,f.by.fleet)[c(1:2),], 1, sum)
.datcatch[year, c(3:4)] <- apply(catch.by.fleet[c(3:4),], 1, sum)

catch.by.year[year, ] <- apply(catch.by.fleet, 2, sum)  #catch from 2014.0 N
catch.fleet.year[year, ] <- apply(catch.by.fleet, 1, sum)

hist.catch.list[[year]] <- catch.by.fleet
### simulate age comps for fleets 1 - 3
# if(sum(catch.fleet.year[year,c(1:3)]) > 0.001){
#   agecomp.list[[year]] <- simAgecomp(catch.by.fleet, year)
# }

## Numbers in mid-year
N[year, -1] <- N[year-1,-1]*exp(-z/2)

## Proportion of numbers in each age and length bins

for(i in 1:nrow(ALK)){
  
  natlen[i,] <- N[year-1,i+1]*ALK[,i]
  
}

Nlen[year-1,] <- colSums(natlen)

new.num <- Nlen[year-1,c(1,2,3)]*trans.prob
Nlen[year,] <- c(new.num, Nlen[year-1,-c(1:3)])


#### IOA ####

## Calculate biomass avaiable for surveys

b.age <- simBatage(N,3,asel,year)
b.len <- simBatlen(Nlen,2,lsel,year)
byc.bio <- smpbyc.F

b <- c(apply(b.age, 1, sum), byc.bio, apply(b.len, 1, sum))
b.list[[year]] <- sum(N[year,-1]*wtatage[1,])
Index.list <- simIndex(q,b,CPUE.dev,year) ###Maybe try mean CPUE.dev
I[year,] <- Index.list[[2]]
se_log[year,] <- Index.list[[1]]

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


# N-at-age for the next year     
#Age-0 year.0
N[year+1,2] <- rhat*exp(sample(rec.dev, 1))


#Age 1 to 14
for(age in 3:ncol(N)){
  if(age < ncol(N)){
    N[year+1,age] <- N[year,age-1]*exp(-(z[age-2])/2) #for year.0
  }else{
    N[year+1,age] <- N[year,age-1]*exp(-(z[age-2])/2)+N[year,age]*exp(-z[age-1]/2) #plus age group
  }
}

#### Add data into .dat file and run assessment ####
 # if(year %% 10 == 0){
# 
 #    dat. <- SS_readdat(paste0(dir.,"/VS.dat"))
    
 #     dat.update(year, dat., agecomp.list, len.comps.list, I, .datcatch, dir., write = F)
#      
      #shell(paste("cd/d", dir., "&& ss3", sep = " "))
#      
      #file.copy(paste0(dir., "/Report.sso"), 
       #         paste0(dir., "/assess_results"))
      #file.rename(paste0(dir., "/assess_results/Report.sso"), 
        #          paste0(dir., "/assess_results/Report_", ceiling(year.seq[year]), ".sso"))
#      
#      
#      
#      #SSgetoutput(keyvec = paste("base_F.scenario",F.scenario, sep = "_"), 
#                  # dirvec = here(),
#                  # getcovar = F,
#                  # getcomp = F,
#                  # verbose = F)
#                  # 
# 
# ## Harvest control rules
    # report. <- SS_output(dir = dir., model = "ss3", forecast = F)
#     
#      
# #management level is SPR = 30% to define MSST and MFMT
     #spr.[year] <- report.$last_years_SPR
#   
     
   #} 

#end of OM loop 
} 
)


