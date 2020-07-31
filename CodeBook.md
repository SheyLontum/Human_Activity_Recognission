---
title       : Code Book for the Human Activity Recognition Using Smartphones Dataset
subtitle    : A re-adaptation for the "Getting and Cleaning Data" Course on Coursera
author      : Lontum E. Nchadze 
job         : Cameroon Ministry of Finance 
---

## Original Data for this project

The original data for this project was adapted from the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The version used for this project, together with accompanying documentation can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

This data documents the results of experiments that were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) all while wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the investigators  captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was then randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' in the zipped data foulder for more details. 

For each record the folowing were provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

---

## Project Discription

You should create one R script called run_analysis.R that does the following.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---

## Merging the training and the test sets to create one data set.

This is accomplished in the folowing steps (code folows):

* First, download the zipped foulder from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzip it into your working directory. This will be a sub directory in the working directory called "UCI HAR Dataset". This will consist of a number of files, including two further sub directories called "train" and "test".

* Next, use read.table() to upload the training data, its activities and its subject identifiers from the "train" directory of the "UCI HAR Dataset" sub directory.

* Also, use read.table() to upload the test data, its activities and its subject identifiers from the "test" directory of the "UCI HAR Dataset" sub directory.

* Use data.frame() to combine all train objects into a training data set and all test objects into a single test data set.

* Then, use rbind() to combine the training and test data sets into a single data frame.

* Finally, load the features object, convert it into a character vector and use names() to append names to the joint data frame.

```r
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train <- data.frame(train_subject, train_y, train_x)
test <- data.frame(test_subject, test_y, test_x)
train_test <- rbind(train, test)
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
features <- as.character(features$V2)
names(train_test) <- c(c("subject", "activity"), features)
```

---

## Extract only the measurements on the mean and standard deviation for each measurement.

This is accomplished by subsetting the data based on column names that contain the expressions "mean" and "std".

```r
mean_sd <- train_test[, which(colnames(train_test) %in% c("subject", "activity", grep("mean()|std()", colnames(train_test), value = TRUE)))]
```

---

## Use descriptive activity names to name the activities in the data set

This is accomplished in three steps (code folows):

* First, the activity_labels object is loaded into the workspace

* Then, the object is converted into a character vector

* Finally, the values in the vector are appended to the labels of the activity variable in the data frame.

```r
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
activity_labels <- as.character(activity_labels$V2)
mean_sd$activity <- activity_labels[mean_sd$activity]
```

---

## Appropriately label the data set with descriptive variable names.

This is accomplished by replacing the folowing regular expressions in the variable names with more meaningful expressions (code follows):

* Prefix "f" by "frequency"
* prefix "t" by "time"
* "ACC" by "Accelerometer"
* "BodyBody" by "Body"
* "Gyro" by "Gyroscope"
* "Mag" by "Magnitude"
* "Jerk" by "Acceleration"

```r
names(mean_sd)[-c(1:2)] <- gsub("^f", "frequency", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("^t", "time", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("Acc", "Accelerometer", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("BodyBody", "Body", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("Gyro", "Gyroscope", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("Mag", "Magnitude", names(mean_sd)[-c(1:2)])
names(mean_sd)[-c(1:2)] <- gsub("Jerk", "Acceleration", names(mean_sd)[-c(1:2)])
```

---

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.

This is accomplished in three steps:

* The aggregate() function is used to colate means of variables by subject and activity

* The data set is then ordered, first by subject and then by activity.

* Finally, the tidy data frame is saved into the working directory.

```r
tidy_final <- aggregate(. ~ subject + activity, mean_sd, mean)
tidy_final <- tidy_final[order(tidy_final$subject, tidy_final$activity),]
save(tidy_final, file = "Tidy_Data.rdata")
```

---

## Discription of Final Data Set

The final set is made up of 180 rows and 81 columns. It contains data for the 30 subjects that made up both the training and test subjects in the original raw data. For each subject, the average of means and standard diviations are computed for each of six states (activity): WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING. The remaining 79 columns show the average for each subject in each state for each of the mean and std variables in the original data set, for the entire duration of the experiment.

## Refferences
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
