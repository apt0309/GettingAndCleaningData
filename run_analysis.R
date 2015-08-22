setwd("~/Coursera/GettingAndCleaningData/UCI HAR Dataset")

## Read activities, assign labels to columns
activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

## Read features columns
features <- read.table("features.txt")
feature_names <-  features[,2]

## Read test data, assign labels to columns
testdata <- read.table("./test/X_test.txt")
colnames(testdata) <- feature_names

## Read training data, assign labels to columns
training <- read.table("./train/X_train.txt")
colnames(training) <- feature_names

## Read the ids of the test subjects, assign labels to columns
test_subject_id <- read.table("./test/subject_test.txt")
colnames(test_subject_id) <- "subject_id"

## Read the ids of the training subjects and assign label to columns
train_subject_id <- read.table("./train/subject_train.txt")
colnames(train_subject_id) <- "subject_id"

## Read the activity id's of the training data, assign labels to colums
train_activity_id <- read.table("./train/y_train.txt")
colnames(train_activity_id) <- "activity_id"

##Combine the test subject id's, activity id's and data 
test_data <- cbind(test_subject_id , test_activity_id , testdata)

##Combine the train subject id's, activity id's and data
training <- cbind(train_subject_id , train_activity_id , training)

##Combine the test data and the training data
all_data <- rbind(train_data,test_data)

##Keep only columns refering to mean() or std() values
mean_col_ids <- grep("mean",names(all_data),ignore.case=TRUE)
mean_col_names <- names(all_data)[mean_col_ids]
std_col_ids <- grep("std",names(all_data),ignore.case=TRUE)
std_col_names <- names(all_data)[std_col_ids]
meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]

##Merge the activities datase with the mean/std values datase to get descriptive activity names
descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)

##Melt the dataset with the descriptive activity names
data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))

##Cast the melted dataset per activity and subject, according to  the average of each variable
mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)

## create the tidy dataset
write.table(mean_data,"./my_tidy_data.txt", row.names = FALSE)
