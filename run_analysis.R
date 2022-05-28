# Assignment for Getting and Cleaning Data

library(dplyr)

# obtain data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "data2.zip"  # remote filename is "getdata_projectfiles_UCI HAR Dataset.zip"
download.file(url, zipfile, mode="wb")

# unzip the data
wd <- getwd()
unzip(paste(wd,zipfile, sep="/"))


# Part 1
# Merges the training and the test sets to create one data set.

## Merge datasets into a new folder called "merged"

# start by setting up a new folder "merged"
setwd("./UCI HAR Dataset")
if (!dir.exists("merged")) {
        dir.create("merged")
        dir.create("./merged/Inertial Signals")
}

# merge the training data with the text data into the new folder
for (f in list.files(path="./test/", recursive = TRUE)) {
        xfolder <- "./test/"
        yfolder <- "./train/"
        mfolder <- "./merged/"
        xfile <- f
        yfile <- paste(substr(f, 1, nchar(f)-8), "train.txt", sep="")
        x_data <- read.table(paste(xfolder, xfile, sep="/"), sep="", header=FALSE)
        y_data <- read.table(paste(yfolder, yfile, sep="/"), sep="", header=FALSE)
        merged_data <- rbind(x_data, y_data)
        merged_filename <- paste(substr(f, 1, nchar(f)-8), "merged.txt", sep="")
        file.create(paste(mfolder,merged_filename, sep=""))
        write.table(merged_data, paste(mfolder,merged_filename, sep=""), col.names = FALSE, row.names = FALSE)
        print(merged_filename)
}



# load all data into memory
for (f in list.files(path="./merged/", recursive = TRUE)) {
  data <- read.table(paste("./merged/", f, sep=""), sep="", header=FALSE )
  tablename <-  substr(f, 1, nchar(f)-4)
  assign(tablename, data)
}


# Summary of data
# X_merged - contains all the data of 561 variable for every sample (1-6)
# Y_merged - contains the type of activity that was performed (10299 samples, 561 columns)
# Subject_merged - contains the ID for each participant (1-30)

# need to add the X_merged and Subject_merged columns to X-Merged to combine the data


# Part 4.
# Assign column names to X_merged - column names in features.txt
# completed before removing columns
features <- read.table("features.txt", header = FALSE)
colnames(X_merged) <- features[,2]

# Part 2
# Extracts only the measurements on the mean and standard deviation for each measurement. 

# Column names for the means
mean_colnumbers <- grep("mean", features[,2])
std_colnumbers <- grep("std", features[,2])
colnums <- sort(c(mean_colnumbers, std_colnumbers))

X_clean <- X_merged[,colnums]

# add subjects to dataframe
X_merged_colnames <- cbind( X_clean, subject_merged)
colnames(X_merged_colnames)[length(X_merged_colnames)] <- "subject"


# Step 3
# Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt", header=FALSE)
activity_names  <- inner_join(y_merged, activity_labels, by=c("V1"="V1"))
colnames(activity_names) <- c("V1","Activity_Name" )
added_Activity_name <- cbind(X_merged_colnames, activity_names$Activity_Name )
colnames(added_Activity_name)[length(added_Activity_name)] <- "Activity_Name"

# Step 5
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data <- added_Activity_name

# get the mean of all the variables for each subject for each activity
summary_data <- aggregate(data[,1:79], data[,80:81], FUN=mean)

tidy_data <- data.frame()
for (y in colnames(summary_data)[3:81]) {
        for (x in seq(1:180)) {
                new_line <- c( summary_data[x, 1], summary_data[x, 2], y, summary_data[x,y] )
                tidy_data <- rbind(tidy_data, new_line)
        }
}

# tidy up the data with column names and data types
colnames(tidy_data) <- c("Subject", "Activity","Variable", "Mean" )
tidy_data$Subject <- as.numeric(tidy_data$Subject)
tidy_data$Mean <- as.numeric(tidy_data$Mean)
                                
# save data as a text file
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)

# completed all tasks
