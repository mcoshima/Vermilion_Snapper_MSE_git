### Create a set of initial starting populations from bootstrapped data files

library(here)

setwd(here("Vermilion_2014"))
getwd()

nboot <- 102#number of bootstrap files to produce
start <- SS_readstarter(file = "starter.ss")
start$N_bootstraps <- nboot
SS_writestarter(start, overwrite = T)

dir.create("models")

system2("ss3")

sapply(paste0(here("Vermilion_2014", "models"), "/base_model_", 1:100), dir.create)

SS_splitdat(inname = "data.ss_new", outpattern = "TruePop", number = TRUE, outpath = "C:/Users/w986430/Desktop/Code/MSE/Vermilion_2014/models") #cuts the 2nd section: expected data values


SS_splitdat(inname = "data.ss_new", outpattern = "VS", number = TRUE, outpath = paste0("C:/Users/w986430/Desktop/Code/MSE/Vermilion_2014/models"), MLE = F)


#install.packages("filesstrings")
library(filesstrings)

file.move(paste0(here("Vermilion_2014", "models"), "/VS", 1:100, ".ss"), paste0(here("Vermilion_2014", "models", "base_model_"), 1:100))

#Copying starter, forecast, and .ctl files into all folders
old.loc <- here("Data_tidy", "endyr_2014")
list.of.files <- list.files(old.loc, full.names = T)
new.loc <- paste0(here("Vermilion_2014", "models", "base_model_"), 1:100)

for(folders in new.loc){
  file.copy(from = list.of.files[1:3], to = folders) #excluding the .dat file bc the new one is already in the folders
}

#rename .dat files
newname <- "VS.dat"
for(i in 1:length(new.loc)){
  oldname <- list.files(new.loc[i], pattern = paste0("VS",i,".ss"))
  file.rename(paste0(new.loc[i],"/",oldname), paste0(new.loc[i],"/",newname))
}



#### Make folders for base runs ####

n.scenarios <- 3

dir.create(here("base_runs"))
for(i in 1:n.scenarios){
  dir.create(paste0(here("base_runs", "scenario_"),i))
}

for(j in 2:n.scenarios){
for(i in 1:100){
  dir.create(paste0(here("base_runs", "scenario_"),j, "/trial_", i))
  
}
}

dir. <- here("base_runs", "scenario_1", "trial_1")

system2("dir./ss3")




shell("ss3", shell = dir.)

shell(paste("cd/d", dir., "&& ss3", sep = " "))


shell(paste("cd/d", here("Environ_index_runs", "no_err"), "&& ss3", sep = " "))

dir.create(here("Environ_index_runs", "report_files"))

file.copy(here("Environ_index_runs", "no_err", "Report.sso"), here("Environ_index_runs", "report_files"))
file.rename(here("Environ_index_runs", "report_files", "Report.sso"), here("Environ_index_runs", "report_files", "Report_no_err.sso"))

files.list <- list(here("Environ_index_runs", "VS.dat"), here("Environ_index_runs", "VS.ctl"), here("Environ_index_runs", "starter.ss"), here("Environ_index_runs", "forecast.ss"))

file.copy(files.list, here("Environ_index_runs", "0.2_err"))

shell(paste("cd/d", here("Environ_index_runs", "0.2_err"), "&& ss3", sep = " "))


file.copy(here("Environ_index_runs", "0.2_err", "Report.sso"), here("Environ_index_runs", "report_files"))
file.rename(here("Environ_index_runs", "report_files", "Report.sso"), here("Environ_index_runs", "report_files", "Report_0.2_err.sso"))





