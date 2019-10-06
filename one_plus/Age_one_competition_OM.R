##This code is the framework for the MSE with VS competition index

# library(devtools)
devtools::install_github("mcoshima/moMSE")
library(moMSE)
library(r4ss)
library(dplyr)
library(here)
library(ggplot2)
library(stringr)
library(RPushbullet)
library(psych) #for geometric mean
library(tidyr)
# library(purrr)
# library(reshape2)
# library(gtools)

set.seed(50)

report. <- MO_SSoutput(dir = here("one_plus", "initial_pop"))
# dat. <- SS_readdat(paste0(dir.,"/VS.dat"))
# 
# rep. <- SS_output(dir = here("Vermilion_Snapper_14"), forefile = "Forecast-report.sso", covar = F)
# report.oy <- SS_output(dir = here("Vermilion_Snapper_14"), forefile = "Forecast-report.sso", covar = F)
# mc.out <- SS_output(dir = here("one_plus"),dir.mcmc="mcmc", forecast = F)

#source("./R Scripts/functions.R")

#Data and parameter setup
Nyrs <- 100 #Double the number of projection years
Year.vec <- seq(2,100, by = 2)
year.seq <- seq(2014, 2014+50, by = .5) #for function
Nfleet <- 7 #ComEIFQ/ComWIFQ/Rec/ShrimpBC/Comp/Video/Groundfish
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
#rec.devs <- sample(recruit$dev[c(46:63)], size = 1000, replace = T)
#rsig <- sd(recruit$pred_recr[c(39:66)])
rsig <- report.$parameters[which(report.$parameters$Label == "SR_sigmaR"),3]
rec.dev <- rsig*rnorm(1000,0,1) - (rsig^2/2)

##Population dynamics

##Mortality
###Fishing mortality
f.by.fleet <- c()
hist.F <- report.$timeseries %>% filter(Yr > 1994 & Yr < 2015) %>% select("Yr", "F:_1", "F:_2", "F:_3", "F:_4","F:_5")

F_1 <- hist.F %>% filter(Yr > 2007) %>% select("F:_1") %>% pull()         #2007 bc post IFQ
F_1_mu <- mean(log(F_1))
F_1_sd <- sd(log(F_1))
F_2 <- hist.F %>% filter(Yr > 2007) %>% select("F:_2") %>% pull() 
F_2_mu <- mean(log(F_2))
F_2_sd <- sd(log(F_2))
F_3 <- hist.F %>% filter(Yr > 2011) %>% select("F:_3") %>% pull()         #noticed discrepencies in years prior to 2011
F_3_mu <- mean(log(F_3))
F_3_sd <- sd(log(F_3))
C_4 <- report.$discard %>% filter(Yr > 2011 & Yr < 2015) %>% select(Obs)
C_4_mu <- mean(C_4[,1])
F_4_mu <- mean(log(F_4[,1]))
F_4_sd <- .1
E_4 <- report.$discard %>% filter(Yr > 2011 & Yr < 2015) %>% select(F_rate) %>% pull()
E_4_mu <- mean(log(E_4))
E_4_sd <- sd(log(E_4))

# e.samp <- rlnorm(200, E_4_mu, E_4_sd)
#e <- runif(100, 0.1946, 1.9399)

# F for competition is going to be based on the RS abundance index
  
harvest.rate <- c()

catch.se <- c(report.$catch_error[1:3],.1, report.$catch_error[5])

f.list <- list()

#projected competition index
proj.index.early <- read.csv(here("one_plus", "TidyData", "Projected_index_rs_2032.csv"))
proj.index.late <- read.csv(here("one_plus", "TidyData", "time_series_RS_index.csv"))
proj.index.early <- proj.index.early %>% select(Year, RS_relative) %>% filter(Year > 2013)
proj.index.late <- proj.index.late %>% select(Year, All_years_model) %>% rename(RS_relative = All_years_model)
proj.index <- bind_rows(proj.index.early, proj.index.late)


#Competition variables
# bio.df <- read.csv(here("one_plus", "Comp.index.csv"))
# mod.obj <- nls(Comp.VS.Biomass ~ r*Comp.VS.Biomass*((K -Comp.VS.Biomass - beta*RS.biomass)/K), data = bio.df, start = list(r = 1.5, beta = -.1))
# r <- mod.obj$m$getPars()[1]
# beta <- mod.obj$m$getPars()[2]
# bio.df$pred.bio <- mod.obj$m$predict()

###Natural mortality
M <- report.$M_at_age %>%
  slice(n()) %>%
  select(-c(Bio_Pattern, Gender, Year))
