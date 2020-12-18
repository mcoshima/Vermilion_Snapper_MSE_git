library(mlogit)
library(here)
library(tidyverse)

`%notin%` <- Negate(`%in%`)


####### DATA PREP #####
vs.cpue <- read.csv(here("one_plus", "TidyData", "VS_rec_cpue_05_17.csv"))
vs.mrfss <- vs.cpue %>% 
  filter(str_detect(NAME, "MRFSS")) %>% 
  mutate(year = year + 1) %>% 
  select(year, OBS, PRED)

catch.data <- read.csv(here("MRIP_data", 'catch_2018_2006_all.csv'))
head(catch.data)

targetsps <- c("VERMILION SNAPPER", "RED SNAPPER", "GRAY TRIGGERFISH")

catch.sub <- catch.data %>% 
  select(ID_CODE, fl_reg) %>% 
  mutate(ID_CODE = as.character(ID_CODE)) %>% 
  distinct(ID_CODE, .keep_all = T)
write.csv(catch.sub, file = here("MRIP_data", "catch.sub.csv"))
head(catch.sub)
summary(catch.sub)

trip <- read.csv(here("MRIP_data", "trip_2018_2006_all.csv"))
head(trip)

trip.sub <- trip %>% 
  mutate(ID_CODE =as.character(ID_CODE)) %>% 
  filter(prim1_common %in% targetsps | prim2_common %in% targetsps) %>% 
  mutate(choice = ifelse(prim2_common %in% targetsps & 
                           prim1_common %notin% targetsps, 
                         paste(prim2_common), 
                         paste(prim1_common))) %>% 
  select(ID_CODE, choice, prim1_common, prim2_common, YEAR, ST, MODE_FX, AREA_X, WAVE, CATCH)

head(trip.sub)
write.csv(trip.sub, file = here("MRIP_data","trip_06_18_sub.csv"))

trip.catch <- catch.sub %>%
  inner_join(trip.sub, by = "ID_CODE") %>%
  mutate(prim1_common = as.character(prim1_common)) %>%
  mutate(
    choice = recode(
      choice,
      `VERMILION SNAPPER` = "vs",
      `RED SNAPPER` = "rs",
      `GRAY TRIGGERFISH` = "gt"
    )
  ) %>%
  rename(
    year = YEAR,
    st = ST,
    fsh_mode = MODE_FX,
    area = AREA_X,
    wave = WAVE
  ) %>%
  filter_at(vars(prim1_common, year, fsh_mode, st), all_vars(!is.na(.))) %>%
  filter(str_detect(choice, "vs|rs|gt")) %>%
  mutate_at(c("year", "st", "fsh_mode", "area", "wave"), as.numeric) %>% 
  filter(fsh_mode == 5 | fsh_mode == 7) %>%
  filter(st == 1 | st == 28 | st == 12) %>% 
  filter(fl_reg != 4 | fl_reg != 5) 
write.csv(trip.catch, file = here("one_plus", "TidyData","trip.catch.csv"))
head(trip.catch)
str(trip.catch)

regs <- read.csv(here("one_plus", "TidyData", "regulations_RS_GT.csv"))
head(regs)
#regs$cfd_rs <- NULL
colnames(regs)[1] <- "Year"

tc.regs <- trip.catch %>% 
  mutate(bl_vs = NA,
         sl_vs = NA,
         fd_vs = NA,
         bl_rs = NA, 
         sl_rs = NA,
         fd_rs = NA,
         bl_gt = NA, 
         sl_gt = NA, 
         fd_gt = NA)

for(i in 1:nrow(regs)){
  
  ind <- which(tc.regs$year == regs$Year[i])
  tc.regs[ind,c(12:20)] <- regs[i,-1]
}

tc.regs <- tc.regs %>% 
  mutate_at(c("bl_rs", 
              "sl_rs", 
              "fd_rs", 
              "bl_gt", 
              "sl_gt", 
              "fd_gt"), 
            as.numeric) %>% 
  select(-c("st", 
            "fsh_mode", 
            "area", 
            "wave", 
            "fl_reg",
            "CATCH")) %>% 
  mutate(choice = factor(choice))


