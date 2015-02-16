## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load required libraries
require(RCurl)
require(dplyr)
require(plyr)

# Download data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
# Extract dataset
unzip("./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = ".")

# Data directory - ensure working directory is set to contain data directory specified
data_dir <- "UCI HAR Dataset"

# List all files in data directory recursively checking all directories
if(!file.exists(paste(getwd(),data_dir,sep = "/")))
  stop("data directory does not exist")

files  <- list.files(data_dir,pattern = '\\.txt', recursive=TRUE, full.names=FALSE, include.dirs=TRUE)
  
################################################################################
## Determines all the relevant files and paths for processing files 
################################################################################
# Determine all x files
xfiles<-files[grep("/[xX]_train\\.txt|/[xX]_test\\.txt",files)]
# Determine all y files
yfiles<-files[grep("/[yy]_train\\.txt|/[yY]_test\\.txt",files)]
# Determine all subject files
subjectfiles<-files[grep("subject",files)]
# Determine activity_lablels.txt file
activityfile<-files[grep("activity_labels\\.txt",files)]
# Read list activity
activities<-read.csv(paste(data_dir,activityfile,sep = "/"), sep="",header = FALSE)
# Determine features.txt file
featuresfile<-files[grep("features\\.txt",files)]

# Read features file
features<-read.csv(paste(data_dir,featuresfile,sep = "/"), sep="",header = FALSE)

# Combine x files
xtables<-lapply(paste(data_dir,xfiles,sep = "/"), read.csv, sep="",header = FALSE)
xtables<-bind_rows(xtables)

# Combine y files
ytables<-lapply(paste(data_dir,yfiles,sep = "/"), read.csv, sep="",header = FALSE)
ytables<-bind_rows(ytables)

# Combine subject files
subjecttables<-lapply(paste(data_dir,subjectfiles,sep = "/"), read.csv, sep="",header = FALSE)
subjecttables<-bind_rows(subjecttables)

################################################################################
## 1.Merges the training and the test sets to create one data set.
################################################################################
# Build the full dataset
fulldata<-bind_cols(subjecttables,ytables,xtables)

# Clean up intermediate tables no longer used
rm(subjecttables,ytables,xtables)

################################################################################
## 4.Appropriately labels the data set with descriptive variable names. 
################################################################################
# Relabel column names with subject, activity, and features
colnames(fulldata)<-c("subject","activity",as.character(features[,2]))
rm(features)

################################################################################
## 3.Uses descriptive activity names to name the activities in the data set
################################################################################
# Change activity column to a factor with labels
fulldata[,"activity"]<-factor(fulldata[,"activity"],labels=activities[,2])
rm(activities)

################################################################################
## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
################################################################################
measuresdata<-fulldata[,grep("subject|activity|-mean\\(\\)|-std\\(\\)",colnames(fulldata))]

################################################################################
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################################################
measuresonly<- names(subset(measuresdata,select=-c(activity,subject)))
tidydataframe <- aggregate(measuresdata[,measuresonly], by=measuresdata[c("activity","subject")], FUN=mean)

## Write tidy data set to a file
write.table(tidydataframe, "Samsung_Galaxy_Tidy_Data.txt", sep = ",", row.names=FALSE,quote=FALSE)
