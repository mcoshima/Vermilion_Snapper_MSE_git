

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
  
  
}



# Need to check that you are at 30% every time
