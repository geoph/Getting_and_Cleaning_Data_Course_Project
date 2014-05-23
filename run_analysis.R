setwd("C:/Users/Philippis/Downloads/3. Getting and Cleaning Data/Project/UCI HAR Dataset")

# read data into data frames
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurement files
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
data <- rbind(train, test)

# determine which columns contain "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(data)) | grepl("std\\(\\)", names(data))

# keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# remove the unnecessary columns
combined <- data[, meanstdcols]
 
# convert the activity column from integer to factor
data$activity <- factor(data$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# load the reshape2 library 
library(reshape2)

# create the tidy data set & write to a file
temp <- melt(data, id=c("subjectID","activity"))
tidy <- dcast(temp, subjectID+activity ~ variable, mean)

write.csv(tidy, "tidy_data.txt", row.names=FALSE)
