# setwd("~/GitHub/exdata-data-NEI_data")
library(reshape2)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#converting variables to factors
NEI <- within(NEI,{
    year <- as.factor(year)
    type <- as.factor(type)
})

# #plot 1 for total emissions
# png("plot1.png")
# with(NEI,{
#     total.emissions <- tapply(Emissions,year,sum)
#     year <- levels(year)
#     plot(year, total.emissions,xaxt="n",yaxt="n",
#          ylab="Emissions (in million tons)",type="l",
#          main=expression('Total PM'[2.5]*' Emissions'))
#     axis(1,at=year)
#     axis(2,at=4:7*10^6,sprintf("%.2f",4:7))
# })
# dev.off()
# 
# NEI.balt <- NEI[balt.id,]
# 
# #plot 2 for total emissions in Baltimore City
# png("plot2.png")
# with(NEI.balt, {
#     total.emissions <- tapply (Emissions,year,sum)
#     year <- levels(year)
#     plot(year, total.emissions,xaxt="n",
#          ylab="Emissions (tons)",type="l",
#          main=expression('Total PM'[2.5]*' Emissions in Baltimore City'))
#     axis(1,at=year)
# })
# dev.off()
# 
# #table sum of emissions
# NEI.table <- with(NEI, {
#     tapply(Emissions, list(year, type), sum)
# })
# 
# #plot 3 for total emissions by type
# png("plot3.png")
# NEI.table <- data.frame(NEI.table, year = rownames(NEI.table))
# NEI.table.melt <- melt(NEI.table, id.vars = "year")
# names(NEI.table.melt) <- c("Year", "Type", "Emissions")
# qplot(Year, Emissions/10^6, data = NEI.table.melt, group = Type,
#       color = Type, geom = "line", ylab = "Emissions (in million tons)", 
#       main = expression('PM'[2.5]*' Emissions by Type'))
# dev.off()
# 
# SCC.coal <- with (SCC, {
#     SCC[grep("Coal", SCC.Level.Three)]
# })
# 
# #getting index for and subsetting of coal sources
# coal.id <- is.element(NEI$SCC, SCC.coal)
# NEI.coal <- NEI[coal.id, ]
# 
# #plot 4 for total emissions from coal
# png("plot4.png")
# with(NEI.coal, {
#     total.emissions <- tapply(Emissions,year,sum)
#     year <- levels(year)
#     plot(year, total.emissions / 1000, xaxt = "n",
#          ylab = "Emissions (in thousand tons)", type = "l",
#          main = expression('Total PM'[2.5]*' Emissions from Coal'))
#     axis(1,at = year)
# })
# dev.off()
# 
# 
# 
# #plot 5 for total emissions from motor vehicle in Baltimore City
# png("plot5.png")
# plot(PM25.balt.veh, type = "l", xaxt= "n", 
#      ylab = "Emissions (in tons)", 
#      main = expression('Total PM'[2.5]*' Emissions from Motor Vehicles in Baltimore City'))
# axis(1, at = PM25.balt.veh$Year)
# dev.off()
# 
#getting index for and subsetting of motor vehicles
balt.id <- NEI$fips=="24510"
veh.id <- NEI$type == "ON-ROAD"
NEI.balt.veh <- NEI[balt.id & veh.id,]

#table sum of emissions
PM25.balt.veh <- with(NEI.balt.veh, {
    Emissions <- tapply(Emissions,year,sum)
    Year <- as.numeric(names(Emissions))
    data.frame(Year, Emissions)
})

#getting index for and subsetting of motor vehicles and LA
LA.id <- NEI$fips == "06037"
NEI.LA.veh <- NEI[LA.id & veh.id,]

#table sum of emissions
PM25.LA.veh <- with(NEI.LA.veh, {
    Emissions <- tapply(Emissions,year,sum)
    Year <- as.numeric(names(Emissions))
    data.frame(Year, Emissions)
})


PM25.balt.LA.veh <- cbind(PM25.balt.veh$Emissions, PM25.LA.veh$Emissions)
Year <- PM25.balt.veh$Year

#plot 6 comparing emissions in Baltimore City and Los Angeles County
png("plot6.png")
matplot(Year, PM25.balt.LA.veh, type = "l", lty = 1, 
        ylab = "Emissions (in tons)", 
        main = expression('PM'[2.5]*' Emissions by City'))
legend("right",legend = c("Baltimore City", "Los Angeles County"), lty = 1,
       col = 1:2)
dev.off()