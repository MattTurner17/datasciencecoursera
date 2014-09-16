
library(data.table)
library(reshape2)
library(stringr)

##REMEMBER THAT THE UNZIPPED FILE SHOULD BE IN YOUR WORKING DIRECTORY.

##Finding your working directory
path <- getwd()

##Checking whether datafile "UCI HAR Dataset" already exists (this is assuming it has not been renamed)
##If it does not exist then download it and unzip it
if(!file.exists("UCI HAR Dataset")){
     ##Downloading file to projectData.zip
     link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     newFile <- "projectData.zip"
     download.file(link, file.path(path, newFile))

     ##Unzip the file to the current directory
     unzip("projectData.zip", overwrite = T, unzip="internal")
}

newPath <- file.path(path, "UCI HAR Dataset") ##IF YOU HAVE RENAMED THE FILE THEN CHANGE THAT HERE!

##Reading in the data from the various files within the UCI HAR Dataset folder
testSubject <- fread(file.path(newPath, "test", "subject_test.txt"))
trainSubject <- fread(file.path(newPath, "train", "subject_train.txt"))

testLabels <- data.table(read.table(file.path(newPath,"test","y_test.txt")))
trainLabels  <- data.table(read.table(file.path(newPath,"train","y_train.txt")))

testDataset <- data.table(read.table(file.path(newPath,"test","X_test.txt")))
trainDataset <- data.table(read.table(file.path(newPath,"train","X_train.txt")))

##Combining the subjects into one table, and the labels into another (remember that test has gone first, then train)
combinedSubject <- rbind(testSubject,trainSubject)
combinedLabels <- rbind(testLabels, trainLabels)
combinedDataset <- rbind(testDataset, trainDataset)

##Renaming the column names of subjects and labels for better clarity
##The activity_labels.txt file indicates that labels refers to a specific activity. So we call this column ActivityNumber
##The names for combinedDataset can be found in the features.txt file
setnames(combinedSubject, "V1","Subject")
setnames(combinedLabels, "V1","ActivityNumber")
featureNames <- fread(file.path(newPath,"features.txt"))
setnames(combinedDataset, names(combinedDataset), featureNames$V2)

##Joining the subjects and labels into one table (setting ket orders it)
allJoined <- cbind(combinedSubject, combinedLabels, combinedDataset)
setkey(allJoined, Subject, ActivityNumber)

##Identify column names for features containing mean() or std(). meanFreq() has been removed via the temp table.
textToFind <- c("mean()","std()")
colNames <- unique(grep(paste(textToFind,collapse="|"),names(allJoined), value=T))
tempTable <- data.table(cbind(colNames,!grepl("Freq",colNames)))
filteredColNames <- as.character(tempTable[tempTable$V2 == TRUE,]$colNames)

##Using the column names to filter the data table
dataMeanStd <- allJoined[,c("Subject","ActivityNumber",filteredColNames), with=FALSE]

##Reading in the activity names and renaming the columns
##(note that ActivityNumber is used so that it will match the column in dataMeanStd when merging)
activityNames <- fread(file.path(newPath, "activity_labels.txt"))
setnames(activityNames, names(activityNames), c("ActivityNumber", "ActivityName"))

##Merging oput main table with the activity names based on the activity number.
##Add key again so that table can be melted properly
dataMeanStd <- merge(dataMeanStd, activityNames, by="ActivityNumber", all.x=TRUE)
setkey(dataMeanStd, Subject, ActivityNumber, ActivityName)

##melting the table again, and removing now excess columns
dataMelted <- melt(dataMeanStd, key(dataMeanStd), variable.name="Feature")
dataMelted[,ActivityNumber:=NULL]

##Adding new columns that better describe the feature...
##Column to show domain signal based on first letter of feature
dataMelted$DomainSignal <- substring(dataMelted$Feature,1,1)
dataMelted$DomainSignal[dataMelted$DomainSignal == "f"] <- "Frequency"
dataMelted$DomainSignal[dataMelted$DomainSignal == "t"] <- "Time"

##Column showing whether measure is mean or standard deviation
dataMelted$Measure[grepl("mean()",dataMelted$Feature) == TRUE] <- "Mean"
dataMelted$Measure[grepl("std()",dataMelted$Feature) == TRUE] <- "Std Dev"

##Column showing axis direction
dataMelted$Axis[grepl("X$",dataMelted$Feature) == TRUE] <- "X"
dataMelted$Axis[grepl("Y$",dataMelted$Feature) == TRUE] <- "Y"
dataMelted$Axis[grepl("Z$",dataMelted$Feature) == TRUE] <- "Z"
dataMelted$Axis[is.na(dataMelted$Axis)] <- "No Axis"

##Column showing instrument used
dataMelted$RawSignal[grepl("Acc",dataMelted$Feature) == TRUE] <- "Accelerometer"
dataMelted$RawSignal[grepl("Gyro",dataMelted$Feature) == TRUE] <- "Gyroscope"

##Column showing type of acceleration signal
dataMelted$Acceleration[grepl("Body",dataMelted$Feature) == TRUE] <- "Body"
dataMelted$Acceleration[grepl("Gravity",dataMelted$Feature) == TRUE] <- "Gravity"

##Column showing whether the Euclidean norm was used to get a magnitude
dataMelted$Magnitude[grepl("Mag",dataMelted$Feature) == TRUE] <- "Magnitude"
dataMelted$Magnitude[is.na(dataMelted$Magnitude)] <- "Not Mag."

##Column showing whether a Jerk signal was obtained
dataMelted$JerkSignal[grepl("Jerk",dataMelted$Feature) == TRUE] <- "Jerk"
dataMelted$JerkSignal[is.na(dataMelted$JerkSignal)] <- "Not Jerk"

##Removing now irrelevent info from Feature
dataMelted$Feature <- sapply(strsplit(as.character(dataMelted$Feature),'-'), "[", 1)
dataMelted$Feature <- substring(dataMelted$Feature,2)
dataMelted$Feature <- gsub("Acc","",dataMelted$Feature)
dataMelted$Feature <- gsub("Gyro","",dataMelted$Feature)
dataMelted$Feature <- gsub("Body","",dataMelted$Feature)
dataMelted$Feature <- gsub("Gravity","",dataMelted$Feature)
dataMelted$Feature <- gsub("Mag","",dataMelted$Feature)
dataMelted$Feature <- gsub("Jerk","",dataMelted$Feature)

##Testing that all features have been accounted for.
if(unique(dataMelted$Feature) == ""){
     dataMelted[,Feature:=NULL]
     print("All features accounted for. Feature column deleted.")
} else{
     print("Not all features have been accounted for. Feature column not deleted. Please check working.")
}

##Ordering columns for final data set
setcolorder(dataMelted, c("Subject","ActivityName","DomainSignal","RawSignal","Acceleration","Axis","Magnitude","JerkSignal","Measure","value"))

##Getting the mean for each possible combination in dataMelted table
setkey(dataMelted, Subject, ActivityName, DomainSignal, RawSignal, Acceleration, Magnitude, Measure, JerkSignal, Axis)
finalTidyDataset <- dataMelted[, list(count = .N, average = mean(value)), by=key(dataMelted)]

finalTidyDataset

