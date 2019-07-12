#### Predicted RS Biomass Trajectory ####

b.cur <- tail(group_bio_sub$RS, n =1)
b.targ <- 90449

slope <- (b.targ - b.cur)/(2032 - 2014)
b <- b.cur - (slope*2014)
x <- seq(2015,2032)
y1 <- slope*x + b
y/group_bio_sub$K[1]
plot(seq(1950,2032), c(group_bio_sub$rs_rel, y/group_bio_sub$K[1]), type = "l")
lines(seq(1950,2032), c(group_bio_sub$rs_rel, y1/group_bio_sub$K[1]), type = "l", col = col[1])
abline(v = 2014)
