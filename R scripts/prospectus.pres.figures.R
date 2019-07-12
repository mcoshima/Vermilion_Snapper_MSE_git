## Prospectus Presentation

col.pal <- c("#E97C68", "#3D847C", "#103444", "#D24B38")
col.grad <- c("#AAD7E9", "#DDEFF6", "#55AFD3", "#277797", "#113442", "#CB5043", "#D06459", "#D5786F", "#E1A09B", "#2B5F5A", '#4E8E88', '#81ADA8', "#B8C8C6", "#333F50", "#234D61","#40697E", "#668293", "#969A9D")

#Distribution map
library(maptools)

location <- read.csv("VS_locationdat.csv", header = T, skip = 30, stringsAsFactors = F)
head(location)

shp <- readShapePoly("C:/Users/w986430/Desktop/Code/MSE/countries_shp/countries")
location$Center.Lat <- as.numeric(location$Center.Lat)
location$Center.Long <- as.numeric(location$Center.Long)
location <- location[-which(is.na(location$Center.Lat)==T),]

library(rgeos)
library(gdistance)
install.packages("measurements")
library(measurements)

location$lat <- conv_unit(location$Center.Lat, from = "dec_deg", to = "deg_min_sec")
location$long <- conv_unit(location$Center.Long, from = "dec_deg", to = "deg_min_sec")

coordinates(location) = ~Center.Long+Center.Lat

#make plot, coordinates aren't projected
plot(location, pch = 20, col = col.pal[1], xlim = c(-134.65881, -32.17645), ylim = c(-63.16861, 50.61695))
plot(shp, xlim = c(-134.65881, -32.17645), ylim = c(-63.16861, 50.61695), col = "grey90", add = T)


## Commercial and recreational landings
com.dat <- read.csv("vs.commercial.landings.csv", skip = 4, header = T)
head(com.dat)
rec.dat <- read.csv("vs.mrip.csv", skip = 28, header = T)
head(rec.dat)
rec.dat$MT <- conv_unit(rec.dat$Harvest..A.B1..Total.Weight..lb., from = "lbs", to = "metric_ton")
png(file="Comm.Rec2.landings.wRS.png" , height=10,  width=12, pointsize=24, units = "in", res = 500)
plot(com.dat$Year, com.dat$Metric.Ton, type = "b", col = col.grad[3], pch = 16, xlab = "Year", ylab = "Landings (MT)", las = 1, ylim = c(0,1700))
lines(rec.dat$Year, rec.dat$MT, type = "b", col = col.grad[4], pch = 16)
segments(x0 = 2010, y0 = 100, x1 = 2010, y1 = 400, lwd = 2, col = col.pal[3])
#segments(x0 = 2007, y0 = 900, x1 = 2007, y1 = 1250, lwd = 2, col = col.pal[3])
dev.off()


trip.dat <- read.csv("directed_trip_data.csv")
head(trip.dat)
plot(trip.dat$Year, trip.dat$VS.Primary.Target, type = "l", col = col.pal[1])
lines(trip.dat$Year, trip.dat$VS.Secondary.Target, type = "l", col = col.pal[2])
lines(trip.dat$Year, trip.dat$RS.Primary.Target,  col = col.pal[4])

png(file="Directed.Trips.prim.png" , height=10,  width=12, pointsize=24, units = "in", res = 500)
par(mar = c(4,4,2,4))
plot(trip.dat$Year, trip.dat$VS.Primary.Target, type="l", col=col.grad[4], 
             ylab="Number of trips for Vermilion Snapper (Thousands)",
             xlab = "Year",
             lwd = 3.5,
              yaxt = "n")
#lines(trip.dat$Year, trip.dat$VS.Secondary.Target, col=col.grad[3], lwd = 2) 
axis(2, at = c(0,10000,20000,30000,40000,50000,60000,70000), labels = c(0,10,20,30,40,50,60,70), las=1)
par(new = T)
with(trip.dat, plot(Year, RS.Primary.Target, type = "l", axes=F, xlab=NA, ylab=NA, cex=1.2, lwd = 3.5, col = col.grad[8]))
axis(side = 4, at = c(50000,100000,150000,200000), labels = c(50,100,150,200),las =1)
mtext(side = 4, line = 3, 'Number of trips for Red Snapper (Thousands)')
dev.off()


legend("topleft",
       legend=c("VS Primary Target", "VS Secondary Target", "RS Primary Target"),
       lty=1, lwd = 2, col=col.pal[1:3], bty = "n")


png(file="catch.png" , height=10,  width=10, pointsize=24, units = "in", res = 500)
plot(dat.$catch$year, dat.$catch$CM_E, type = "l", col = col.grad[1], xlab = "Year", ylab = "Catch", lwd = 2)
lines(dat.$catch$year, dat.$catch$CM_W,  col = col.grad[5], lwd = 2)
lines(dat.$catch$year, dat.$catch$REC, col = col.grad[3], lwd = 2)
lines(dat.$catch$year, dat.$catch$SMP_BYC,  col = col.grad[4], lwd = 2)
dev.off()

png(file="cpue.png" , height=10,  width=10, pointsize=24, units = "in", res = 500)
plot(dat.$CPUE$year, dat.$CPUE$obs, col = col.grad[dat.$CPUE$index], pch = 16, xlab = "Year", ylab = "CPUE")
dev.off()

fleetnames <- c("Commercial East", "Commercial West", "Recreational", "Shrimp Bycatch", "Headboat East", "Headboat West", "Com. East, IFQ", "Com. West IFQ", "Larval", "Video", "SEAMAP")

png(file="datats.png" , height=10,  width=10, pointsize=24, units = "in", res = 500)
SSplotData(report., fleetcol = col.grad, fleetnames = fleetnames)
dev.off()
