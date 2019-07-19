

dir. <- here("Vermilion_Snapper_14")
spr.seq <- seq(.255, .3, by = .005)
rp.df <- as.data.frame(matrix(data = NA, nrow = length(spr.seq), ncol = 4))
colnames(rp.df) <- c("spr_tgt", "fstd_sprtgt", "fstd_msy", "fstd_2074")
fcast. <- c()
for(i in spr.seq){
    
    j <- which(i == spr.seq)
    fcast. <- readLines(paste0(dir.,"/Forecast.ss"),-1)
    fcast.[7] <- paste(i, "# SPR target (e.g. 0.40)", sep = " ")
    writeLines(fcast., paste0(dir., "Forecast.ss"))
    rp.df$spr_tgt[j] <- fcast.[7]
    
    shell(paste("cd/d", dir., "&& ss3", sep = " "))
    
    rep.file <- readLines(paste0(dir.,"/Report.sso"),-1)
    
    rp.df$fstd_sprtgt[j] <- rep.file[1236]
    
    rp.df$fstd_msy[j] <- rep.file[1240]
    
    rp.df$fstd_2074[j] <- rep.file[1102]
    
  }
  


# Need to check that you are at 30% every time
mean_spr <- report.$derived_quants %>% filter(str_detect(LABEL, "Bratio")) %>% slice(tail(row_number(), 10)) %>% summarise(mean_spr = mean(Value))


rep. <- SS_output(dir = here("Vermilion_Snapper_14"), forefile = "Forecast-report.sso", covar = F)

rep.Comp <- SS_output(dir = here("one_plus"), forefile = "Forecast-report.sso", covar = F)

## Calculating RPs
#### SPR = SSBy/SSB0

#Virign SSB
SSB0 <- rep.Comp$timeseries %>% 
  slice(1) %>% 
  select(SpawnBio) %>% 
  pull()

#End year F
F_cur <- rep.Comp$derived_quants %>% 
  filter(str_detect(Label, "F_")) %>% 
  filter(str_detect(Label, paste(year))) %>% 
  select(Value) %>% 
  pull()

#average of F from terminal 10 years of forecast
equ_SPR <- rep.Comp$derived_quants %>% 
  filter(str_detect(Label, "Bratio")) %>% 
  slice(tail(row_number(), 10)) %>% 
  summarise(mean(Value)) %>% 
  pull()

#F at SPR 30% 
Fspr30 <- rep.Comp$derived_quants %>% 
  filter(str_detect(Label, "F_")) %>% 
  slice(tail(row_number(), 10)) %>% 
  summarise(mean(Value)) %>% 
  pull()

F_ratio <- F_cur/Fspr30

SSB_equ <- rep.Comp$derived_quants %>%
  filter(str_detect(Label, "SSB")) %>%
  slice(tail(row_number(), 10)) %>%
  summarise(mean(Value)) %>% 
  pull()

SSB_cur <-  rep.Comp$derived_quants %>%
  filter(str_detect(Label, "SSB_2014")) %>% 
  pull(Value)

MSST <- (1-.25)*SSB_equ

SSB_equ/SSB0
SSB_cur/SSB0
SSB_cur/MSST

#Achieved SPR 30%? If > .3 then yes
if(SSB_equ/SSB0 < 0.3){
  
  #create rebuilding plan

  }
  

  












