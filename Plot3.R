#Create plot: graph of Energy Sub metering
#This creates graph of 3 energy sub meters in one graph
#and exports it to a PNG file

#The source data is coming from the UC Irvine Machine Learning Repository
#Adres: http://archive.ics.uci.edu/ml/

library(plyr)
library(dplyr)
library(lubridate)

##### DOWNLOAD ZIP AND EXTRACT #####
# only extract if extraction folder not yet exists (download is slow)
if (!file.exists("household_power_consumption.txt")){
  
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")
  
  unzip("household_power_consumption.zip",exdir=work_dir)   # extracted file is: household_power_consumption.txt
  
}


##### LOAD DATASET AND FILTER FOR 1 and 2 febr 2017 #####
# only read in 70000 rows as we are only interested in 1/2 febr 2007 (and dataset is very large)
consumption <- read.csv("household_power_consumption.txt", sep=";", na.strings="?", nrows=70000) 

#filter for only 1 and 2 febr. First convert Date and Time variables to new datetime variable (POSIXct format)
consumption <- mutate(consumption,datetime=paste(consumption$Date,consumption$Time))
consumption$datetime <- as.POSIXct(strptime(consumption$datetime,format="%d/%m/%Y %H:%M:%S"))
consumption <- filter(consumption,consumption$datetime>=strptime("01/02/2007 00:00:00",format="%d/%m/%Y %H:%M:%S") & consumption$datetime < strptime("03/02/2007 00:00:00",format="%d/%m/%Y %H:%M:%S"))


##### Create the plot and export it to PNG
png("plot3.png", width = 480, height = 480)
#windows() #used for display on screen
plot(consumption$Sub_metering_1 ~ consumption$datetime, type="l", col="black", main="", xlab="", ylab="Energy submetering")
lines(consumption$Sub_metering_2 ~ consumption$datetime, type="l", col="red")
lines(consumption$Sub_metering_3 ~ consumption$datetime, type="l", col="blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), col=c("black","red", "blue"), lty=1)

xlabels <- seq(consumption$datetime[1],consumption$datetime[nrow(consumption)], by="day")
axis.POSIXct(1, at=xlabels, labels=format(xlabels, "%a")) #note that my plot labels are in local format (e.g. english = Fri, Dutch = vr)
dev.off()
print("plot printed to plot3.png")

