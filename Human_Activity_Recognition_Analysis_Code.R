# Download dataset zip file using downloader package
library(downloader)
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./data")

# Read text files using data table package
library(data.table)

setwd(".\\data\\UCI HAR Dataset\\test")
x_test <- fread("./X_test.txt") 
sub_test <- fread("./subject_test.txt")
act_test <- fread("./y_test.txt")

setwd("../")
setwd(".\\train")
x_train <- fread("./X_train.txt") 
sub_train <- fread("./subject_train.txt")
act_train <- fread("./y_train.txt")

setwd("../")
var_names <- fread("./features.txt")
new_variable1 <- data.table(V1 = -1, V2 = "Subject")
new_variable2 <- data.table(V1 = 0, V2 = "Activity")
var_names_new <- rbind(new_variable1, new_variable2, var_names) # column of all measured variables

# Column bind the subject and activity columns to the test dataframe
x_test_new <- cbind(sub_test, act_test, x_test)

# Column bind the subject and activity columns to the training dataframe
x_train_new <- cbind(sub_train, act_train, x_train)

# Merges the training and the test sets to create one data set
data <- rbind(x_train_new, x_test_new )
View(data)

# Appropriately label the data set with descriptive variable names for the 563 variables
# Remove unwanted characters from variable names
data_variables <- var_names_new$V2
data_variables<-sub("-","",data_variables)
data_variables<-sub("()-","",data_variables)

for(i in 1:563) {
        names(data)[i] <- data_variables[i]
}

# Extracts only the measurements on the mean and standard deviation for each measurement
library(dplyr)
data<-tbl_df(data) # have to convert data to dplyr pkg (tbl_df) from data table to use the below command properly.
data_mean_std <- data[,c(colnames(data)[grep("Subject|Activity|mean|std|Mean",colnames(data))])] ## partial string name search using grep

# Use descriptive activity names to name the activities in the data set
for(i in 1:10299) {
        if(data_mean_std$Activity[i] == 1){
                data_mean_std$Activity[i] <- "Walking" 
                }else if(data_mean_std$Activity[i] == 2){
                data_mean_std$Activity[i] <- "WalkingUp"
                }else if(data_mean_std$Activity[i] == 3){
                data_mean_std$Activity[i] <- "WalkingDown"
                }else if(data_mean_std$Activity[i] == 4){
                data_mean_std$Activity[i] <- "Sitting" 
                }else if(data_mean_std$Activity[i] == 5){
                data_mean_std$Activity[i] <- "Standing"          
        }else (data_mean_std$Activity[i] <- "Laying") 
}
        
View(data_mean_std)


# From the data set above, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 

library(reshape2)
a<-names(data_mean_std) # names of all the variables of the data set

#
v<-a[3]
start_data <- dcast(data_mean_std, Subject + Activity ~ ., fun=mean, value.var=c(v))

# create the first two columns (Subject and Activity) for the tidy data set
data_first <- start_data[[1]]
data_first <- data.table(data_first)
names(data_first)[1] <- "Subject"

data_second <- start_data[[2]]
data_second <- data.table(data_second)
names(data_second)[1] <- "Activity"

# column bind the first two columns (Subject and Activity) fof the tidy data set
tidy_data <- cbind(data_first,data_second)

# Create the average for each required variable, per each activity and each subject, 
# and bind all the variable columns together to form the tidy data set.
for(i in 3:88) {
        v<-a[i]
        var_data <- dcast(data_mean_std, Subject + Activity ~ ., fun=mean, value.var=c(v))
        var_data <- var_data[[3]]
        var_data_a <- data.table(var_data)
        names(var_data_a)[1] <- v
        tidy_data <- cbind(tidy_data, var_data_a)
}

# Clean up further the variable names of tidy data set
colnames(tidy_data) <- gsub("\\(\\)", "Axis", colnames(tidy_data))
colnames(tidy_data) <- gsub("mean", "MEANin", colnames(tidy_data)) 
colnames(tidy_data) <- gsub("std", "STDDEVin", colnames(tidy_data)) 
colnames(tidy_data) <- gsub("^f", "FREQ", colnames(tidy_data)) 
colnames(tidy_data) <- gsub("^t", "TIME", colnames(tidy_data)) 

View(tidy_data)

# Write tidy data set into a text file.
setwd("../")
write.table(tidy_data, row.name = FALSE,col.names = TRUE, file = "tidy_data_Average.txt")    
