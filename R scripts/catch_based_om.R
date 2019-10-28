##This code is the framework for the MSE with VS competition index

# library(devtools)
devtools::install_github("mcoshima/moMSE")
install.packages("C:/Users/pc/Desktop/moMSE_0.1.0.tar.gz",
                 repos = NULL,
                 type = "source")
library(moMSE)
library(r4ss)
library(dplyr)
library(here)
library(ggplot2)
library(stringr)
library(RPushbullet)
library(psych) #for geometric mean
library(tidyr)
library(purrr)

set.seed(50)

report. <- MO_SSoutput(dir = here("one_plus", "initial_pop"))

rep. <-
  SS_output(dir = here("one_plus"),
            forefile = "Forecast-report.sso",
            covar = T)


#Data and parameter setup
Nyrs <- 100 #Double the number of projection years
Year.vec <- seq(2, 100, by = 2)
year.seq <- seq(2014, 2014 + 50, by = .5) #for function
Nfleet <- 7 #ComEIFQ/ComWIFQ/Rec/ShrimpBC/Comp/Video/Groundfish
Nages <- 15 #0 to 14+
Nsize <- report.$nlbins
assessYrs <- seq(2019, 2069, by = 5)

#fracfem <- 0.5
#Number-at-age matrix
N <- data.frame(
  Year = seq(2014, 2064, by = 0.5),
  Zero = rep(NA, 101),
  One = rep(NA, 101),
  Two = rep(NA, 101),
  Three = rep(NA, 101),
  Four = rep(NA, 101),
  Five = rep(NA, 101),
  Six = rep(NA, 101),
  Seven = rep(NA, 101),
  Eight = rep(NA, 101),
  Nine = rep(NA, 101),
  Ten = rep(NA, 101),
  Eleven = rep(NA, 101),
  Tweleve = rep(NA, 101),
  Thirteen = rep(NA, 101),
  Fourteen = rep(NA, 101)
)
N[c(1), 2:16] <- tail(report.$natage[, -c(1:11)], 2)[1, ]

#Recruitment
recruit <- report.$recruit
colnames(recruit) <-
  c(
    "Year",
    "spawn_bio",
    "exp_recr",
    "with_env",
    "adjusted",
    "pred_recr",
    "dev",
    "biasedaj",
    "era"
  )
head(recruit)
rhat <-
  geometric.mean(recruit$pred_recr[c(39:66)]) #recruitment estimates from 1993 to 2014, prior years were just based on equation
#rec.devs <- sample(recruit$dev[c(46:63)], size = 1000, replace = T)
#rsig <- sd(recruit$pred_recr[c(39:66)])
rsig <-
  report.$parameters[which(report.$parameters$Label == "SR_sigmaR"), 3]
rec.dev <- rsig * rnorm(1000, 0, 1) - (rsig ^ 2 / 2)
rec.dis <- c()
for (i in 1:100) {
  rec.dis[i] <- rhat * exp(sample(rec.dev, 1))
}
##Population dynamics

##Mortality
###Fishing mortality
f.by.fleet <- c()
hist.F <-
  report.$timeseries %>% filter(Yr > 1994 &
                                  Yr < 2015) %>% select("Yr", "F:_1", "F:_2", "F:_3", "F:_4", "F:_5")

F_1 <-
  hist.F %>% filter(Yr > 2007) %>% select("F:_1") %>% pull()         #2007 bc post IFQ

F_1_mu <- mean(log(F_1))
F_1_sd <- sd(log(F_1))
F_2 <- hist.F %>% filter(Yr > 2007) %>% select("F:_2") %>% pull()
F_2_mu <- mean(log(F_2))
F_2_sd <- sd(log(F_2))
F_3 <-
  hist.F %>% filter(Yr > 2011) %>% select("F:_3") %>% pull()         #noticed discrepencies in years prior to 2011
F_3_mu <- mean(log(F_3))
F_3_sd <- sd(log(F_3))
F_4_mu <- mean(log(F_4[, 1]))
F_4_sd <- .1
E_4 <-
  report.$discard %>% filter(Yr > 2011 &
                               Yr < 2015) %>% select(F_rate) %>% pull()
E_4_mu <- mean(log(E_4))
E_4_sd <- sd(log(E_4))

c_1 <- dat.$catch %>% filter(year > 2006) %>% select(c(1)) %>% range()
c_2 <- dat.$catch %>% filter(year > 2006) %>% select(c(2)) %>% range() 
c_3 <- dat.$catch %>% filter(year > 2010) %>% select(c(3)) %>% range() 
c_4 <- dat.$discard_data %>% tail(n = 3) %>% select(Discard) %>% range()

# F for competition is going to be based on the RS abundance index

