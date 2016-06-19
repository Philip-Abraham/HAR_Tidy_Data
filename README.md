## Getting and Cleaning Human Activity Recognition Data Obtained from Accelerometers in Smartphones    


### Introduction

Raw data captured from inertial measurement sensors worn on a user’s body or built in a user’s smartphone to track his or her motion.  

Data was collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here is the web link to the accelerometer data set:

[link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)  

The purpose of this R program is to collect, transorm, and clean a raw data set obtained from the smartphones. The end goal is to prepare a tidy data set with the average of each variable for each activity and each subject.  

### R-Program Summary - Human Activity Recognition.R  

The dataset zip file  was downloaded using the R downloader package from the given website:
[link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 

The files were then read into R objects using the data table package. 

Since the Subject and Activity information was provided in separate text files, the Column bind operation was used to bind the subject and activity columns to the test and training data tables. The training and the test sets were then merged together to create one data set.  

The data set was appropriately labeled with descriptive variable names for the 563 variables. And, all unwanted characters were removed from the variable names.  

The next step required extracting from the dataset only the given variables with the mean and standard deviation for each measurement. This reduced the number of variables to 86.   

From the data set above, a second, independent tidy dataset was created with the average of each of the 86  variables for each activity and each subject. The reshape package was utilized for this. Further clean-up of the tidy dataset variable names was performed to enhance readability of the variables.    

Finally, the tidy data set was writen into a text file (tidy_data_Average.txt) using write.table command in R. 

### Reading the tidy_data_Average.txt file  
The command for reading the _tidy_data_Average.txt_ in and looking at it in R would be:  

data <- read.table(file_path, header = TRUE)
View(data)

This read text file code was obtained from: [link](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

 
  

