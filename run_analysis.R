## Download files in the data folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Getting the list of the files from the unzipped files in the folder
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

## To view the files content
## files

## Read the Activity files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

## Read the Subject files
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

## Read the Features files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## Observing the properties of the above variables
## str(dataActivityTest)

## str(dataActivityTrain)

## str(dataSubjectTrain)

## str(dataSubjectTest)

## str(dataFeaturesTest)

## str(dataFeaturesTrain)

## Now merge the training and the test sets to create one single data set
## Concatenating the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## Setting the names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## Merging columns to get the data frame for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## Now we extract only the measurements on the mean and standard deviation for each measurement
## Subset name of features by measurements on the mean and standard deviation
## Take Names of Features with mean() or std()

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## Subset the data frame by selected names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

## Check the structures of the data frame

## str(Data)


## Now we use descriptive activity names to name the activities in the data set
## Reading descriptive activity names from ???activity_labels.txt???

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## Now factorize variable activity in the data frame data using descriptive activity names and check
Data$activity<-factor(Data$activity);
Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))

## View the contents of the Activity variable

## head(Data$activity,30)

## Now appropriately label the data set with descriptive variable names. 
## Earlier, variables activity and subject and names of the activities have been labelled using descriptive names.
## Now, we will label names of Features using descriptive variable names.
## prefix t is replaced by time
## Acc is replaced by Accelerometer
## Gyro is replaced by Gyroscope
## prefix f is replaced by frequency
## Mag is replaced by Magnitude
## BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Now checking the data frame Data

## names(Data)

## Now we create a tidy data set and output it
## This will be done with average of each variable for each activity and 
## each subject based on the data set in earlier step.

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
