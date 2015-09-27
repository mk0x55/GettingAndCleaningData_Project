#####################################################################
###  Project assignment for the course Getting and Cleaning Data  ###
###  Matus Korman <matusk@gmail.com>, 2015-09-27                  ###
#####################################################################

# NOTE: Prior to running the script, make sure to setwd() to an appropriate directory.

# STAGE 0: Load all libraries
library(dplyr)
library(tidyr)
library(data.table)

# STAGE 1: Download and extract the data if needed
dataFile <- "./getdata_projectfiles_UCI\ HAR\ Dataset.zip"
if (!file.exists(dataFile)) {
  # download the file
  dataFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(dataFileUrl, destfile = dataFile, method="curl")
}
if (!file.exists("./UCI\ HAR\ Dataset")) {
  # extract the archive contents
  unzip(dataFile, exdir = "./")
}

# STAGE 2: Extract and the data
features <- tbl_df(read.table("UCI\ HAR\ Dataset/features.txt"))
activityLabels <- tbl_df(read.table("UCI\ HAR\ Dataset/activity_labels.txt"))
trainingData <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
trainingDataSubjects <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
trainingDataLabels <- read.table("UCI\ HAR\ Dataset/train/y_train.txt")
testData <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
testDataSubjects <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
testDataLabels <- read.table("UCI\ HAR\ Dataset/test/y_test.txt")

# STAGE 3: Merge the training and test data sets
# merge the data sets
data <- rbind(trainingData, testData)
dataSubjects <- rbind(trainingDataSubjects, testDataSubjects)
dataLabels <- rbind(trainingDataLabels, testDataLabels)
# free the old ones from memory
rm(trainingData, testData)
rm(trainingDataSubjects, testDataSubjects)
rm(trainingDataLabels, testDataLabels)

# STAGE 4: Extract means and standard deviations
# extract mean features
meanFeatures <- filter(features, grepl("*mean*", V2), !grepl("*meanFreq*", V2))
meanFeaturePositions <- as.vector(as.matrix(meanFeatures[,1]))
meanFeatureNames <- as.vector(as.matrix(meanFeatures[,2]))
# extract sd features
sdFeatures <- filter(features, grepl("*std*", V2))
sdFeaturePositions <- as.vector(as.matrix(sdFeatures[,1]))
sdFeatureNames <- as.vector(as.matrix(sdFeatures[,2]))
# extract mean and sd data
meanData <- select(data, meanFeaturePositions)
sdData <- select(data, sdFeaturePositions)
# name the columns of mean and sd data
names(meanData) <- meanFeatureNames
names(sdData) <- sdFeatureNames
# free data that is no longer needed
rm(data, features, meanFeatures, sdFeatures, meanFeatureNames, sdFeatureNames, meanFeaturePositions, sdFeaturePositions)

# STAGE 5: Tidy up the extracted data
# merge the relevant tables
mergedData <- cbind(dataSubjects, dataLabels, meanData, sdData)
# name the not-yet-named columns
names(mergedData)[1] <- "Subject"
names(mergedData)[2] <- "ActivityLabel"
# transform the activity label numbers into text values
tidyData1 <- mutate(mergedData, ActivityLabel = as.vector(as.matrix(activityLabels[ActivityLabel,][2])))
# free the merged data and other stuff that is no longer needed
rm(mergedData, dataSubjects, dataLabels, meanData, sdData, activityLabels)

# STAGE 6: Create the second tidy data set
# extract the averages by groups of subjects and activities
tidyData2 = tidyData1 %>% group_by(Subject, ActivityLabel) %>% summarize_each(funs(mean))
# update the labels to reflect that they are just mean values
names(tidyData2)[3:68] <- paste(names(tidyData2)[3:68], "-mean", sep="")

# STAGE 7: Output the second tidy data set
write.table(tidyData2, file = "./OutputTidyDataSet.txt", row.names = FALSE)
