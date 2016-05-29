#Module 3 - Week 4 - Assignment - run_analysis.R

setwd("F:/CM-Groep/Cursussen/Data science/03_GettingData/Week4/")

#-------------------
# 1. Merges the training and the test sets to create one data set.
#-------------------

#Read data
X_train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
X_test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_train = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
Y_test = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
subject_train = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
subject_test = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

#append testset to trainingset
X_dataset = rbind(X_train,X_test)
Y_dataset = rbind(Y_train,Y_test)
subject_dataset = rbind(subject_train,subject_test)

#-------------------
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#-------------------

# get variables with mean and standard deviation
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
variablesSelected <- grep("mean()|std()", features[,2])
X_dataset <- X_dataset[, variablesSelected]

# rename the column names to the names in the features file
names(X_dataset) <- features[variablesSelected, 2]

#-------------------
# 3.Uses descriptive activity names to name the activities in the data set
#-------------------

activity_labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Add activity name to Y dataset
Y_dataset$activity_name = activity_labels[Y_dataset[, 1], 2]

#-------------------
# 4.Appropriately labels the data set with descriptive variable names. 
#-------------------

# correct column name
names(subject_dataset) <- "subject"

# merge all data in a single data set
dataset <- cbind(X_dataset, Y_dataset, subject_dataset)

#-------------------
# 5.From the data set in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject.
#-------------------

#install.packages("reshape2")
library(reshape2)
melted_dataset <- melt(dataset, id=c("subject","activity_name"))
tidy_dataset <- dcast(melted, subject+activity_name ~ variable, mean)

# write tidy dataset to txt file
write.csv(tidy_dataset, file = "tidy_dataset.txt",row.names = FALSE)

