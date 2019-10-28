##TMB age-structured competition
library(TMB)
library(dplyr)
library(moMSE)
library(stringr)

report. <- MO_SSoutput(dir = here("one_plus"))
rs.report. <- MO_SSoutput(dir = here("Red_Snapper_16"))
rs.report. <- MO_SSoutput(dir = "C:/Users/pc/Desktop/Vermilion_Snapper_MSE_git/Red_Snapper_16/ABC")

Nvs <- report.$natage %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  select(-c(1:11)) %>% 
  as.matrix()

rs_1 <- rs.report.$natage %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 1) %>% 
  select(-c(1:11)) %>%
  mutate("14" = rowSums(.[,16:21])) %>% 
  select(-c(16:21)) %>% 
  as.matrix()

rs_2 <- rs.report.$natage %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 2) %>% 
  select(-c(1:11)) %>%
  mutate("14" = rowSums(.[,16:21])) %>% 
  select(-c(16:21)) %>% 
  as.matrix()

N_rs <- rs_1 + rs_2

Nvs_scaled <- as.data.frame(apply(Nvs, 1, scale))
Nvs_scaled <- as.data.frame(scale(Nvs[1,]))
N_rs_scaled <- as.data.frame(apply(N_rs, 1, scale))
Nvs_scaled <- matrix(NA, nrow = nrow(Nvs), ncol = ncol(Nvs))
for(i in 1:nrow(Nvs)){
  
  scaled <- as.data.frame(scale(Nvs[i,]))
  Nvs_scaled <- spread(scaled, key = age, value = V1)
  
}



# Setup data
Data <- list("Nvs" = Nvs,
             "Nrs" = as.matrix(N_rs),
             "Nyear" = nrow(Nvs),
             "Nage" = ncol(Nvs),
             "K" = 210207.6)
Data <- list("Nvs" = as.matrix(Nvs_scaled),
             "Nrs" = as.matrix(N_rs_scaled),
             "Nyear" = ncol(Nvs_scaled),
             "Nage" = nrow(Nvs_scaled),
             "K" = 210207.6)
# Setup parameters and starting values
Parameters <- list("Sigma_log" = 0.1,
                   "Beta" = rep(0, 15), 
                   "Beta_mu" = 0, 
                   "Sigma_beta" = 0.01)

Version <- "./one_plus/TMB/age_structure_competition_model"
compile( paste0(Version,".cpp"))

dyn.load(dynlib("./one_plus/TMB/age_structure_competition_model"))

model <- MakeADFun(Data, Parameters, DLL="age_structure_competition_model",silent=T)
fit <- optim(model$par, model$fn, model$gr)

est. <- sdreport(model)
beta.age <- est.$value[-c(1:2)]


comp.dead <-  Nvs[1, ] * ((carry_K - Nvs[1,] - (beta.age * N_rs[1,]))/carry_K)



























