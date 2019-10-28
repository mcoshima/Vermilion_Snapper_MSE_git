## Checking results of MSE 

 
asses_1 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2018.5"), covar = F, NoCompOK = T)

asses_2 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2023.5"), covar = F, NoCompOK = T)

asses_3 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2028.5"), covar = F, NoCompOK = T)

asses_4 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2033.5"), covar = F, NoCompOK = T)

asses_5 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2038.5"), covar = F, NoCompOK = T)

asses_6 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2043.5"), covar = F, NoCompOK = T)

asses_7 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2048.5"), covar = F, NoCompOK = T)

asses_8 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2053.5"), covar = F, NoCompOK = T)

asses_9 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2058.5"), covar = F, NoCompOK = T)

asses_10 <- MO_SSoutput(dir = here("one_plus", "assessments", "Year_2063.5"))


asses_10$cpue %>% 
  filter(Yr > 1985) %>% 
  filter(Fleet == 3 | Fleet == 4 | Fleet == 5 | Fleet == 8 | Fleet == 9 | Fleet == 11 | Fleet == 12) %>% 
  ggplot(aes(x = Yr, y = Obs)) + 
  geom_point() +
  facet_wrap(~Fleet) + 
  geom_line(aes(x = Yr, y = Exp)) + 
  theme_pub()

asses_10$catch %>% 
  select(Fleet, Yr, sel_num) %>% 
  mutate(Fleet = as.factor(Fleet), sel_num = as.numeric(sel_num)) %>%
  ggplot(aes(x = Yr, y = sel_num, colour = Fleet)) + 
  geom_line() 


sprseries <- asses_10$sprseries
timeseries <- asses_10$timeseries
derived_quants <- asses_10$derived_quants

sprseries %>% select(c(1,7)) %>% ggplot(aes(x = Yr, y = SPR)) + geom_point()

plot(sprseries$Yr, sprseries$SPR, pch = 16, xlim = c(1950, 2064), ylim = c(0,1), col = nord_cols[1], ylab = "SPR", xlab = "Year")
abline(h = 0.3, col = nord_cols[1])

head(timeseries)
plot(sprseries$Yr, sprseries$sum_Apical_F, pch = 16, col = nord_cols[1], ylab = "Summary F", xlab = "Year", xlim = c(1950, 2060))

sprseries$sum_Apical_F[which(sprseries$Yr > 1960)]

plot(timeseries$Yr, timeseries$Bio_all, xlim = c(1950,2064))


mean_catch <- matrix(data = NA, nrow = 100, ncol = 5)
mean_catch <- as.data.frame(mean_catch)
colnames(mean_catch) <- c("Iteration", "Com_E", "Com_W", "Rec", "Shrimp")
mean_catch$Iteration <- seq(1,100)
mean_catch[1,c(2:5)] <- asses_10$timeseries %>% filter(Yr < 2065) %>% select(c(13,21,29,39)) %>%  colMeans()


asses_10$derived_quants %>% filter(str_detect(Label, "Bratio"))


term_bio <- timeseries %>% filter(Yr == 2064) %>% select(Bio_all) %>% pull()
init_bio <- timeseries %>% filter(Yr == 1948) %>% select(Bio_all) %>% pull()

overfished <- term_bio/init_bio


asses_10$derived_quants %>% filter(str_detect(Label, "F_"))

asses_10$cpue %>% filter(Fleet == 9) %>% select(Yr, Vuln_bio, Obs, Exp)
asses_10$cpue %>% filter(Fleet == 8) %>% select(Yr, Vuln_bio, Obs, Exp)
plot(timeseries$Yr, timeseries$`dead(B):_5`, xlim = c(1950, 2060))

report.$catch %>% filter(Fleet == 5)