M <- apply(M, 2, rep, 101)
M[,15] <- M[,14]
###Total mortality
#z <- report.$Z_at_age %>% filter(Year == 2013) %>% select(-c(1:3))  
#z[15] <- z[14]

#Selectivities for each fleet by age
#Used selectivity for post commercial fleets post IFQ 
sel <- report.$ageselex %>% 
  filter(factor == "Asel") %>% 
  filter(year == 2014) %>% 
  select(-c(factor,fleet, year, seas, gender, morph, label)) 
asel <- sel[c(8,9,3,4,5),] 
asel[4,2] <- .75
#FI surveys are length based selectivity  
lsel <- report.$sizeselex %>% 
  filter(Fleet > 10) %>% 
  filter(year == 2014) %>% 
  select(-c(Factor, Fleet, year, gender, label)) 

##Catch dataframes
catch <- matrix(NA, nrow = 4, ncol = 15)
###Maybe try reintroducing this but change the shrimp bycatch value from -2
catch.err <- report.$catch_error[1:4]
catch.by.year <- matrix(data = NA, nrow = Nyrs, ncol = Nages)
catch.by.fleet <- matrix(data = NA, nrow = 5, ncol = Nages)
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
ageerror <- report.$age_error_sd[-1,2]

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
I <- matrix(data = NA, nrow = Nyrs, ncol = 6)
q <- as.numeric(report.$index_variance_tuning_check$Q[c(8,9,3,4,11,12)])
dat.$CPUE %>% group_by(index) %>% summarise(mean = mean(se_log))
SE <- c(0.369, 0.138, 0.200, 0.2, 0.200, 0.200)
se_log <- matrix(data = NA, nrow = Nyrs, ncol = Nfleet)
CPUE.se <- report.$cpue %>%
  group_by(Fleet) %>% 
  select(Fleet,SE) %>% 
  filter(Fleet == 8 | Fleet == 9 | Fleet == 3 | Fleet == 4 | Fleet == 11|Fleet == 12) %>% 
  summarise_all(mean)
CPUE.se <- CPUE.se[c(3,4,1,2,5,6),]

fecund <- report.$ageselex %>% 
  filter(Factor == "Fecund") %>% 
  filter(Yr == 2014) %>% 
  select(-c(1:7))
ssb_tot <- c()
b.list <- list()
hist.catch.list <- list()


dat.list <- list(Nages = Nages,
                 age_selectivity = asel,
                 length_selectivity = lsel,
                 M = M,
                 CPUE_se = CPUE.se,
                 catch_se = catch.se,
                 wtatage = wtatage,
                 N_fishfleet = 3, 
                 N_survey = 2,
                 ageerror = ageerror,
                 q = q,
                 year_seq = seq(2014, 2064, by = 0.5), 
                 N_areas = 1,
                 N_totalfleet = 5,
                 catch_proportions = c(0.35, 0.17, 0.48))

dir. <- here("one_plus")

## Reference points
rp.list <- list()
rp.list$f_spr <- report.$derived_quants %>% filter(str_detect(Lable, "Fstd_SPRtgt")) %>% select(Value) %>% pull()
rp.list$f_msy <- report.$derived_quants %>% filter(str_detect(Lable, "Fstd_MSY")) %>% select(Value) %>% pull()
rp.list$f_oy <- .75*rp.list$f_msy
ref.points <- list()

#### Start the loop ###############################################

## Initial F
F.scenario = 2
reduce_catch = F

if(F.scenario == 1) {
  f.by.fleet[1:3] <- 0
  f.by.fleet[4] <- rlnorm(1, mean = F_4_med, sd = F_4_sd)
}

if(F.scenario == 2){
  f.by.fleet[1] <- rlnorm(1, F_1_mu, 0.1)
  f.by.fleet[2] <- rlnorm(1, F_2_mu, 0.1)
  f.by.fleet[3] <- rlnorm(1, F_3_mu, 0.1)
  dis <- rnorm(1, C_4_mu, 100)
  
}

