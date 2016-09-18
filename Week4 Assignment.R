
## Set direct on where the data is located##
setwd("C:\\Users\\wx5157\\Desktop\\Data Science Training\\Coursera\\Course 3 Reading & Cleaning Data\\Week 4\\UCI HAR Dataset")

## Load all dataset into R
train_data = read.table("train/X_train.txt",header=F)
train_label = read.table("train/y_train.txt",header=F)
train_subject = read.table("train/subject_train.txt",header=F)

Activity_label = read.table("activity_labels.txt",header=F)
features = read.table("features.txt", header=F)

test_data = read.table("test/X_test.txt",header=F)
test_label = read.table("test/y_test.txt",header=F)
test_subject = read.table("test/subject_test.txt",header=F)

## Step 1 - R-bind the train and test data set

Total_data = rbind(train_data,test_data)
total_label = rbind(train_label,test_label)
total_subject = rbind(train_subject,test_subject)

## Step 2 - Import column names from features data set

colnames(Total_data) = features$V2

## Step 3 - Merge the activity label with the Total_Label dataset

total_label$orderV = 1:nrow(total_label)
total_label_merged = merge(total_label,Activity_label, by.x="V1", by.y="V1")
total_label_merged_order=total_label_merged[order(total_label_merged$orderV),]

## Step 4 - C-bind the data with the subject and labels

names(total_label_merged_order) = c("Activity_Code", "Order_Variable", "Activity")
names(total_subject) = c("subject_name")
final_data = cbind(total_subject,total_label_merged_order,Total_data)

## Step 5 - select only variables that contains either mean() or std()

final_data_short = final_data[,grep("mean()|std()",names(final_data))]
final_data_tidy = cbind(total_subject,total_label_merged_order,final_data_short)

## step 6 - create the data set of averages by subject & activity and write the file to the working directory

output=aggregate(final_data_tidy[,5:83], by=list(final_data_tidy$subject_name, final_data_tidy$Activity), FUN="mean")
colnames(output)[3:81] = paste("Mean of", colnames(output[,3:81]), sep="_")
colnames(output)[1] = "subject"
colnames(output)[2] = "activity"

write.table(output, file="Peer Graded Assignment on Cleaning Data.txt", row.names=F)
