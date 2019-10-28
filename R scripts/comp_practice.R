
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

Nr <- Nrs

ALK_r <- as.data.frame(rs.report.$ALK)
ALK_r <- apply(ALK_r, 2, rev)
Nage <- N


competition_fun <- function(ALK, year, N, Nr, beta.vec, carry_K){

#step one, convert to NLen
VS.nl <- age_to_len(ALK, N, year, T)
RS.nl <- age_to_len(ALK_r, Nrs, year, T)

colnames(RS.nl) <- row.names(ALK_r)
colnames(VS.nl) <- row.names(ALK)
#aggregate RS lengths
RS.nl <- RS.nl %>%
  as.data.frame() %>%
  mutate("14" = sum(.[,1:4]), 
         "20" = sum(.[,5:7]),
         "26" = sum(.[,8:10]),
         "32" = sum(.[,11:13]),
         "38" = sum(.[,14:16]),
         "44" = sum(.[,17:19]),
         "50" = sum(.[,20:22]),
         "56" = sum(.[,23:25]),
         "62" = sum(.[,26:28]),
         "68" = sum(.[,29:31]),
         "74" = sum(.[,32:34]),
         "80" = sum(.[,35:52])) %>% 
  select(-c(1:3, 5,6, 8,9, 11,12, 14,15, 17,18, 20,21, 23,24, 26,27, 29,30, 32,33, 35, 36, 38:52))

#step two, calculate number that died from competition (don't include year 0)
comp.dead <-  VS.nl[1, ] * ((carry_K - VS.nl[1,] - (beta.vec * RS.nl[1,]))/carry_K)
colnames(comp.dead) <- colnames(VS.nl)

#step three, convert back to numbers at age

matrix(NA, nrow = ncol(R_ALK), ncol = nrow(R_ALK))
Natlen <-matrix(NA, nrow = ncol(comp.dead)-1, ncol = ncol(ALK)-1)

ages <- seq(1,14)
df <- matrix(0, nrow = 12, ncol = 14)
colnames(df) <- seq(1,14)
for(i in 2:ncol(comp.dead)){
  na <- sample(c(1:14), size = round(comp.dead[,i]), replace = T, prob = ALK[i,-1])
  tab <- as.data.frame(table(na))
  tab$na <- as.numeric(as.character(tab$na))
  
 for(j in 1:nrow(tab)){
   ind <- which(colnames(df) == tab$na[j])
   df[i, ind] <- tab$Freq[j]
   
 }
  
}

return(colSums(df))
}

comp.discard <- N[year-1,-1] - comp.dead 
N[year-1, -c(1,2)] <- comp.dead


  rmultinom(1, size = 14, prob = ALK[2,])






#### Stuff to work on from Dan and Matt

report. <- MO_SSoutput(dir = here("one_plus", "initial_pop"))
  
comp.F <- report.$catch %>% filter(Fleet == 5) %>% filter(Yr == 2014) %>% select(F) %>% pull()

f14 <- report.$exploitation %>% filter(Yr == 2014) %>% select(COMP) %>% pull()
comp.f <- proj.index$RS_relative*f14

writeClipboard(as.character(seq(2019,2074)))
writeClipboard(as.character(rep(4, 56)))
writeClipboard(as.character(rep(0.07356127, 56)))
writeClipboard(as.character(proj.index$RS_relative[6:61]*f14))


writeClipboard(as.character(x))
writeClipboard(as.character(proj.index$RS_relative[-1]*f14))

report.$timeseries %>% filter(Yr > 2014 & Yr < 2019) %>% select(Yr, contains("F:_5")) %>% pull() 

sum(hist.catch.list[[2]][,5])
sum(hist.catch.list[[4]][,5])
sum(hist.catch.list[[6]][,5])
sum(hist.catch.list[[8]][,5])
sum(hist.catch.list[[10]][,5])

compact(harvest.rate)

head(proj.index$RS_relative*f14)
tail(proj.index$RS_relative*0.0499161)
rep.i <- MO_SSoutput(dir = here("one_plus", "initial_pop"))
rep. <- MO_SSoutput(dir = here("one_plus"))
rep.1 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_1"))
rep.2 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_2"))
rep.3 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_3"))
rep.4 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_4"))
rep.5 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_5"))
rep.6 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_6"))
rep.7 <- MO_SSoutput(dir = here("one_plus", "tests", "scenario_7"))

rep.4$catch %>% filter(Fleet == 5 & Yr > 2014)
rep.4$cpue %>% filter(Fleet == 5 & Yr > 2014) 
rep.4$index_variance_tuning_check$Q[5]
ex.4 <- rep.4$exploitation %>% filter(Yr > 2014 & Yr < 2019) %>% select(Yr, COMP)


rep.6$catch %>% filter(Fleet == 5 & Yr > 2014)
rep.6$exploitation %>% filter(Yr > 2013 & Yr < 2022) %>% select(Yr, COMP)
rep.6$cpue %>% filter(Fleet == 5) %>% filter( Yr > 2014 & Yr < 2020)
rep.6$index_variance_tuning_check[5,8]

rep.7$catch %>% filter(Fleet == 5 & Yr > 2014)
rep.7$cpue %>% filter(Fleet == 5) %>% filter( Yr > 2014 & Yr < 2020)
rep.7$index_variance_tuning_check[5,8]
ex.7 <- rep.7$exploitation %>% filter(Yr > 2014 & Yr < 2019) %>% select(Yr, COMP)


com.tab <- left_join(ex.4, ex.7, by = "Yr") %>% mutate(comp.f = comp.f[c(1:4)]) %>% rename("Scenario_4" = COMP.x, "Scenario_7" = COMP.y, "Fixed_F" = comp.f)
com.tab[,2]/com.tab[,4]
com.tab[,3]/com.tab[,4]

sum(report.$natage_annual_2_with_fishery %>% filter(Year == 2018) %>% select(-c(1:3)) * asel[5,]) * comp.f[5]
2217.922/130974.1



dirs <- c(here("one_plus", "tests", "scenario_7"), here("one_plus", "tests", "scenario_4"))
ble <- SSgetoutput(dirvec = dirs)
ble.sum <- SSsummarize(ble)
SSplotComparisons(ble.sum, plot = F, png = T, plotdir = here("one_plus", "tests"))


F_exploit <- rep(.0715309,4)


exploit_catch <- function(F_exploit, N, year, dat.list){
  
  S <- dat.list$age_selectivity
  wt <- dat.list$wtatage
  Nfleet <- dat.list$N_totalfleet
  Nages <- dat.list$Nages
  cage <- matrix(NA, nrow = Nfleet, ncol = Nages)
  
  for(fleet in 1:Nfleet){
    if(is.na(F_exploit[fleet])){
      next()
    }
    if(fleet == 1 | fleet == 2){
      cage[fleet,] <- unlist(F_exploit[fleet]*(N[year-1,-1]*wt[1,]*S[fleet,]))
    }else{
      cage[fleet,] <- unlist(F_exploit[fleet]*(N[year-1,-1]*S[fleet,]))
      
    }
  }
  
  return(cage)
  
}

exploit_catch(F_exploit, N, year, dat.list)


H_rate <- function(catch, fleet, N, year, dat.list, total.catch = F){
  
  wt <- dat.list$wtatage
  S <- dat.list$age_selectivity
  c_prop <- dat.list$catch_proportions
  
  if(total.catch == T){
    catch <- catch/c_prop[fleet]
  }
  
  hrate <- catch/sum(N[year-1,-1]*wt[1,]*S[fleet,])
  
  return(hrate)
}


















