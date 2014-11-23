# load required packages
install.packages("reshape2")
library(reshape2)

# find and set the working directory and call it hereiam
directory <- getwd()
if (file.exists("data")){
  setwd(paste(directory,"/data", sep=""))
} else {
  dir.create("data")
  setwd(paste(directory,"/data", sep=""))
}
hereiam <- getwd()

# download zip file to wd and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile=paste(hereiam, "/zipfile.zip", sep=""), method="curl")
dateDownloaded <- date()
unzip("zipfile.zip")

##################################

hereiam <- getwd()

# function to transform numeric activity id to descriptive activity name
changeToActivity <- function(x){
  if (x == 6){
    x = "laying"
  } else if (x == 5){
    x = "standing"
  } else if (x == 4){
    x = "sitting"    
  } else if (x == 3){
    x = "walking_downstairs"
  } else if (x == 2){
    x = "walking_upstairs"
  } else {
    x = "walking"
  }
}

# read features and create vector of feature names in order to rename variables later
features <- read.table(paste(hereiam, "/UCI HAR Dataset/features.txt", sep=""), header=FALSE) # upload feature set
features2 <- as.character(features$V2)

# function to read and organize "y" data into usable dataframe
read_y <- function(filename){
  y <- read.table(paste(hereiam, "/UCI HAR Dataset/", filename, ".txt", sep=""), header=F)
  y2 <- sapply(y$V1, changeToActivity)
  yR <- data.frame(activity=y2)
}

# read and transform "y" data
yReady <- read_y("train/y_train")
yReadyTest <- read_y("test/y_test")

# function to read and organize "x" data into usable dataframe
read_x <- function(filename){
  x <- read.table(paste(hereiam, "/UCI HAR Dataset/", filename, ".txt", sep=""), header=F)
  colnames(x) <- c(features2)
  x
}

# read and transform "x" data
xReady <- read_x("train/X_train")
xReadyTest <- read_x("test/X_test")

# read training and test subjects to combine with "x" and "y" dataframes
subjectsTrain <- read.table(paste(hereiam, "/UCI HAR Dataset/train/subject_train.txt", sep=""), header=FALSE) # upload train subjects set
subjectsTest <- read.table(paste(hereiam, "/UCI HAR Dataset/test/subject_test.txt", sep=""), header=FALSE) # upload test subjects set

# create combined dataset (training date + test data)
fullTrain <- cbind(subjectsTrain, yReady, xReady) 
fullTest <- cbind(subjectsTest, yReadyTest, xReadyTest)
fullDataset <- rbind(fullTrain, fullTest)

# rename first column and condense dataset to only "mean()" or "std()" variables 
names(fullDataset)[1] <- "subID"
fullDataset1 <- fullDataset[grep("subID", names(fullDataset))]
fullDataseta <- fullDataset[grep("activity", names(fullDataset))]
fullDatasetm <- fullDataset[grep("mean\\(\\)", names(fullDataset))]
fullDatasets <- fullDataset[grep("std\\(\\)", names(fullDataset))]
fd <- cbind(fullDataset1, fullDataseta, fullDatasetm, fullDatasets)

# clean up variable names to make more readable
names(fd) <- gsub("-"," ",names(fd),)
names(fd) <- gsub("[()]","",names(fd),)
varNames <- as.character(names(fd[3:ncol(fd)]))

# break data into ID's and variables and summarize data by subject and activity
meltFD <- melt(fd,id=c("subID", "activity"),measure.vars=c(varNames))
tidyData <- dcast(meltFD, subID + activity ~ variable, mean)

# write tidyData set into text file in working directory
write.table(tidyData, file="tidyData.txt")