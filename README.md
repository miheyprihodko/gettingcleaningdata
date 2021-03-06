Getting and Cleaning Data. Course project "Samsung Galaxy S Dataset_Means"
==========================================================================

In this README file we will explain all transformations of the input data-source ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") that let us receive the target dataset.

### 0. Preparation

Firstly, we should download required libraries and set general options for ouputs in this file.


```r
library(dplyr)
library(knitr)
opts_chunk$set(echo=TRUE,results="hide")
```

### 1. Merging two data sets

Secondly, we should load two input data sets from three files each: values, activities and subjects.  


```r
col_names<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=F)
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)

data_train<-read.table("UCI HAR Dataset/train/X_train.txt")
activity_type_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_type_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
data_train<-data.frame(data_train,activity_type=activity_type_train,subject_type=subject_type_train)
colnames(data_train)<-c(col_names[,2],"activity_type","subject_type")
rownames(data_train)<-paste("train",rownames(data_train))

data_test<-read.table("UCI HAR Dataset/test/X_test.txt")
activity_type_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_type_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
data_test<-data.frame(data_test,activity_type=activity_type_test,subject_type=subject_type_test)
colnames(data_test)<-c(col_names[,2],"activity_type","subject_type")
rownames(data_test)<-paste("test",rownames(data_test))

data<-rbind(data_test,data_train)
```

### 2. Extracting the measurements on the mean and standard deviation for each measurement

At this step we extract all columns from the combined data that contain "mean" or "std" in their names. The only exception - columns for weighted average of the frequency components to obtain a mean frequency (with "meanFreq" in names), because these columns present calculations on mean of easurements.


```r
dataset<-subset(data,select=c(grep("mean()",col_names[,2],fixed=T),grep("std()",col_names[,2],fixed=T),activity_type,subject_type))
```

### 3. Uses descriptive activity names to name the activities in the data set

As we have already downloaded activity labels from the separate file, now we will replace activity type by them.


```r
dataset<-mutate(dataset,activity_type=activity_labels[activity_type,2])
```

### 4. Appropriately labels the data set with descriptive variable names

As criterias of appropriateness for lables we can use the following:

- No abbreviations

- No capital letters 

- Names should be self-explanatory


```r
labels<-colnames(dataset)
labels<-sub("mean()","meanvalue",labels,fixed=T)
labels<-sub("tBodyAcc","timedomain_bodyaccelerometer",labels,fixed=T)
labels<-sub("fBodyAcc","frequencedomain_bodyaccelerometer",labels,fixed=T)
labels<-sub("tGravityAcc","timedomain_gravityaccelerometer",labels,fixed=T)
labels<-sub("fGravityAcc","frequencydomain_gravityaccelerometer",labels,fixed=T)
labels<-sub("tBodyGyro","timedomain_bodygyroscope",labels,fixed=T)
labels<-sub("fBodyGyro","frequencydomain_bodygyroscope",labels,fixed=T)
labels<-sub("tGravityGyro","timedomain_gravitygyroscope",labels,fixed=T)
labels<-sub("fGravityGyro","frequencydomain_gravitygyroscope",labels,fixed=T)
labels<-sub("fBodyBodyAcc","frequencydomain_bodybodyaccelerometer",labels,fixed=T)                 
labels<-sub("fBodyBodyGyro","frequencydomain_bodybodygyroscope",labels,fixed=T)                    
labels<-sub("Mag","_magnitude",labels,fixed=T)
labels<-sub("Jerk","_jerk",labels,fixed=T)
labels<-sub("std()","standartdeviation",labels,fixed=T)
labels<-sub("X","x",labels,fixed=T)
labels<-sub("Y","y",labels,fixed=T)
labels<-sub("Z","z",labels,fixed=T)
colnames(dataset)<-labels
```

### 5. Independent tidy data set with the average of each variable for each activity and each subject

As a last transformation, we will group by our dataset and calculate means of measurements for each pair of activity and subject.


```r
dataset_means <- summarise_each(group_by(dataset, activity_type, subject_type),funs(mean))
```

### 6. Write output into a text file

Finally, we write output into a file.


```r
write.table(dataset_means,"dataset_means.txt",row.name=FALSE)
```
