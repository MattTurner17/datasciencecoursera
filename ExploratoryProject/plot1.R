library(data.table)
library(sqldf)

##downloading data
wd <- getwd()

link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
newFile <- "PowerConsumption.zip"
download.file(link, file.path(wd, newFile))

##Unzip the file to the current directory
unzip("PowerConsumption.zip", overwrite = T, unzip="internal")

##read in the data (filtering for the right dates)
path <- "household_power_consumption.txt"
Dataset <- data.table(read.csv.sql(path, sql="SELECT * FROM file WHERE DATE IN ('1/2/2007','2/2/2007')", sep=";", header=T))

##concatenate Date and Time into one DateTime column and apply correct class
Dataset$DateTime <- paste(Dataset$Date,Dataset$Time)
Dataset$DateTime <- as.POSIXct(Dataset$DateTime, format="%d/%m/%Y %H:%M:%S")

##make plot
png("plot1.png", width = 480, height = 480, units= "px")
with(Dataset,hist(Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)"))
dev.off()