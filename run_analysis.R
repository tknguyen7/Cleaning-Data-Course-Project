#Script: run_analysis.R
#T.K. Nguyen
#Date: February 22, 2015
#This project was completed for the Coursera Class: Getting and Cleaning data.

#Data downloaded on February 17, 2015
#This file creates a tidy data set from the UCI HAR Dataset files. It merges the training and the test sets to create one data set, extracts only the measurements on the mean and standard deviation for each measurement, uses descriptive activity names to name the activities in the data set, appropriately labels the data set with descriptive variable names, and creates an independent tidy data set with the average of each variable for each activity and each subject.

## Set working directory 
setwd("~/Dropbox/coursera/Getting and Cleaning Data/UCI HAR Dataset/")

# read in test set
x_test <- read.table("test/X_test.txt", quote="\"")
y_test <- read.table("test/y_test.txt", quote="\"",col.names="activity.num")
subject_test <- read.table("test/subject_test.txt",quote="\"",col.names="subject")

# read in train set
x_train <- read.table("train/X_train.txt", quote="\"")
y_train <- read.table("train/y_train.txt", quote="\"",col.names="activity.num")
subject_train <- read.table("train/subject_train.txt",quote="\"",col.names="subject")

#Combine the subjects and activities and activity labels
x_info = rbind(x_test,x_train)
y_info = rbind(y_test,y_train)
subject_info = rbind(subject_test,subject_train)

combined = cbind(subject_info, y_info,x_info)

#Create new column describing what the activity column (y_info) means
combined$activity=NA
combined$activity[combined$activity.num==1]="WALKING"
combined$activity[combined$activity.num==2]="WALKING_UPSTAIRS"
combined$activity[combined$activity.num==3]="WALKING_DOWNSTAIRS"
combined$activity[combined$activity.num==4]="SITTING"
combined$activity[combined$activity.num==5]="STANDING"
combined$activity[combined$activity.num==6]="LAYING"

# read in features name
features <- read.table("features.txt", quote="\"")
features$FeatureLabel=gsub("[(),-]","",features$V2) #makes labels more readable

#change column columns of combined dataset from V_3, i.e., to appropriate label in features.txt
colnames(combined)[3:563]=as.character(features$FeatureLabel)

#extracts only mean or stdv column
k=which(grepl("[Mm]ean\\(\\)|std\\(\\)",features$V2)) #searches for these phrases
combined_meanstdv = combined[,(c(564,1,k+2))] #extracts columns with phrases

#summarize data to get mean for each activity and subject combo for each column
require(plyr)
data.means <- ddply(combined_meanstdv, c("activity", "subject"), function(x) colMeans(x[colnames(combined_meanstdv[3:68])]))


#Write out final tidy data set
write.table(data.means,"tidydata.txt", row.name=FALSE)  
