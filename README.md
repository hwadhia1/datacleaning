---
title: "Getting and Cleaning Data Course Project"
author: "Hemal Wadhia"
date: "Friday, February 20, 2015"
---

## Introduction

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  

One of the most exciting areas in all of data science right now is wearable computing.  
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced   algorithms to attract new users.  
The data linked to from the course website represent data collected from the
accelerometers from the Samsung Galaxy S smartphone.  

A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


The following steps are performed in the run_analysis.R script:  
1. Merges the training and the test sets to create one data set  
2. Extracts only the measurements on the mean and standard deviation for each measurement   
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject  


##Files in Repository
1. run_analysis.R --- Retrieves source dataset and processes into a tidy dataset writing a tidy data file named Samsung_Galaxy_Tidy_Data.txt
2. README.md --- description of project
3. CodeBook.md --- describes the variables, the data, and any transformations or work that was performed to clean up the data

##Script Usage
**Run the script run_analysis.R**  
**Note: Internet Access is used to automatically download the dataset**  

**Tidy dataset file Samsung_Galaxy_Tidy_Data.txt is generated**  

  
##Citations
**Original Raw Dataset Source**  
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012  
  
This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.  
  
Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.  
  