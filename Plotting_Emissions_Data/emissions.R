# all R code for this assignment is right here --- you don't have to open 6 different files!
# download file to wd, unzip and load dataset and codebook
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Plot 1
# make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
totalEmi <- aggregate(Emissions~year, data=NEI, FUN=sum)
png(filename="totalEmissions.png",width=480, height=480)
plot(totalEmi, type="l", xlab="Year", main="Total PM2.5 Emission 1999-2008")
dev.off()
# yes, total emissions have decreased


# Plot 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?
baltimore2.5 <- subset(NEI, fips == 24510)
agg_baltimore2.5_sum <- aggregate(Emissions~year, data=baltimore2.5, FUN=sum)
agg_baltimore2.5_avg <- aggregate(Emissions~year, data=baltimore2.5, FUN=mean)
png(filename="baltimore2.5.png",width=650, height=480)
par(mfrow=c(1,2))
plot(agg_baltimore2.5_sum, type="l", xlab="Year", main="Total BaltimorePM2.5 Emission 1999-2008")
plot(agg_baltimore2.5_avg, type="l", xlab="Year", main="Avg BaltimorePM2.5 Emission 1999-2008")
dev.off()
# yes, total emissions have decreased in Baltimore


# Plot 3
# Which emission types have seen increases/decreases in emissions from 1999–2008 in the city of Baltimore, Maryland?
library(ggplot2)
library(reshape)
baltimore2.5 <- subset(NEI, fips == 24510)
png(filename="baltimore2.5type.png",width=480, height=480)
newDF <- melt(baltimore2.5, id.vars=c('type','year'), measure.vars='Emissions')
p <- ggplot(newDF, aes(x=type, y=value)) + geom_bar(aes(fill=as.factor(year)), position="dodge", stat="identity")
p + ggtitle("Total Emissions by Type")
dev.off()
# between 1999 and 2008, all emission types have decreased --- nonpoint emissions the most so by percent change


# Plot 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
group <- SCC[grep("Coal$", SCC[,4]),1]
coal2.5 <- NEI[which(NEI$SCC %in% group),]
agg_coal2.5 <- aggregate(Emissions~year, data=coal2.5, FUN=sum)
png(filename="coal25.png", width=480, height=480)
plot(agg_coal2.5, type="l", main="Coal Combustion Related Emissions")
dev.off()
# Coal combustion-related emissions have fallen between 1999 and 2008


# Plot 5
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
g <- SCC[grep("Vehicles", SCC[,4]),1]
baltimore2.5 <- subset(NEI, fips == "24510")
baltimore2.5MV <- baltimore2.5[which(baltimore2.5$SCC %in% g),]
agg_baltimore2.5MV <- aggregate(Emissions~year, data=baltimore2.5MV, FUN=sum)
png(filename="baltMV.png")
plot(agg_baltimore2.5MV, type="l", main="Motor Vehicle Emissions, Baltimore")
dev.off()
# motor vehicle emissions in Baltimore have fallen



# Plot 6
# Which city (Baltimore or LA) has seen greater changes over time (1999-2008) in motor vehicle emissions?
library(ggplot2)
library(reshape2)
# get the necessary SCC codes for motor vehicle emissions
g <- SCC[grep("Vehicles", SCC[,4]),1]
# subset the data for just la and baltimore
laBaltimore <- subset(NEI, fips == "24510" | fips == "06037")
# subset above dataset for only motor vehicle emissions codes
laBalMV <- laBaltimore[which(laBaltimore$SCC %in% g),]
# melt above dataset
melt_laBalMV <- melt(laBalMV, id.vars=c('fips','year'), measure.vars='Emissions')
# rename zip codes with city names
melt_laBalMV$fips <- gsub("24510", "Baltimore", melt_laBalMV$fips)
melt_laBalMV$fips <- gsub("06037", "Los Angeles", melt_laBalMV$fips)
# create the graphic
png(filename="laBaltimore.png", width=480, height=480)
ggplot(melt_laBalMV, aes(x=fips, y=value, xlab="new")) + geom_bar(aes(fill=as.factor(year)), position="dodge", stat="identity")+xlab("Location")+ylab("Total MV Emissions")+ggtitle("Motor Vehicle Emissions 1999-2008")
dev.off()
# motor vehicle emissions in Baltimore have fallen, while LA's have risen significantly