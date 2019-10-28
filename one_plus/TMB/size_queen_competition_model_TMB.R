##TMB attempt for length-structured competition
library(TMB)
library(dplyr)
library(moMSE)
library(stringr)

report. <- MO_SSoutput(dir = here("one_plus"))
report. <- MO_SSoutput(dir = "C:/Users/pc/Desktop/Vermilion_Snapper_MSE_git/one_plus")
rs.report. <- MO_SSoutput(dir = here("Red_Snapper_16"))
rs.report. <- MO_SSoutput(dir = "C:/Users/pc/Desktop/Vermilion_Snapper_MSE_git/Red_Snapper_16/ABC")

Lvs <- report.$natlen %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  select(-c(1:11)) %>% 
  as.matrix()

rs_1 <- rs.report.$natlen %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 1) %>% 
  select(-c(1:11)) %>%
  mutate("14" = rowSums(.[,1:4]), 
         "20" = rowSums(.[,5:7]),
         "26" = rowSums(.[,8:10]),
         "32" = rowSums(.[,11:13]),
         "38" = rowSums(.[,14:16]),
         "44" = rowSums(.[,17:19]),
         "50" = rowSums(.[,20:22]),
         "56" = rowSums(.[,23:25]),
         "62" = rowSums(.[,26:28]),
         "68" = rowSums(.[,29:31]),
         "74" = rowSums(.[,32:34]),
         "80" = rowSums(.[,35:52])) %>% 
  select(-c(1:3, 5,6, 8,9, 11,12, 14,15, 17,18, 20,21, 23,24, 26,27, 29,30, 32,33, 35, 36, 38:52)) %>% 
  as.matrix()

rs_2 <- rs.report.$natlen %>% 
  filter(Yr >= 1950 & Yr <= 2014) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 2) %>% 
  select(-c(1:11)) %>%
  mutate("14" = rowSums(.[,1:4]), 
         "20" = rowSums(.[,5:7]),
         "26" = rowSums(.[,8:10]),
         "32" = rowSums(.[,11:13]),
         "38" = rowSums(.[,14:16]),
         "44" = rowSums(.[,17:19]),
         "50" = rowSums(.[,20:22]),
         "56" = rowSums(.[,23:25]),
         "62" = rowSums(.[,26:28]),
         "68" = rowSums(.[,29:31]),
         "74" = rowSums(.[,32:34]),
         "80" = rowSums(.[,35:52])) %>% 
  select(-c(1:3, 5,6, 8,9, 11,12, 14,15, 17,18, 20,21, 23,24, 26,27, 29,30, 32,33, 35, 36, 38:52)) %>% 
  as.matrix()

Lrs <- rs_1 + rs_2


# Setup data
Data <- list("Nvs" = as.matrix(Lvs),
             "Nrs" = as.matrix(Lrs),
             "Nyear" = nrow(Lvs),
             "Nlbin" = ncol(Lvs),
             "Nrlbin" = ncol(Lrs),
             "K" = 210207.6)
# Setup parameters and starting values
Parameters <- list("Sigma_log" = .1,
                   "Beta" = rep(0, ncol(Lvs)), 
                   "Beta_mu" = 0, 
                   "Sigma_beta" = 0.1)



Version <- "./one_plus/TMB/size_queen_competition_model"
compile( paste0(Version,".cpp"))

dyn.load(dynlib("./one_plus/TMB/size_queen_competition_model"))

model <- MakeADFun(Data, Parameters, DLL="size_queen_competition_model",silent=T)
fit <- optim(model$par, model$fn, model$gr)
sdreport(model)
beta <- c(0.53154340, -0.28797531, -0.25864286, 0.50587301, 0.24466858, 0.45222506, 0.65935886, 0.37527306, 0.40046198, 0.32973220, 0.85006339, -0.97914607)

beta <- c(1.38407711, 1.36980643, 0.09342045, 1.04336198, -0.04741433, -0.27496491, 1.04832902, 0.35111590, 0.49052419, -0.39497939, -1.23485958, -1.00112450)  

beta <- c(0.75594180, -0.72942351, 0.4468206, -0.80727209, 0.23493325, 0.40076310, 0.11045311, 0.01195968, -0.28322851, -0.39795878, -0.17798320, -1.01700583)


#### Get N-at-length for Red Snapper projected (2014 - 2064)
rs_1 <- rs.report.$natage %>% 
  filter(Yr >= 2014 & Yr <= 2064) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 1) %>% 
  select(-c(1:11)) %>%
  as.matrix()

rs_2 <- rs.report.$natage %>% 
  filter(Yr >= 2014 & Yr <= 2064) %>% 
  filter(str_detect(`Beg/Mid`, "B")) %>% 
  filter(Area == 2) %>% 
  select(-c(1:11)) %>%
  as.matrix()

Nrs <- rs_1 + rs_2


R_ALK <- as.data.frame(rs.report.$ALK)
colnames(R_ALK) <- as.character(seq(0,20))

R_ALK <- apply(R_ALK, 2, rev)

ratlen <- matrix(NA, nrow = ncol(R_ALK), ncol = nrow(R_ALK))
Rlen <- matrix(NA, nrow = 1, ncol = nrow(R_ALK))

for(year in 1:nrow(Nrs)){
  for (i in 1:ncol(R_ALK)) {
    ratlen[i,] <- Nrs[year, i] * R_ALK[, i]
  }
  Rlen[1, ] <- colSums(ratlen)
  
}























