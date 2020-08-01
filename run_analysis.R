# Start by downloading the zipped files from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Manually unzip the files into the current R directory, which in my case is "Cleaning_Data_Project".
# Use read.table to upload the training data into R
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
# Use read.table to upload the test data into R
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
# Combine all training data sets to form a single training data frame.
train <- data.frame(train_subject, train_y, train_x)
# Combine all ttest data sets to form a single test data frame.
test <- data.frame(test_subject, test_y, test_x)
# use rbind to combine the two dataframes into a single dataframe.
train_test <- rbind(train, test)
# load features object for use in variable names
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
# convert features from dataframe to a character vector
features <- as.character(features$V2)
# Use features object to append variable names to merged data frame.
names(train_test) <- c(c("subject", "activity"), features)
# Subset data based on column names that contain the expressions "mean" and "std".
mean_sd <- train_test[, which(colnames(train_test) %in% c("subject", "activity", grep("mean()|std()", colnames(train_test), value = TRUE)))]
# Load activity labels into the work space.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
# convert the object to a character vector.
activity_labels <- as.character(activity_labels$V2)
# Use activity labels to append activity names to the activity variable in the dataset.
mean_sd$activity <- activity_labels[mean_sd$activity]
# Replace Prefix "f" by frequency
names(mean_sd)[-c(1:2)] <- gsub("^f", "frequency", names(mean_sd)[-c(1:2)])
# Replace prefix "t" by time
names(mean_sd)[-c(1:2)] <- gsub("^t", "time", names(mean_sd)[-c(1:2)])
# Replace "ACC" by Accelerometer
names(mean_sd)[-c(1:2)] <- gsub("Acc", "Accelerometer", names(mean_sd)[-c(1:2)])
# Replace "BodyBody" by Body
names(mean_sd)[-c(1:2)] <- gsub("BodyBody", "Body", names(mean_sd)[-c(1:2)])
# Replace "Gyro" by Gyroscope
names(mean_sd)[-c(1:2)] <- gsub("Gyro", "Gyroscope", names(mean_sd)[-c(1:2)])
# Replace "Mag" by Magnitude
names(mean_sd)[-c(1:2)] <- gsub("Mag", "Magnitude", names(mean_sd)[-c(1:2)])
# Replace "Jerk" by Acceleration
names(mean_sd)[-c(1:2)] <- gsub("Jerk", "Acceleration", names(mean_sd)[-c(1:2)])
# Use the aggregate function to colate means of variables by subject and activity
tidy_final <- aggregate(. ~ subject + activity, mean_sd, mean)
# Order final dataset by subject and activity
tidy_final <- tidy_final[order(tidy_final$subject, tidy_final$activity),]
# Save data frame to working directory
save(tidy_final, file = "Tidy_Data.rdata")
# use write.table() to print the final data into a text file
write.table(tidy_final, file = "Tidy_Data.txt", row.names = FALSE)