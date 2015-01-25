###############################################################################
## OPERATING ENVIRONMENT  :Windows XP SP3
## DEVELOPMENT ENVIRONMENT:R version 3.1.2
## AUTHOR:ap0306723
###############################################################################
## Description:
##  create one R script called run_analysis.R that does the following.
##
##  1.Merges the training and the test sets to create one data set.
##  2.Extracts only the measurements on the mean and standard deviation for each measurement.
##  3.Uses descriptive activity names to name the activities in the data set
##  4.Appropriately labels the data set with descriptive variable names.
##  5.From the data set in step 4, creates a second, independent tidy data set with the average
##    of each variable for each activity and each subject.
###############################################################################


## STEP 0: Load the necessary packages
library(dplyr)


## STEP 1: Read "subject_test.txt, X_test.txt, y_test.txt, subject_train.txt, X_train.txt, y_train.txt,features.txt, activity_labels.txt" into tables
SUBJECT_TEST    <- read.table("./UCI HAR Dataset/test/subject_test.txt")             ##2947 rows, 1   columns
X_TEST          <- read.table("./UCI HAR Dataset/test/X_test.txt")                   ##2947 rows, 561 columns
Y_TEST          <- read.table("./UCI HAR Dataset/test/y_test.txt")                   ##2947 rows, 1   columns
SUBJECT_TRAIN   <- read.table("./UCI HAR Dataset/train/subject_train.txt")           ##7352 rows, 1   columns
X_TRAIN         <- read.table("./UCI HAR Dataset/train/X_train.txt")                 ##7352 rows, 561 columns
Y_TRAIN         <- read.table("./UCI HAR Dataset/train/y_train.txt")                 ##7352 rows, 1   columns
FEATURES        <- read.table("./UCI HAR Dataset/features.txt")                      ##561  rows, 2   columns
ACTIVITY_LABELS <- read.table("./UCI HAR Dataset/activity_labels.txt")               ##6    rows, 2   columns


## STEP 2: Merge Y_TEST and SUBJECT_TEST into MY_SUBJECT_TEST, and name the new coluns "Activity","Subject".
MY_SUBJECT_TEST <- cbind(Y_TEST,SUBJECT_TEST)                   ##2947 rows, 2   columns
names(MY_SUBJECT_TEST) <- c("Activity", "Subject")


## STEP 3: Merge Y_TRAIN and SUBJECT_TRAIN into MY_SUBJECT_TRAIN, and name the new coluns "Activity","Subject".
MY_SUBJECT_TRAIN <- cbind(Y_TRAIN,SUBJECT_TRAIN)                ##7352 rows, 2   columns
names(MY_SUBJECT_TRAIN) <- c("Activity", "Subject")


## STEP 4: Merge MY_SUBJECT_TEST and MY_SUBJECT_TRAIN, and name the new coluns "Activity","Subject".
ACT_SUBJECT <- rbind(MY_SUBJECT_TEST,MY_SUBJECT_TRAIN)          ##10299 rows, 2   columns
names(ACT_SUBJECT) <- c("Activity", "Subject")


## STEP 5: Merge X_TEST and X_TRAIN into DATA
DATA <- rbind(X_TEST,X_TRAIN)                                   ##10299 rows, 561 columns


## STEP 6: Use FEATURES names the columns of DATA
names(DATA) <- FEATURES[,2]


## STEP 7: filter the columns contains "mean()" or "dtd()"
DATA <- DATA[,grep("*mean[^Freq]()*|*std()*",names(DATA))]


## STEP 8: Merge DATA and ACT_SUBJECT, generate the tidy data.
FINAL_DATA <- cbind(DATA,ACT_SUBJECT)                          ##10299 rows, 68  columns



## STEP 9: Appropriately labels the data set with descriptive variable names
names(ACTIVITY_LABELS) <- c("Activity","ActivityName")
FINAL_DATA_A <- merge(FINAL_DATA,ACTIVITY_LABELS,x.by="Activity",y.by="Activity")


## STEP 10: Take mean of observations per activity per subject
FINAL_DATA_MEAN <-summarise_each(group_by(FINAL_DATA_A,Subject,Activity,ActivityName),funs(mean))


## STEP 11: use write.table to get a text file from FINAL_DATA_MEAN
write.table(FINAL_DATA_MEAN,file="./TIDY_DATA(MEAN).txt",row.name=F)


## STEP 12: clean the environment
##rm(list=ls())