harvest.rate <- c()

catch.se <- c(report.$catch_error[1:3], .1, report.$catch_error[5])

f.list <- list()

z.list <- list()
#projected competition index
proj.index.early <-
  read.csv(here("one_plus", "TidyData", "Projected_index_rs_2032.csv"))
proj.index.late <-
  read.csv(here("one_plus", "TidyData", "time_series_RS_index.csv"))
proj.index.early <-
  proj.index.early %>% select(Year, RS_relative) %>% filter(Year > 2013)
proj.index.late <-
  proj.index.late %>% select(Year, All_years_model) %>% rename(RS_relative = All_years_model)
proj.index <- bind_rows(proj.index.early, proj.index.late)

ind <- dat.$CPUE %>% filter(index == 5) %>% select(year,obs) 
ind <- cbind(ind, report.$catch %>% filter(Fleet == 5) %>% select(kill_num, F))
mod <- lm(ind$F ~ ind$obs)
intercept <- as.numeric(mod$coefficients[1])
slope <- as.numeric(mod$coefficients[2])

#Competition variables
 # bio.df <- read.csv(here("one_plus", "TidyData", "Comp.index.csv"))
 # mod.obj <- nls(Comp.VS.Biomass ~ r*Comp.VS.Biomass*((K -Comp.VS.Biomass - beta*RS.biomass)/K), data = bio.df, start = list(r = 1.5, beta = -.1))
 # r <- mod.obj$m$getPars()[1]
 # beta <- mod.obj$m$getPars()[2]
 # bio.df$pred.bio <- mod.obj$m$predict()
 # carry_K <- 210207.6

###Natural mortality
M <- report.$M_at_age %>%
  slice(n()) %>%
  select(-c(Bio_Pattern, Gender, Year))
M <- apply(M, 2, rep, 101)
M[, 15] <- M[, 14]

#Selectivities for each fleet by age
#Used selectivity for post commercial fleets post IFQ
sel <- report.$ageselex %>%
  filter(Factor == "Asel") %>%
  filter(Yr == 2014) %>%
  select(-c(Factor, Fleet, Yr, Seas, Sex, Morph, Label))
asel <- sel[c(8, 9, 3, 4, 5), ]
asel[4, 2] <- .75
#FI surveys are length based selectivity
lsel <- report.$sizeselex %>%
  filter(Fleet > 10) %>%
  filter(Yr == 2014) %>%
  select(-c(Factor, Fleet, Yr, Sex, Label))

##Catch dataframes
catch <- matrix(NA, nrow = 4, ncol = 15)
###Maybe try reintroducing this but change the shrimp bycatch value from -2
catch.err <- report.$catch_error[1:4]
catch.by.year <- matrix(data = NA, nrow = Nyrs, ncol = Nages)
catch.by.fleet <- matrix(data = NA, nrow = 5, ncol = Nages)
catch.fleet.year <- matrix(data = NA, nrow = Nyrs, ncol = 5)
.datcatch <- matrix(NA, nrow = 100, ncol = 4)
comp.discard <- matrix(NA, nrow = 100, ncol = Nages)

##Weight-at-length for midpoint lengths
a <- 2.19E-5
b <- 2.916
wtatlen <- a * report.$lbins ^ b
wtatage <- tail(report.$wtatage[, -c(1:6)], 1)
linf <- report.$Growth_Parameters$Linf
k <- report.$Growth_Parameters$K
t0 <- report.$Growth_Parameters$A_a_L0

#Get age-length key and flip bc it is inverted
ALK <- as.data.frame(report.$ALK)
ALK <- ALK[, c(1:15)]
ALK <- apply(ALK, 2, rev)
trans.prob <- c(.011, 4, 2)
ageerror <- report.$age_error_sd[-1, 2]

##Numbers at length matrix
cvdist <-
  rnorm(1000, 0, .2535) #create a sample of error for each length with mean = CV of growth .2535 and sd .1
length.list <- list(vector("list", 16))
lbins <- c(report.$lbins, 100)
natlen <- matrix(data = NA, nrow = ncol(ALK), ncol = nrow(ALK))
Nlen <- matrix(data = NA, nrow = Nyrs, ncol = nrow(ALK))

##Age and length comp data
agecomp.list <- list()
len.comps.list <- list()
survey.len <- matrix(NA, nrow = 2, ncol = 12)

##Biomass matrices and set up for IOA (index matrix and qs)
b.age <- matrix(data = NA, nrow = 3, ncol = Nages)
b.len <- matrix(data = NA, nrow = 2, ncol = 12)
Index.list <- list()
I <- matrix(data = NA, nrow = Nyrs, ncol = 6)
q_order <- c(8,9,3,4,11,12)
q <- rep.file$index_variance_tuning_check %>% 
  slice(match(q_order, Fleet))%>% 
  select(Q) %>% 
  pull() %>% 
  as.numeric()
