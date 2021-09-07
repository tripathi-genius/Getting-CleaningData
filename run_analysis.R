library(reshape2)


# train data
x_train <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/train/subject_train.txt")

# test data
x_test <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/test/subject_test.txt")

# Merging available data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

# feature info
feature <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/features.txt")

# activity labels
a_label <- read.table("~/Desktop/RWorkingDirectory/CapProject/UCI HAR Dataset/activity_labels.txt")
a_label[,2] <- as.character(a_label[,2])

# extract feature cols & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


#4. extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


#5. generate tidy data set
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)





