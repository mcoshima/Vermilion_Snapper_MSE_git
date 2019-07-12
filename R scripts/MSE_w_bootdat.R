### Run SS as the OM 

library(here)
library(r4ss)
library(dplyr)
library(tidyverse)

setwd(here("Vermilion_2014", "models", "truepop"))
system2("ss3")

#Change number of bootstraps to run 
setwd(here("Vermilion_2014", "models", "base_model_1"))
nboot <- 102#number of bootstrap files to produce
start <- SS_readstarter(file = "starter.ss")
start$N_bootstraps <- nboot
SS_writestarter(start, overwrite = T)

system("ss3")
#split out bootstrap data into new .dat files
SS_splitdat(inname = "data.ss_new", outpattern = "VS", number = TRUE, outpath = paste0("C:/Users/w986430/Desktop/Code/MSE/Vermilion_2014/models"), MLE = F)

boot.dat <- SS_readdat("C:/Users/w986430/Desktop/Code/MSE/Vermilion_2014/models/base_model_1/data.ss_new", section = 3) #section is the section of data to read, 1 = observed, 2 = expected, 3+ = boot
catch.dat <- boot.dat$catch
cpue.dat <- boot.dat$CPUE
agecomp.dat <- boot.dat$agecomp
lencomp.dat <- boot.dat$lencomp
discard.dat <- boot.dat$discard_data


yr <- 2015
F_scenario <- 0

new.cpue <-
  cpue.dat %>% 
  group_by(index) %>% 
  sample_n(4) %>% 
  filter(!index %in% c(1,2, 9)) %>% 
  mutate(year = seq(yr, yr+3))

new.catch <- catch.dat %>%
  sample_n(4) %>%
  mutate(year = seq(yr, yr+3)) %>% 
  mutate(
    F_scenario = F_scenario,
    CM_E = ifelse(F_scenario == 0, 0, CM_E),
    CM_W = ifelse(F_scenario == 0, 0, CM_W),
    REC = ifelse(F_scenario == 0, 0, REC),
    SMP_BYC = ifelse(F_scenario == 0, 0, SMP_BYC)) %>% 
  select(-F_scenario)

new.agecomp <- 
  agecomp.dat %>% 
  group_by(FltSvy) %>% 
  sample_n(4) %>% 
  mutate(Yr = seq(yr, yr+3))

new.lencomp <- 
  lencomp.dat %>% 
  group_by(FltSvy) %>% 
  sample_n(4) %>% 
  mutate(Yr = seq(yr, yr+3))

new.discard <- 
  discard.dat %>% 
  sample_n(4) %>% 
  mutate(Yr = seq(yr, yr+3))

dat. <- SS_readdat("VS.dat")

# Function to split and recombine dataframes by an index, df1 is the original df, df2 is the new one, ind is the column number you want to split and combine by, and N is the number of times the df should be split.
split.recombine <- function(df1, df2, ind, N){
  
  split.dat <- df1 %>% split(.[,ind]) 
  
  split.new <- df2 %>% split(.[,ind])
  
  for(i in 1:N){
    
    x <- which(names(split.dat) == names(split.new)[i])
    
    split.dat[[x]] <- bind_rows(as.data.frame(split.dat[x]),as.data.frame(split.new[i]))
    colnames(split.dat[[x]]) <- colnames(df1)
    
  }
  return(do.call(rbind, split.dat))
  
}

#new catch data
dat.$catch <- bind_rows(dat.$catch, new.catch)
dat.$N_catch <- nrow(dat.$catch)
#new CPUE data
if(F_scenario == 0){
  new.cpue <- new.cpue %>% filter(index == 10 | index == 11)
}
dat.$CPUE <- split.recombine(dat.$CPUE, new.cpue, 3, length(unique(new.cpue$index)))

dat.$N_cpue <- nrow(dat.$CPUE)

#age comps
##Need to remember to not add in when catch = 0
if(F_scenario > 0){
  dat.$agecomp <- split.recombine(dat.$agecomp, new.agecomp, 3, length(unique(dat.$agecomp$FltSvy)))
  dat.$N_agecomp <- nrow(dat.$agecomp)
}

#length comps
dat.$lencomp <- split.recombine(dat.$lencomp, new.lencomp, ind = 3, N = length(unique(dat.$lencomp$FltSvy)))
dat.$N_lencomp <- nrow(dat.$lencomp)

dat.$endyr <- yr+3
SS_writedat(dat., outfile = "VS.dat", overwrite = T)

start <- SS_readstarter("starter.ss")
start$N_bootstraps <- 3
SS_writestarter(start, file = "starter.ss", overwrite = T)

system2("ss3")

rep. <- SS_output(dir = here("Vermilion_2014", "models", "base_model_1"), model = "ss3")

rep.$last_years_SPR
tail(rep.$natage, n = 10)
