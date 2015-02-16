---
title: "Tidy Data Code Book"
author: "Hemal Wadhia"
date: "Friday, February 16, 2015"
---
  
##Dataset Description
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
  
  
##Data Description
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.  

* tBodyAcc-XYZ  
* tGravityAcc-XYZ  
* tBodyAccJerk-XYZ  
* tBodyGyro-XYZ  
* tBodyGyroJerk-XYZ  
* tBodyAccMag  
* tGravityAccMag  
* tBodyAccJerkMag  
* tBodyGyroMag  
* tBodyGyroJerkMag  
* fBodyAcc-XYZ  
* fBodyAccJerk-XYZ  
* fBodyGyro-XYZ  
* fBodyAccMag  
* fBodyAccJerkMag  
* fBodyGyroMag  
* fBodyGyroJerkMag  
  
The set of variables that were estimated from these signals are:  
  
* mean(): Mean value  
* std(): Standard deviation  

Description of abbreviations for measurements:  
1. The first character t or f is a time or frequency based measurement  
2. Body = related to body movement  
3. Gravity = acceleration of gravity  
4. Acc = accelerometer measurement  
5. Gyro = gyroscopic measurements  
6. Jerk = sudden movement acceleration  
7. Mag = magnitude of movement  
  
Measurement units:
* Accelerometer unit = g's
* Gyro unit = rad/sec   
  
  
##DATA TRANSFORMATION PROCESS 
Data tranformation consists of the following steps after prerequsites packages and downloading the raw data set:  
1. Merge the training and the test sets to create one data set  
4. Appropriately labels the data set with descriptive variable names  
3. Uses descriptive activity names to name the activities in the data set  
2. Extracts only the measurements on the mean and standard deviation for each measurement   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject 

### Prerequisite Library
```  
require(RCurl)  
require(dplyr)  
require(plyr)  
```  
  
###Download Raw Data Set  
```  
# Download data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(fileUrl, "./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")  
# Extract dataset  
unzip("./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir = ".")  
```
  
###Determine Relevant Files under extracted zip folder 'UCI HAR Dataset':
1. SUBJECT FILES  
  + test/subject_test.txt  
  + train/subject_train.txt  
2. ACTIVITY FILES  
  + test/X_test.txt  
  + train/X_train.txt  
3. DATA FILES  
  + test/y_test.txt  
  + train/y_train.txt  
4. features.txt - Names of column variables  
5. activity_labels.txt - Activity names  
  
```
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
```
  
### Read Relevant Data Files and Create Data Frames
```
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
```
  
###1. Merges the training and the test sets to create one data set
```
# Build the full dataset  
fulldata<-bind_cols(subjecttables,ytables,xtables)  

# Clean up intermediate tables no longer used  
rm(subjecttables,ytables,xtables)  
```
  
###4. Appropriately labels the data set with descriptive variable names
```
# Relabel column names with subject, activity, and features  
colnames(fulldata)<-c("subject","activity",as.character(features[,2]))  
```

###3. Uses descriptive activity names to name the activities in the data set
```
# Change activity column to a factor with labels  
fulldata[,"activity"]<-factor(fulldata[,"activity"],labels=activities[,2])  
```
  
###2. Extracts only the measurements on the mean and standard deviation for each measurement.
measuresdata<-fulldata[,grep("subject|activity|-mean\\(\\)|-std\\(\\)",colnames(fulldata))]  
  
###5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
measuresonly<- names(subset(measuresdata,select=-c(activity,subject)))  
tidydataframe <- aggregate(measuresdata[,measuresonly], by=measuresdata[c("activity","subject")], FUN=mean)  
  
##DATA DICTIONARY - TIDY DATA  
The tidy data set's first row is the header containing the names for each column.  
The resulting data frame has 180 rows and 68 columns.  
The first column is activity (6 levels: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) and second column is subject (1 of of the 30 test subjects) followed by remaining columns 33 Mean variables and 33 Standard deviation variables. 
  
The set of variables that were estimated from these signals are:  
  
* mean(): Mean value  
* std(): Standard deviation  

Description of abbreviations for measurements:  
1. The first character t or f is a time or frequency based measurement  
2. Body = related to body movement  
3. Gravity = acceleration of gravity  
4. Acc = accelerometer measurement  
5. Gyro = gyroscopic measurements  
6. Jerk = sudden movement acceleration  
7. Mag = magnitude of movement  
  
Measurement units:
* Accelerometer unit = g's
* Gyro unit = rad/sec   
    
