## Time series analysis for RS abundance trends

library(fable)
library(tsibble)
library(tsibbledata)
library(lubridate)
library(dplyr)
library(mable)
proj.index <- read.csv(here("one_plus", "Projected_index_rs_2032.csv"))
comp.I <- proj.index[,c(1,7)]
future.comp.ind <- proj.index$RS_relative[which(proj.index$Year > 2014)]
future.rs.bio <- proj.index %>% filter(Year > 2014) %>% select(Biomass)

ggplot(data = proj.index, aes(x = Year, y = RS_relative)) + geom_point()

rs_ts <- proj.index %>% 
  as_tsibble(
    index = Year,
    key = RS_relative
  )

has_gaps(rs_ts)

#create the models
mod <- rs_ts %>% model(yesterday = NAIVE(RS_relative ~ lag("1 year")), 
                autolag = NAIVE(RS_relative), 
                ets = ETS(RS_relative))

#forecast
rs_fbl <- mod %>% forecast(h = "1 year")

rs_fbl %>% ggplot() + geom_forecast()

#which model performs better
accuracy(rs_fbl, rs_ts)



#### Scratch Code ####

ggplot() + 
  geom_point(data = future.comp.ind, aes(x = log(Year), y = log(RS_relative)), color = "#F8766D") 

+
  geom_points(data = dat.$catch, aes(x = year, y = CM_W), color = "#00BFC4", size = 1.5) +theme_pub()

ggplot() + geom_point(aes(x = c(future.comp.ind$Year, yrs), y = c(future.comp.ind$RS_relative, pred_index)))


fit <- nls(y ~ SSasymp(t, yf, y0, log_alpha), data = sensor1)
fit

nls(RS_relative ~ I(1 / Year * a) + b * Year, data = future.comp.ind, start = list(a = 1, b = 1))


models <- list(lm(RS_relative ~ Year, data = future.comp.ind), 
               lm(RS_relative ~ I(1 / Year), data = future.comp.ind),
               lm(RS_relative ~ log(Year), data = future.comp.ind),
               nls(RS_relative ~ I(1 / Year * a) + b * Year, data = future.comp.ind, start = list(a = 1, b = 1)), 
               nls(RS_relative ~ (a + b * log(Year)), data = future.comp.ind, start = setNames(coef(lm(RS_relative ~ log(Year), data = future.comp.ind)), c("a", "b"))),
               nls(RS_relative ~ (exp(1) ^ (a + b * Year)), data = future.comp.ind, start = list(a = 0,b = 0)),
               nls(RS_relative ~ I(1 / Year * a) + b, data = future.comp.ind, start = list(a = 1,b = 1))
)
ggplot(data = future.comp.ind, aes(x = Year, y = RS_relative)) + geom_point() +
  stat_smooth(method = lm, formula = y ~ x, data = future.comp.ind, size = 1, se = FALSE, color = "black") + 
  stat_smooth(method = lm, formula = y ~ I(1 / x), size = 1, se = FALSE, color = "blue") + 
  stat_smooth(method = lm, formula = y ~ log(x), size = 1, se = FALSE, color = "yellow") + 
  #stat_smooth(method = nls, formula = y ~ I(1/x*a), method.args = list(start = list(a = -1.352e+04,b = 3.516e-03 )), size = 1, se = FALSE, color = "red", linetype = 2) + 
  stat_function(fun = function(x) I(1/x*-1.352e+04)+3.516e-03*x, color = "#00BFC4", size = 1.5)



stat_smooth(method = nls, formula = y ~ (a + b * log(x)), method.args = list(start = setNames(coef(lm(RS_relative ~ log(Year), data = future.comp.ind)), c("a", "b"))), size = 1, se = FALSE, color = "green", linetype = 2) +
  stat_smooth(method = nls, formula = y ~ I(exp(1)^(a+b*x)),  method.args = list(start = list(a = 0,b = 0)), size = 1, se = FALSE, color = "violet") +
  stat_smooth(method = nls, formula = y ~ I(1/x*a)+b,  method.args = list(start = list(a = 0,b = 0)), size = 1, se = FALSE, color = "orange", linetype = 2) +
  theme_pub()

install.packages("drc")
library(drc)
m1 <- drm(RS_relative ~ Year, data = future.comp.ind, fct = MM.2())
summary(m1)  

ggplot(proj.index, aes(x = Year, y = RS_relative)) + geom_point(colour = nord_cols) 


loess.pns <- predict(loess(RS_relative ~ Year, data=future.comp.ind, span=0.3), c(future.comp.ind$Year, seq(2033, 2040)))

full.mod <- lm(RS_relative ~ Year, data = future.comp.ind)
summary(full.mod)
mod.17 <- lm(RS_relative ~ Year, data = future.comp.ind[-c(1:2),])
summary(mod.17)
mod.28 <- lm(RS_relative ~ Year, data = future.comp.ind[(14:18),])
summary(mod.28)



ggplot(future.comp.ind, aes(x = seq(2015, 2064), y = RS_relative)) + 
  geom_point() + 
  geom_abline(intercept = full.mod$coefficients[1], slope = full.mod$coefficients[2], colour = "#8FBCBB") + 
  geom_abline(intercept = mod.17$coefficients[1], slope = mod.17$coefficients[2], colour = "#5E81AC") + 
  geom_abline(intercept = mod.28$coefficients[1], slope = mod.28$coefficients[2], colour = "#B48EAD") 



##Time series
RS_timeseries <- ts(future.comp.ind$RS_relative, frequency = 1, start = c(2015, 1))
RS_timeseries
plot.ts(RS_timeseries)