write.csv(trip.catch, file = here("MRIP_data", "trip_and_catch_dat.csv"))

head(tc.regs)

### MULTINOMIAL LOGISTIC REGRESSION
#create mlogit data
mlog.dat <- mlogit.data(data = tc.regs, choice = "choice", shape = "wide", varying = c(6:14), sep = "_")

m1 <- mlogit(choice ~ sl + fd + bl, data = mlog.dat, reflevel = "vs")
#m2 alternate specific fishing days: as fishing days increase gt is less likely than vs and rs is more likely than vs
m2 <- mlogit(choice ~ sl + bl | fd, data = mlog.dat, reflevel = "vs")
#alternate invariant fd and sl
m3 <- mlogit(choice ~ fd + sl | bl, data = mlog.dat, reflevel = "vs")
m4 <- mlogit(choice ~ bl + sl, data = mlog.dat, reflevel = "vs")

## mixed logit model  
mx2 <- mlogit(choice ~ sl + bl | fd, data = mlog.dat, reflevel = "vs", rpar = c(sl = 'n', bl = 'n'))
mx1 <- mlogit(choice ~ sl + bl, data = mlog.dat, reflevel = "vs", rpar = c(sl = 'n', bl = 'n'))
mx3 <- mlogit(choice ~ sl + fd | bl, data = mlog.dat, reflevel = "vs", rpar = c(sl = 'n', fd = 'n'))
summary(mx2)
AIC(mx2)
AIC(mx1)
AIC(mx3)
(exp(coefficients(mx2))-1) * 100
### Comparing models
AIC(m1)
AIC(m2) #best model
AIC(m3)
AIC(m4)

s2 <- summary(m2)
write.csv(as.data.frame(s2$CoefTable), here("Figures", "Chapter2", "m2_coefficients.csv"))
### LOG ODDS in %
(exp(coefficients(m2))-1) * 100

### Fitted probabilities figure
m2$probabilities %>% 
  as.data.frame() %>% 
  mutate(Year = tc.regs$year) %>% 
  rename("Vermilion Snapper" = "vs",
         "Gray Triggerfish" = "gt", 
         "Red Snapper" = "rs") %>% 
  pivot_longer(cols = -Year, names_to = "Species", values_to = "Probability") %>% 
  group_by(Year, Species) %>% 
  summarise(Probability = mean(Probability)) %>% 
  ggplot(aes(x = Year, y = Probability, group = Species, linetype = Species)) +
  geom_line() +
  theme_classic() +
  labs(y = "Targeting Probability") +
  scale_x_continuous(breaks = seq(2006, 2018, by = 1), labels = seq(2006, 2018, by = 1)) +
  geom_vline(xintercept = c(2008, 2013, 2014, 2016,2017), color = c("red", "black", "red", "black", "red")) +
  ggsave(here("Figures", "Chapter2", "targeting_prob_regs.png"), dpi = 600)


### PREDICTING FUTURE PROBABILITIES
head(m2$probabilities)
tail(m2$probabilities)

probs <- m2$probabilities
probs <- probs %>%
  mutate(Year = tc.regs$year)
probs <- probs %>%
  as.data.frame() %>%
  mutate(Year = tc.regs$year)

probs %>% 
  group_by(Year) %>% 
  summarise(vs = mean(vs), 
            gt = mean(gt), 
            rs = mean(rs))

pred.regs <- read.csv(here("one_plus", "TidyData", "future_regs_1.csv"))
pred.regs <- read.csv(here("one_plus", "TidyData", "future_regs_2.csv"))
pred.regs <- read.csv(here("one_plus", "TidyData", "future_regs_3.csv"))

bl <- pred.regs %>% 
  select(year, contains("bl")) %>% 
  rename(gt = "bl_gt", 
         rs = "bl_rs", 
         vs = "bl_vs") %>% 
  pivot_longer(cols = -year, 
               values_to = "bl")
sl <- pred.regs %>% 
  select(year, contains("sl")) %>% 
  rename(gt = "sl_gt", 
         rs = "sl_rs", 
         vs = "sl_vs") %>% 
  pivot_longer(cols = -year, 
               values_to = "sl")