dat.$CPUE %>% group_by(index) %>% summarise(mean = mean(se_log))
SE <- c(0.369, 0.138, 0.200, 0.2, 0.200, 0.200)
se_log <- matrix(data = NA, nrow = Nyrs, ncol = Nfleet)
CPUE.se <- report.$cpue %>%
  group_by(Fleet) %>%
  select(Fleet, SE) %>%
  filter(Fleet == 8 |
           Fleet == 9 |
           Fleet == 3 | Fleet == 4 | Fleet == 11 | Fleet == 12) %>%
  summarise_all(mean)
CPUE.se <- CPUE.se[c(3, 4, 1, 2, 5, 6), ]

fecund <- report.$ageselex %>%
  filter(Factor == "Fecund") %>%
  filter(Yr == 2014) %>%
  select(-c(1:7))
ssb_tot <- c()
b.list <- list()
hist.catch.list <- list()

OFL <- list()
f.reduced <- c()
dat.list <- list(
  Nages = Nages,
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
  catch_proportions = c(0.35, 0.17, 0.48)
)

dir. <- here("one_plus")

## Reference points
ref.points <- list()
rebuild.mat <-
  matrix(data = NA, nrow = 10, ncol = 10) #need to add more cols eventually for full number of iterations


#### Start the loop ###############################################

iteration <- 1

recommend_catch = F
x <- 1

