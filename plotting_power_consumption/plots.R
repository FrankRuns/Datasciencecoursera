# your charts will end up here; use setwd() if you want them someplace else
getwd()

# download zip and unzip to data directory
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "./zipfile.zip", method="curl")
unzip("./zipfile.zip")

# read Feb 1, 2007 and Feb 2, 2007 data points to file and rename columns
hpc <- read.table("./household_power_consumption.txt", sep=";", skip=66637, nrows=2880)
names(hpc)=c("date", "time", "active_power", "reactive_power", "voltage", "intensity", "sub_metering_1", "sub_metering_2", "sub_metering_3")

# change date and time to workable format
hpc$dt <- paste(hpc$time, hpc$date, sep=" ")
hpc$dt <- strptime(hpc$dt, format="%H:%M:%S %d/%m/%Y")

# Graph 1: Create histogram
png(filename="plot1.png",width=480, height=480)
hist(hpc$active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
dev.off()

# Graph 2: Create time series line chart
png(filename="plot2.png", width=480, height=480)
plot(hpc$dt, hpc$active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()

# Graph 3: Create multiline time series graph
png(filename="plot3.png", width=480, height=480)
plot(hpc$sub_metering_1, type="l", xaxt="n", xlab="", ylab="Energy sub metering")
mid <- length(hpc$dt)/2
axis(1, at=c(1, mid, length(hpc$dt)), lab=c("Thurs", "Fri", "Sat"))
lines(hpc$sub_metering_2,col="red",type="l",lwd=2)
lines(hpc$sub_metering_3,col="blue",type="l",lwd=2)
legend("topright",legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       lty=1,lwd=2,col=c("black","red","blue"),
       ncol=1,cex=0.8,
       inset=0.01)
dev.off()

# Graph 4: Create 4-panel chart
png(filename="plot4.png", width=480, height=480)
par(mfrow=c(2,2),mar=c(4,4,2,2))
plot(hpc$dt, hpc$active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
plot(hpc$dt, hpc$voltage, type="l", ylab="Voltage", xlab="datetime")
plot(hpc$sub_metering_1, type="l", xaxt="n", xlab="", ylab="Energy sub metering")
mid <- length(hpc$dt)/2
axis(1, at=c(1, mid, length(hpc$dt)), lab=c("Thurs", "Fri", "Sat"))
lines(hpc$sub_metering_2,col="red",type="l",lwd=2)
lines(hpc$sub_metering_3,col="blue",type="l",lwd=2)
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=1,lwd=2,col=c("black","red","blue"),
       ncol=1,bty="n", cex=0.8,
       inset=0.01)
plot(hpc$dt, hpc$reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
dev.off()