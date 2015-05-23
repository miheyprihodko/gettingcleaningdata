library(dplyr)
library(knitr)

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

dataset<-subset(data,select=c(grep("mean()",col_names[,2],fixed=T),grep("std()",col_names[,2],fixed=T),activity_type,subject_type))
dataset<-mutate(dataset,activity_type=activity_labels[activity_type,2])

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

dataset_means <- summarise_each(group_by(dataset, activity_type, subject_type),funs(mean))

write.table(dataset_means,"dataset_means.txt",row.name=FALSE)