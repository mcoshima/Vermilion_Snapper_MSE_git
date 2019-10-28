## Time series analysis for RS abundance trends

library(dplyr)
library(forecast)
library(ggplot2)
library(here)
proj.index <- read.csv(here("one_plus", "TidyData", "Projected_index_rs_2032.csv"))
comp.I.50 <- proj.index  %>% select(c(Year, RS_relative)) 
comp.I.65 <- proj.index  %>% select(c(Year, RS_relative)) %>% filter(Year > 1964)


#making time series object
rsTS.full <- ts(comp.I.50$RS_relative, start = c(1950), end = c(2032))
rsTS.50 <- ts(comp.I.50$RS_relative, start = c(1950), end = c(2014))
rsTS.65 <- ts(comp.I.65$RS_relative, start = c(1965), end = c(2014))
rsTS.65.32 <- ts(comp.I.65$RS_relative, start = c(1965), end = c(2032))
class(rsTS.50)
frequency(rsTS.50)
start(rsTS.50)
end(rsTS.50)

#fitting model
ses_fit.full <- ses(rsTS.full)
ses_fit.50 <- ses(rsTS.50); 
ses_fit.65 <- ses(rsTS.65)
ses_fit.65.32 <- ses(rsTS.65.32)


#assessing fit
accuracy(ses_fit.full); accuracy(ses_fit.50); accuracy(ses_fit.65); accuracy(ses_fit.65.32)
ses_fit.full$model
ses_fit.50$model
ses_fit.65$model
ses_fit.65.32$model

ets_fit.50 <- ets(rsTS.50)
ets_fit.65 <- ets(rsTS.65)
ets_fit.full <- ets(rsTS.full)
ets_fit.65.32 <- ets(rsTS.65.32)

data.list <- list(rsTS.full,
                  rsTS.50,
                  rsTS.65,
                  rsTS.65.32)
results.list <- list()
tab <- data.frame(Years = rep(c("1950-2032", "1950-2014", "1965-2014", "1965-2032"), each = 4), Model = rep(c("SES", "Holt", "Exponential", "ARIMA"), 4),RMSE = NA, MAE = NA, AIC = NA)

ets <- arima. <- list()

for(i in 1:length(data.list)){
  
  ses <- ses(data.list[[i]])
  hw <- holt(data.list[[i]])
  ets <- ets(data.list[[i]])
  arima. <- auto.arima(data.list[[i]])
  
  s.ac <- accuracy(ses)[c(2,3)]
  hw.ac <- accuracy(hw)[c(2,3)]
  ets.ac <- accuracy(ets)[c(2,3)]
  arima.ac <- accuracy(arima.)[c(2,3)]
  
  df <- rbind(s.ac, hw.ac, ets.ac, arima.ac)
  
  aic.s <- ses$model$aic
  aic.h <- hw$model$aic
  aic.ets <- ets$aic
  aic.ari <- arima.$aic
  aic <- rbind(aic.s, aic.h, aic.ets, aic.ari)
  
  df <- cbind(df, aic)
  colnames(df) <- c("RMSE", "MAE", "AIC")
  results.list[[i]] <- df
}

tab[c(1:4),c(3:5)] <- results.list[[1]]
tab[c(5:8),c(3:5)] <- results.list[[2]]
tab[c(9:12),c(3:5)] <- results.list[[3]]
tab[c(13:16),c(3:5)] <- results.list[[4]]

write.csv(tab, file = here("one_plus", "TidyData", "forecast_fit_table.csv"))

#forecasting and assessing fit
ets.fore <- arima.fore <- list()

for(i in 1:length(data.list)){
  
  ets[[i]] <- ets(data.list[[i]])
  ets.fore[[i]] <- forecast(ets[[i]],60)
  arima.[[i]] <- auto.arima(data.list[[i]])
  arima.fore[[i]] <- forecast(arima.[[i]],60)
}

plot(ets.fore[[1]])
plot(ets.fore[[2]])
plot(ets.fore[[3]])
plot(ets.fore[[4]])


plot(arima.fore[[1]])
plot(arima.fore[[2]])
plot(arima.fore[[3]])
plot(arima.fore[[4]])


ets_fore.50 <- forecast(ets_fit.50,60)
ets_fore.65 <- forecast(ets_fit.65,60)
ets_fore.full <- forecast(ets_fit.full,42)
ets_fore.65.32 <- forecast(ets_fit.65.32,42)
accuracy(ets_fore.50)
accuracy(ets_fore.65)
accuracy(ets_fore.full)

plot(ets_fore.50)
plot(ets_fore.65)
plot(ets_fore.full)
plot(ets_fore.65.32)


ets.fore <- map(ets.fore, as.data.frame)
arima.fore <- map(arima.fore, as.data.frame)

ets.forecast <- data.frame(Full = ets.fore[[1]][,1], start.50 = ets.fore[[2]][,1], start.65 = ets.fore[[3]][,1], start.65.32 = ets.fore[[4]][,1])

arima.forecast <- data.frame(Full = arima.fore[[1]][,1], start.50 = arima.fore[[2]][,1], start.65 = arima.fore[[3]][,1], start.65.32 = arima.fore[[4]][,1])

ggplot(data = proj.index, aes(x = Year, y = RS_relative)) + geom_point(color = nord_cols[1]) + xlim(1950, 2064) +
  geom_point(data = ets.forecast, mapping =aes(x = seq(2033, 2064, by =1), y = Full[c(1:32)]))

plot(x = proj.index$Year, y = proj.index$RS_relative, pch = 16, col = nord_cols[1], xlim = c(1950, 2064))
points(seq(2033, 2064, by =1), y = ets.forecast$Full[c(1:32)], pch = 1, col = nord_cols[2], cex = 1.1)
points(seq(2015, 2064, by =1), y = ets.forecast$start.50, pch = 1, col = nord_cols[3], cex = 1.1)
points(seq(2015, 2064, by =1), y = ets.forecast$start.65, pch = 1, col = nord_cols[4], cex = 1.1)
points(seq(2033, 2064, by =1), y = ets.forecast$start.65.32[c(1:32)], pch = 1, col = nord_cols[5], cex = 1.1)
points(seq(2033, 2064, by =1), y = arima.forecast$Full[c(1:32)], pch = 8, col = nord_cols[2])
points(seq(2015, 2064, by =1), y = arima.forecast$start.50, pch = 8, col = nord_cols[3])
points(seq(2015, 2064, by =1), y = arima.forecast$start.65, pch = 8, col = nord_cols[4])
points(seq(2033, 2064, by =1), y = arima.forecast$start.65.32[c(1:32)], pch = 8, col = nord_cols[5])
legend("top", legend = c(colnames(ets.forecast), "ets", "arima"), pch = c(rep(16, 4), 1, 8), col = c(nord_cols[c(2:5)], nord_cols[1],nord_cols[1]))

new_projections <- data.frame(Year = seq(2033, 2074, by = 1), 
                              All_years_model = arima.forecast$Full[c(1:42)], 
                              Start_50_model = arima.forecast$start.50[-c(1:18)],
                              Start_65_model = ets.forecast$start.65.32[c(1:42)])
head(new_projections)

write.csv(new_projections, file = "./one_plus/TidyData/time_series_RS_index.csv")
