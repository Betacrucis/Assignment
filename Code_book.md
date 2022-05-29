# Assignment

This is the assessment for the Coursera course Getting and Cleaning Data.

The file with the code to complete the tasks is called run_analysis.R

The merged data is put into a new folder called "merged" under "UCI HAR Dataset"

The steps are described in the file with comments.

The Data Book is from the dataset itself - features_info.txt and the original readme.txt

The script completes the following tasks

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The result is saved in the file "tidy_data.txt"

As the data is in a tidy format, each line of the output table container one mean value for each subject, for each activity and each of the 79 variables that contains "mean" or "std" in the column name.