```
head(str(tidydataframe,2))  
'data.frame':  180 obs. of  68 variables:  
 $ activity                   : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...  
 $ subject                    : int  1 1 1 1 1 1 2 2 2 2 ...  
 $ tBodyAcc-mean()-X          : num  0.277 0.255 0.289 0.261 0.279 ...  
 $ tBodyAcc-mean()-Y          : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...  
 $ tBodyAcc-mean()-Z          : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...  
 $ tBodyAcc-std()-X           : num  -0.284 -0.355 0.03 -0.977 -0.996 ...  
 $ tBodyAcc-std()-Y           : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...  
 $ tBodyAcc-std()-Z           : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...  
 $ tGravityAcc-mean()-X       : num  0.935 0.893 0.932 0.832 0.943 ...  
 $ tGravityAcc-mean()-Y       : num  -0.282 -0.362 -0.267 0.204 -0.273 ...  
 $ tGravityAcc-mean()-Z       : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...  
 $ tGravityAcc-std()-X        : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...  
 $ tGravityAcc-std()-Y        : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...  
 $ tGravityAcc-std()-Z        : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...  
 $ tBodyAccJerk-mean()-X      : num  0.074 0.1014 0.0542 0.0775 0.0754 ...  
 $ tBodyAccJerk-mean()-Y      : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...  
 $ tBodyAccJerk-mean()-Z      : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...  
 $ tBodyAccJerk-std()-X       : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...  
 $ tBodyAccJerk-std()-Y       : num  0.067 -0.378 -0.102 -0.981 -0.986 ...  
 $ tBodyAccJerk-std()-Z       : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...  
 $ tBodyGyro-mean()-X         : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...  
 $ tBodyGyro-mean()-Y         : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...  
 $ tBodyGyro-mean()-Z         : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...  
 $ tBodyGyro-std()-X          : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...  
 $ tBodyGyro-std()-Y          : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...  
 $ tBodyGyro-std()-Z          : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...  
 $ tBodyGyroJerk-mean()-X     : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...  
 $ tBodyGyroJerk-mean()-Y     : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...  
 $ tBodyGyroJerk-mean()-Z     : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...  
 $ tBodyGyroJerk-std()-X      : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...  
 $ tBodyGyroJerk-std()-Y      : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...  
 $ tBodyGyroJerk-std()-Z      : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...  
 $ tBodyAccMag-mean()         : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...  
 $ tBodyAccMag-std()          : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...  
 $ tGravityAccMag-mean()      : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...  
 $ tGravityAccMag-std()       : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...  
 $ tBodyAccJerkMag-mean()     : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...  
 $ tBodyAccJerkMag-std()      : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...  
 $ tBodyGyroMag-mean()        : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...  
 $ tBodyGyroMag-std()         : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...  
 $ tBodyGyroJerkMag-mean()    : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...  
 $ tBodyGyroJerkMag-std()     : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...  
 $ fBodyAcc-mean()-X          : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...  
 $ fBodyAcc-mean()-Y          : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...  
 $ fBodyAcc-mean()-Z          : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...  
 $ fBodyAcc-std()-X           : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...  
 $ fBodyAcc-std()-Y           : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...  
 $ fBodyAcc-std()-Z           : num  -0.28 0.086 -0.298 -0.934 -0.978 ...  
 $ fBodyAccJerk-mean()-X      : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...  
 $ fBodyAccJerk-mean()-Y      : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...  
 $ fBodyAccJerk-mean()-Z      : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...  
 $ fBodyAccJerk-std()-X       : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...  
 $ fBodyAccJerk-std()-Y       : num  0.107 -0.382 -0.135 -0.983 -0.987 ...  
 $ fBodyAccJerk-std()-Z       : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...  
 $ fBodyGyro-mean()-X         : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...  
 $ fBodyGyro-mean()-Y         : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...  
 $ fBodyGyro-mean()-Z         : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...  
 $ fBodyGyro-std()-X          : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...  
 $ fBodyGyro-std()-Y          : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...  
 $ fBodyGyro-std()-Z          : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...  
 $ fBodyAccMag-mean()         : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...  
 $ fBodyAccMag-std()          : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...  
 $ fBodyBodyAccJerkMag-mean() : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...  
 $ fBodyBodyAccJerkMag-std()  : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...  
 $ fBodyBodyGyroMag-mean()    : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...  
 $ fBodyBodyGyroMag-std()     : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...  
 $ fBodyBodyGyroJerkMag-mean(): num  -0.319 -0.635 -0.282 -0.99 -0.995 ...  
 $ fBodyBodyGyroJerkMag-std() : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...  
```
    
```
### Write tidy data set to a file  
write.table(tidydataframe, "Samsung_Galaxy_Tidy_Data.txt", sep = ",", row.names=FALSE,quote=FALSE)    
```
  
##READING TIDY DATA SET  
The tidy data set is a comma delimited file with a header.  Read the file using the following to load into a data frame:  
```
loaddataset<-read.csv("Samsung_Galaxy_Tidy_Data.txt", sep=",",header = TRUE)
```

  