system.time(for (year in Year.vec[1:5]) {
  
  if (recommend_catch == F) {
    .datcatch[year,1] <- runif(1, c_1[1], c_1[2])
    .datcatch[year,2] <- runif(1, c_2[1], c_2[2])
    .datcatch[year,3] <- runif(1, c_3[1], c_3[2])
    .datcatch[year,4] <- runif(1, c_4[1], c_4[2])
    
    f.by.fleet[1] <-
      H_rate(.datcatch[year,1], 1, N, year, dat.list, F)
    f.by.fleet[2] <-
      H_rate(.datcatch[year,2], 2, N, year, dat.list, F)
    f.by.fleet[3] <-
      H_rate(.datcatch[year,3], 3, N, year, dat.list, F)
    f.by.fleet[4] <-
      H_rate(.datcatch[year,4], 4, N, year, dat.list, F)
    f.by.fleet[5] <- comp.f[year/2]
    
  }
  
  if (recommend_catch == T) {
    .datcatch[year,1] <- rnorm(1, c_1[x], 100)
    .datcatch[year,2] <- rnorm(1, c_2[x], 100)
    .datcatch[year,3] <- rnorm(1, c_3[x], 100)
    .datcatch[year,4] <- runif(1, c_4[1], c_4[2])
    
    f.by.fleet[1] <-
      H_rate(.datcatch[year,1], 1, N, year, dat.list, F)
    f.by.fleet[2] <-
      H_rate(.datcatch[year,2], 2, N, year, dat.list, F)
    f.by.fleet[3] <-
      H_rate(.datcatch[year,3], 3, N, year, dat.list, F)
    f.by.fleet[4] <-
      H_rate(.datcatch[year,4], 4, N, year, dat.list, F)
    f.by.fleet[5] <- comp.f[year/2]
  }
  
  ##SSB caluclated at beginning of each year
  ssb_tot[year - 1] <- sum(N[year - 1, -1] * fecund)
  
  f.list[[year]] <- f.by.fleet
  
  # z <- zatage(dat.list, year, f.by.fleet)
  # z.list[[year]] <- z
  
  #Catches
  catch.by.fleet[,] <- exploit_catch(f.by.fleet, N, year, dat.list)
  
  catch.by.year[year,] <- colSums(catch.by.fleet)  #catch from 2014.0 N
  catch.fleet.year[year,] <- rowSums(catch.by.fleet)
  
  hist.catch.list[[year]] <- catch.by.fleet
  #harvest.rate[[year]] <- sum(N[year-1,-1]*asel[5,])*comp.f[year/2]
  
  ### simulate age comps for fleets 1 - 3
  if (sum(catch.fleet.year[year, c(1:3)]) > 0.001) {
    agecomp.list[[year]] <- simAgecomp(catch.by.fleet, year, dat.list)
  }
  
  ## N-at-age for the next year
  #Age-0 year.0
  N[year + 1, 2] <- sample(rec.dis, 1, replace = F)
  
  #Age 1 to 14
  for (age in 3:ncol(N)) {
    if (age < ncol(N)) {
      N[year + 1, age] <- N[year-1,age-1]*exp(-M[year-1,age-2])-catch.by.year[year,age-2] 
    } else{
      N[year + 1, age] <- N[year-1,age-1]*exp(-M[year-1,age-2])-catch.by.year[year,age-2] + N[year-1,age]*exp(-M[year-1,age-1])-catch.by.year[year,age-1] #plus age group
    }
  }
  
  ## Numbers in mid-year
  for(age in 3:ncol(N)){
    N[year, age-1] <- N[year-1,age-1] - (N[year-1,age-1]-N[year+1,age])/2
    if(age == 16){
      N[year, age-1] <- N[year-1,age-1] - (N[year-1,age-1]*exp(-M[year-1,age-2])-catch.by.year[year,age-2])/2
      N[year, age] <- N[year-1,age] - (N[year-1,age]*exp(-M[year-1,age-1])-catch.by.year[year,age-1])/2
    }
  }

  ## Proportion of numbers in each age and length bins
  
  for (i in 1:ncol(ALK)) {
    natlen[i, ] <- N[year - 1, i + 1] * ALK[, i]
  }
  
  Nlen[year - 1, ] <- colSums(natlen)
  
  new.num <- Nlen[year - 1, c(1, 2, 3)] * trans.prob
  Nlen[year, ] <- c(new.num, Nlen[year - 1, -c(1:3)])

  
  #### IOA ####
  
  ## Calculate biomass avaiable for surveys
  
  b.age <- simBatage(N, dat.list, year)
  b.len <- simBatlen(Nlen, dat.list, year)
  byc.bio <- rlnorm(1, E_4_mu, E_4_sd)
  
  b <- c(apply(b.age, 1, sum), byc.bio, apply(b.len, 1, sum))
  b.list[[year]] <- sum(N[year, -1] * wtatage[1, ])
  I[year, ] <- simIndex(dat.list, b)
  
  x <- x+1
})
  #### Add data into .dat file and run assessment ####
  if (year %% 10 == 0) {
    dat. <- SS_readdat(paste0(dir., "/VS.dat"))
    dat.update(year,
               dat.list,
               dat.,
               agecomp.list,
               I,
               catch.fleet.year,
               proj.index,
               dir.,
               write = T)
    shell(paste("cd/d", dir., "&& ss3", sep = " "))
     rep.file <-
      MO_SSoutput(dir = dir.,
                  verbose = F,
                  printstats = F)
    
    spr <- rep.file$derived_quants %>%
      filter(str_detect(Label, "Bratio")) %>%
      slice(tail(row_number(), 10)) %>%
      summarise(mean(Value)) %>%
      pull() %>% round(2)
    
    if (spr >= .299 & spr <= .31) {
      opt = "A"
    } else{
      opt = "B"
    }
    
    if (opt == "B") {
      find_spr(dir., notifications = F)
      
    }
    
    rep.file <- MO_SSoutput(dir = dir.,
                            verbose = F,
                            printstats = F)
    ref.points[[year]] <- getRP(rep.file, dat.list, year)
    
    q <- rep.file$index_variance_tuning_check %>% 
      slice(match(q_order, Fleet))%>% 
      select(Q) %>% 
      pull() %>% 
      as.numeric()
      
    #check stock status compared to ref points.
    MSST_rel <- ref.points[[year]]$status_cur
    
    # pbPost("note",
    #        title = "Rebuild?",
    #        body = MSST_rel)
    
    if (MSST_rel < 1) {
      rebuild = T
    } else{
      rebuild = F
    }
    
    if (rebuild == T) {
      T.target <-
        rebuild_ttarg(paste0(dir., "/forecast.ss"), dir., dat.list)
      OFL[[year]] <-
        rebuild_f(paste0(dir., "/forecast.ss"), dir., dat.list, T.target)
      P.star <- p_star()
      ABC <- OFL[[year]]$catch * P.star
      rebuild.mat[year / 10, iteration] <- 1
  
      c_1[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[1] 
      c_2[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[2]
      c_3[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[3]
     
      recommend_catch <- T
    }
    
    if (rebuild == F) {
      rebuild.mat[year / 10, iteration] <- 0
      OFL[[year]] <- rep.file$derived_quants %>%
        filter(str_detect(Label, "ForeCatch_")) %>%
        tail(10) %>%
        select(Value) %>%
        colMeans()
      
      ABC <- OFL[[year]] * .75
      c_1[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[1]
      c_2[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[2]
      c_3[x:(x+t_targ-1)] <- ABC * dat.list$catch_proportions[3]
       
      recommend_catch <- T

    }
    
    # pbPost("note",
    #        title = "Notification",
    #        body = "Assessment finished")
    copy_files(year, dat.list, dir.)
    
    
  }
  
write.csv(rebuild.mat, file = "rebuild.matrix.csv")
})
