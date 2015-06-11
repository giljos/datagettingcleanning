# # Load raw data
data_train_X <- read.table("train/X_train.txt")
data_test_X <- read.table("test/X_test.txt")
data_train_Y <- read.table("train/y_train.txt")
data_test_Y <- read.table("test/y_test.txt")
features <- read.table('features.txt')
activities <- read.table("activity_labels.txt")

# Merge raw data
data_merge_X <- rbind(data_train_X, data_test_X)
data_merge_Y <- rbind(data_train_Y, data_test_Y)


# Extracts measurements  mean and std
indice_matches <- grep("(mean|std)\\(\\)" ,features[,2])
data_meanstd_X <- data_merge_X[,indice_matches ]

# Label columns
# create colone names with more descriptive names
names_col <- read.table('features.txt')[,2]
names_col <- names_col[indice_matches] # select relevant names
names_col <- gsub("^t", "Time", names_col)
names_col  <- gsub("^f", "Frequency", names_col)
names_col  <- gsub("-mean\\(\\)", "Mean", names_col)
names_col  <- gsub("-std\\(\\)", "Std", names_col)
names_col  <- gsub("-", "", names_col)
# activities Label
names_col <- c("activities", names_col )



# descriptive activity names
activities_vect <- activities[,2]
data_merge_Y$act_label <- activities_vect[data_merge_Y[,1]]
data_merge <- cbind(data_merge_Y[,2], data_meanstd_X)

# Label columns
names(data_merge) <- names_col

# add subject data from training and test data : tidy data set
subjects <- rbind(read.table("train/subject_train.txt"), read.table("test/subject_test.txt"))
data_tidy <- cbind(subjects, data_merge )
names(data_tidy)[1] <- 'subjects'

# Creates independent data set with the average of each variable for each activity and each subject.

library(plyr)

mean_tidy <- ddply(data_tidy, c("subjects","activities"), numcolwise(mean))
write.table(mean_tidy, "mean_tidy.txt",row.names=FALSE)