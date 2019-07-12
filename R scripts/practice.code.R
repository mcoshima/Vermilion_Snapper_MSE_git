# Practice script for r4ss

library(r4ss)
library(dplyr)
col.grad <- c("#AAD7E9", "#DDEFF6", "#55AFD3", "#277797", "#113442", "#CB5043", "#D06459", "#D5786F", "#E1A09B", "#2B5F5A", '#4E8E88', '#81ADA8',  "#B8C8C6", "#333F50", "#234D61","#40697E", "#668293", "#969A9D")

setwd("C:/Users/w986430/Desktop/Code/MSE")
start. <- SS_readstarter("Starter.SS")
dat. <- SS_readdat("./Vermilion_2014/VS.dat")
ctl. <- SS_readctl("VS.ctl") 


system2("ss3")
mcmc.out(directory = getwd(), run = "ss3")


# read in Report.ss 
report. <- SS_output(dir = "C:/Users/w986430/Desktop/Code/MSE", model = "ss3")
SS_plots(report.)
#Pull out parameter estimates
params <- report.$parameters

# Pull out recruitment estimates

recruit <- report.$recruit
colnames(recruit) <- c("Year", "spawn_bio", "exp_recr", "with_env", "adjusted", "pred_recr", "dev", "biasedaj", "era")
head(recruit)
plot(recruit[c(46:67),1], recruit[c(46:67),7], pch = 16, type = "b", col = col.grad[3])
abline(h=0, col = col.grad[4])

#Spawn per recruit plot
plot(recruit[,2], recruit[,6], pch = 16, col = col.grad[3])

bioscale <- 0.5
recruit$spawn_bio <- bioscale * recruit$spawn_bio
timeseries <- report.$timeseries
timeseries$SpawnBio <- bioscale * timeseries$SpawnBio
x <- recruit$spawn_bio
plot(x, recruit$pred_recr, pch = 16, xlim = c(8.0e12,1.3e13), xlab = "Spawning Biomass", ylab = "Recruits", main = "Spawner per Recruit")
lines(x[order(x)], recruit$exp_recr[order(x)], lwd = 2, 
      col = col.grad[3])



biomass <- report.$sprseries[,c(1,2,3)];head(biomass)
ymax <- max(biomass$Bio_Smry)
ymin <- min(biomass$Bio_Smry)
YAxisLength <- max(pretty(ymax*1.01))
plot(biomass$Year[1:65], biomass$Bio_Smry[1:65], ylim = c(1200000, YAxisLength))


rec.sample <- sample(recruit[,7], size = 1000, replace = T)
hist(rec.sample)
hist(recruit$dev, add = T, col = col.grad[1])  
rec.dis <- rnorm(1000, -0.001713414, 0.3166603) #mean and sd from recruit deviates distribution
hist(rec.dis) 
hist(hist(recruit$dev[c(46:67)], add = T, col = col.grad[1]) ) 

srparams <- params %>%  filter(Label == c("SR_LN(R0)", "SR_BH_steep", "SR_sigmaR")) %>% select(Label, Value) 


plot(report.$sprseries$SPB, report.$sprseries$Recruits, xlim = c(1.8e13,2.5e13), pch = 16, col = col.grad)
curve((srparams[1,2]*x)/(srparams[2,2]+x), from = 1.8e13, to = 2.5e13, add = T)


cpue <- report.$cpue
cpue <- cpue %>% select(Name, Yr, Yr.S, Obs, Vuln_bio, Calc_Q, SE)

plot(cpue$Yr, cpue$Obs, col = col.grad[cpue$Name], pch = 16)

discards <- report.$discard

dat.$init_equil
dat.$CPUEinfo
dat.$catch
plot(dat.$catch$year, dat.$catch$CM_E, col = col.grad[4], pch =16)
lines(dat.$catch$year, dat.$catch$CM_W, col = col.grad[3], pch = 16)
lines(dat.$catch$year, dat.$catch$REC, col = col.grad[1], pch = 16)


#Running ss with bootstrapped data
SS_splitdat(inname = "data.ss_new", outpattern = "BootData")
boot.dat <- SS_readdat("BootData.SS")
system2("ss3")


plot(report.$cpue$Yr[which(report.$cpue$Fleet == 7)], report.$cpue$Exp[which(report.$cpue$Fleet == 7)], xlim = c(2007, 2024), pch = 16, ylim = c(0,1.5))
points(seq(2015,2024), na.omit(I[-1,1]), pch = 16)