fd <- pred.regs %>% 
  select(year, contains("fd")) %>% 
  rename(gt = "fd_gt", 
         rs = "fd_rs", 
         vs = "fd_vs") %>% 
  pivot_longer(cols = -year, 
               values_to = "fd")

pred.regs <- merge(bl, sl, by = c("year", "name")) %>% 
  merge(fd, by = c("year", "name")) %>% 
  mutate(choice = rep(c(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE),17))
write.csv(pred.regs, here("one_plus", "TidyData", "pred.regs.1.csv"))
write.csv(pred.regs, here("one_plus", "TidyData", "pred.regs.2.csv"))
write.csv(pred.regs, here("one_plus", "TidyData", "pred.regs.3.csv"))

pred.regs <- read.csv(here("one_plus", "TidyData", "pred.regs.1.csv"))
pred.regs <- read.csv(here("one_plus", "TidyData", "pred.regs.2.csv"))
pred.regs <- read.csv(here("one_plus", "TidyData", "pred.regs.3.csv"))

pred.ml <- mlogit.data(pred.regs, choice = "choice", shape = "long", alt.levels = c("gt", "rs", "vs"))

pred.probs <- as.data.frame(predict(m2, pred.ml))
write.csv(pred.probs, file = here("one_plus", "TidyData", "pred.probs.1.csv"))
write.csv(pred.probs, file = here("one_plus", "TidyData", "pred.probs.2.csv"))
write.csv(pred.probs, file = here("one_plus", "TidyData", "pred.probs.3.csv"))
### FITTING CATCH
## Eastern private and charter catch
rec.catch <- read.csv(here("one_plus", "TidyData", "rec_catch_by_mode.csv"))
head(rec.catch)

lm.dat <- m2$probabilities %>% 
  as.data.frame() %>% 
  mutate(year = trip.catch$year) %>% 
  filter(year < 2018) %>% 
  group_by(year) %>% 
  summarise(vs = mean(vs),
            rs = mean(rs), 
            gt = mean(gt)) 

rec.csub <- rec.catch %>% 
  mutate_at(c("PC", "HB", "Total"), ~./1000) %>% 
  filter(str_detect(reg, "East") & Year > 2005) %>% 
  mutate(pc.prop = 1- prop, 
         vs = lm.dat$vs)

mod <- lm(PC ~ vs, rec.csub)
fit.mod <- cbind(rec.csub, predict(mod, rec.csub, interval = "confidence"))
summary(mod)

fit.mod %>% 
  ggplot(aes(x = Year, y = fit, ymin = lwr, ymax = upr)) +
  geom_ribbon(alpha = 0.4) +
  geom_line() +
  geom_point(aes(x = Year, y = PC))

future.catch <- as.data.frame(cbind(seq(2018, 2068), predict(mod, pred.probs, interval = "prediction")))

write.csv(future.catch, file = here("one_plus", "TidyData", "future.catch2.csv"), row.names = F)

fit.mod %>% 
  #mutate(fit = mod$fitted.values) %>% 
  ggplot(aes(x = Year, y = fit, ymin = lwr, ymax = upr)) +
  geom_ribbon(alpha = 0.4) +
  geom_line() +
  geom_point(aes(x = Year, y = PC)) +
  #geom_ribbon(data = future.catch, aes(x = V1, ymin = lwr, ymax = upr), alpha = 0.4) +
  geom_line(data = future.catch, aes(x = V1, y = fit)) + 
  theme_classic() +
  labs(y = "Fitted Landings (1000's fish)") +
  scale_x_continuous(breaks = seq(2006, 2068, by = 4)) +
  ggsave(here("Figures", "Chapter2", "fitted_rec_catch_plus_forecast.png"), dpi = 600)

fit.mod %>% 
  ggplot(aes(x = Year, y = fit, ymin = lwr, ymax = upr)) +
  geom_ribbon(alpha = 0.4) +
  geom_line() +
  geom_point(aes(x = Year, y = PC)) + 
  theme_classic() +
  labs(y = "Fitted Landings (1000's fish)") +
  scale_x_continuous(breaks = seq(2006, 2018, by = 2)) +
  ggsave(here("Figures", "Chapter2", "fitted_rec_catch.png"), dpi = 600)
