library(data.table)

##downloading data
wd <- getwd()

link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
newFile <- "PowerConsumption.zip"
download.file(link, file.path(wd, newFile))

##Unzip the file to the current directory
unzip("PowerConsumption.zip", overwrite = T, unzip="internal")

##read in the data
path <- "household_power_consumption.txt"
Dataset <- data.table(fread(path, sep=";", colClasses="character"))

##filter the data by date
filteredDataset <- Dataset[Dataset$Date %in% c("1/2/2007","2/2/2007")]

##concatenate Date and Time into one DateTime column
filteredDataset$DateTime <- paste(filteredDataset$Date,filteredDataset$Time)

##change the class of each column to the correct ones
filteredDataset$DateTime <- as.POSIXct(filteredDataset$DateTime, format="%d/%m/%Y %H:%M:%S")
filteredDataset$Global_active_power <- as.numeric(filteredDataset$Global_active_power)
filteredDataset$Global_reactive_power <- as.numeric(filteredDataset$Global_reactive_power)
filteredDataset$Voltage <- as.numeric(filteredDataset$Voltage)
filteredDataset$Global_intensity <- as.numeric(filteredDataset$Global_intensity)
filteredDataset$Sub_metering_1 <- as.numeric(filteredDataset$Sub_metering_1)
filteredDataset$Sub_metering_2 <- as.numeric(filteredDataset$Sub_metering_2)
filteredDataset$Sub_metering_3 <- as.numeric(filteredDataset$Sub_metering_3)

##make plot
png("plot3.png")
with(filteredDataset, plot(DateTime, Sub_metering_1, type="l"
                           , ylab="Energy sub metering", xlab="", col="black"))
with(filteredDataset, lines(DateTime, Sub_metering_2, col="red"))
with(filteredDataset, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", lty=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ))
dev.off()