library(plyr);

###### Part1 -Merges the training and the test sets to create one data set
######Read in Files
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTest <-read.table("UCI HAR Dataset/test/y_test.txt")
YTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
Feature <- read.table("UCI HAR Dataset/features.txt")
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
SubjectTrain<- read.table("UCI HAR Dataset/train/subject_train.txt")

######Label columns
names(XTest)<- Feature$V2
names(XTrain)<- Feature$V2
names(YTest)<- "activityId"
names(YTrain)<- "activityId"
names(SubjectTrain)<- "Subject"
names(SubjectTest)<- "Subject"

######Combine the datasets by columns
train <- cbind(SubjectTrain, YTrain, XTrain)
test <- cbind(SubjectTest, YTest, XTest)

######Combine the datasets by rows
FullData <- rbind(train, test)

###### Part2 -Extracts only the measurements on the mean and standard deviation for each measurement
######Find the names with mean or std
subsetFeature<-Feature$V2[grep("mean\\(\\)|std\\(\\)", Feature$V2)]
subsetVarList<-c("Subject", "activityId",as.character(subsetFeature) )

######Subset the dataset with only mean and std
SubsetData<-subset(FullData,select=subsetVarList)

###### Part3 -Uses descriptive activity names to name the activities in the data set
names(ActivityLabels) <- c("activityId","activity")

finalData = merge(SubsetData,ActivityLabels,by="activityId",all.x=TRUE);

##### Part4 -Appropriately labels the data set with descriptive variable names
names(finalData)<-gsub("^t", "time", names(finalData))
names(finalData)<-gsub("^f", "frequency", names(finalData))
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))

##### Part5 -creates a second, independent tidy data set with the average of each variable for each activity and each subject
finalData  = finalData[,names(finalData) != 'activityId'];
Data2<-aggregate(. ~Subject + activity, finalData, mean)
write.table(Data2, file = "tidydata.txt",row.name=FALSE)