system.time(for(year in Year.vec[1:20]){
  
  if(reduce_catch == F){
    f.by.fleet[1] <- rlnorm(1, F_1_mu, 0.1)
    f.by.fleet[2] <- rlnorm(1, F_2_mu, 0.1)
    f.by.fleet[3] <- rlnorm(1, F_3_mu, 0.1)
    dis <- rnorm(1, C_4_mu, 50)
    f.by.fleet[4] <- solve_for_f(dis, 4, dat.list, year-1, N)
    f.by.fleet[5] <- proj.index[year-1, 2]
  }
  
  
  if(reduce_catch == T){
    f.by.fleet[1] <- f.reduced[1]
    f.by.fleet[2] <- f.reduced[2]
    f.by.fleet[3] <- f.reduced[3]
    dis <- rnorm(1, C_4_mu, 50)
    f.by.fleet[4] <- solve_for_f(dis, 4, dat.list, year-1, N)
    f.by.fleet[5] <- proj.index[year-1, 2]
  }
  
  ##SSB caluclated at beginning of each year
  ssb_tot[year-1] <- sum(N[year-1,-1]*fecund)
  
  f.list[[year]] <- f.by.fleet
  
  z <- zatage(dat.list,year,f.by.fleet)
  
  
  #Catches
  ##Catch removed from year.0
  catch.by.fleet[,] <- catch.in.number(dat.list,N, year,z,f.by.fleet)
  catch.by.fleet[4,] <- as.numeric((asel[4,]/sum(asel[4,]))*dis)
  
  .datcatch[year, c(1:2)] <- apply(catch.in.biomass(dat.list,N, year,z,f.by.fleet)[c(1:2),], 1, sum)
  .datcatch[year, c(3:4)] <- apply(catch.by.fleet[c(3:4),], 1, sum)
  
  catch.by.year[year, ] <- apply(catch.by.fleet, 2, sum)  #catch from 2014.0 N
  catch.fleet.year[year, ] <- apply(catch.by.fleet, 1, sum)[-5]
  
  hist.catch.list[[year]] <- catch.by.fleet
  
  ### simulate age comps for fleets 1 - 3
   if(sum(catch.fleet.year[year,c(1:3)]) > 0.001){
     agecomp.list[[year]] <- simAgecomp(catch.by.fleet, year, dat.list)
   }
  
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
  
  b.age <- simBatage(N,dat.list,year)
  b.len <- simBatlen(Nlen,dat.list,year)
  byc.bio <- rlnorm(1, E_4_mu, E_4_sd)
  
  b <- c(apply(b.age, 1, sum), byc.bio, apply(b.len, 1, sum))
  b.list[[year]] <- sum(N[year,-1]*wtatage[1,])
  I[year,] <- simIndex(dat.list,b) 
  
  
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
   if(year %% 10 == 0){

     dat. <- SS_readdat(paste0(dir.,"/VS.dat"))
     dat.update(year, dat.list, dat., agecomp.list, I, .datcatch, proj.index, dir., write = T)
     shell(paste("cd/d", dir., "&& ss3", sep = " "))
     rep.file <- MO_SSoutput(dir = dir., verbose = F, printstats = F)
     
     SSB0 <- rep.file$timeseries %>% 
       slice(1) %>% 
       select(SpawnBio) %>% 
       pull()
     
     SSB_equ <- rep.file$derived_quants %>%
       filter(str_detect(Label, "SSB_20")) %>%
       slice(tail(row_number(), 10)) %>%
       summarise(mean(Value)) %>% 
       pull()
     
     spr <- round(SSB_equ/SSB0, 2)
     
     if(spr >=.299 & spr <=.31){
       opt = "A"
     }else{
       opt = "B"
     }
    
    if(opt == "B"){
       
       find_spr(dir.)
       
    } 
    
    rep.file <- MO_SSoutput(dir = dir., verbose = F, printstats = F)
    ref.points[[year]] <- getRP(rep.file, dat.list, year)
    
    #check stock status compared to ref points.
    #f_status <- ref.points[[year]]$F_ratio
    #bratio <- ref.points[[year]]$bratio
    MSST_rel <- ref.points[[year]]$status_cur

    pbPost("note",
           title = "Rebuild?",
           body = MSST_rel)
    
    if(MSST_rel < 1){
      rebuild = T
    }else{
      rebuild = F
    }
     
    if(rebuild == T){
      T.target <- rebuild_ttarg(paste0(dir., "/forecast.ss"), dir., dat.list)
      OFL[[year]] <- rebuild_f(paste0(dir., "/forecast.ss"), dir., dat.list, T.target)
      P.star <- p_star()
      ABC <- sum(OFL[[year]]$catch)*P.star
    }
    
    if(rebuild == F){
      OFL[[year]] <- rep.file$derived_quants %>% 
        filter(str_detect(Label, "ForeCatch_")) %>% 
        tail(10) %>% 
        select(Value) %>% 
        colMeans()
      
      ABC <- sum(OFL[[year]]$catch)*.75
      reduce_catch <- TRUE
      
      for(fleet in 1:dat.list$N_fishfleet){
        
        f.reduced[fleet] <- solve_for_f(ABC, fleet, dat.list, year, N)
      }
    }
     
    pbPost("note",
           title = "Notification",
           body = "Assessment finished")
    copy_files(year, dat.list, dir.)
 } 
  
  #end of OM loop 
} 
)


