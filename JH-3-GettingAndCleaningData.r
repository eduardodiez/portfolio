# Let's state our root working directory where scripts and datasets are
#
curdir <- getwd()
workingdirectory = "D:/Cursos/Hopkin/3-Cleaning Data/Peer Project/"
setwd(workingdirectory)
#
# We read the file 'feature.txt' to get the 561 variables' names that correspond
# to each variable at both 'X_???.txt' files (test and train).
# The so obtained table have two columns; 
# the first with sequential integers from 1 to 561 and the second the variables names  
#
DescriptiveVariableNames <- read.table("./Data/features.txt", quote="\"")
#
# we assing to both columns a more convenient and descriptive names
#
names(DescriptiveVariableNames) <- c("Vsequential","Variables561")
#
# We keep all 561 variables in a char variable called 'mynames'
#
mynames<-as.character(DescriptiveVariableNames$Variables561)
#
# Now, we extract the columns position --number-- that correspond with 
# the measurements on the mean and standard deviation of measurements only 
# and we save them in 'ColMean' and 'ColStd' and 'ColTotal'
#
ColMean<-grep("mean", mynames, ignore.case = TRUE)
ColStd<-grep("std", mynames, ignore.case = TRUE)
#
# We add to ColTotal the three first columns that are going to be myID, myOrgFile, volunter, activity
#
ColTotal<-append(c(1,2,3,4), sort(append(ColMean,ColStd))+4)
ColFinal<-append(c(2,3,4), sort(append(ColMean,ColStd))+4)
#
# Now, we open each set of data file, three for 'test' and another three for 'train'  
# and we add the same variable 'myID' to each set (X_???.txt; subject_???.txt and y_???.txt).
# 'myID' will be filled with a sequentia from 1 to length of each datafile and we are going
# to use it to help us to join the data, in such a way that every dataset have 
# the subjects (numbers from 1 to 30 that correspond toeach 30 volunteers) and 
# the activity (from 1 to 6). 
# In our case the amount of rows of all of them is 2947 rows
# 
X_test <- read.table("./Data/test/X_test.txt", quote="\"")
#
# we change the columns names of X_???.txt for our descriptive ones
#
names(X_test) <- mynames
#
subject_test <- read.table("./Data/test/subject_test.txt", quote="\"")
y_test <- read.table("./Data/test/y_test.txt", quote="\"")
#
dim(subject_test)->tama
#
subject_test["myID"] <- c(1:tama[1])
#
X_test["myID"] <- c(1:tama[1])
#
y_test["myID"] <- c(1:tama[1])
#
tmp<-merge(subject_test, y_test, by="myID", all=TRUE)
names(tmp) <- c("myID", "volunter","activity")
tmp["OriginalFile"] <- as.factor("test")
my_test<-merge(tmp, X_test, by="myID", all=TRUE)
#
# Finally we take out the columns we don't need, including the three we added above
#my_test<-my_test[ , ColTotal]
#
my_test<-my_test[ , ColFinal]
#
# We repeate the same last procedure for the 'train' files
#
X_train <- read.table("./Data/train/X_train.txt", quote="\"")
names(X_train) <- mynames
subject_train <- read.table("./Data/train/subject_train.txt", quote="\"")
y_train <- read.table("./Data/train/y_train.txt", quote="\"")
dim(subject_train)->tama
subject_train["myID"] <- c(1:tama[1])
X_train["myID"] <- c(1:tama[1])
y_train["myID"] <- c(1:tama[1])
tmp<-merge(subject_train, y_train, by="myID", all=TRUE)
names(tmp) <- c("myID", "volunter", "activity")
tmp["OriginalFile"] <- as.factor("trainig")
my_train<-merge(tmp, X_train, by="myID", all=TRUE)
#
my_train<-my_train[, ColFinal]
#
# Now, we need join both datasets
#
my_data <- rbind(my_test, my_train)
#
# And, we write down descriptive activity names to name the activities in the dataset
#
my_data[, "activity"] <- as.factor(my_data[, "activity"])
activity_labels <- read.table("./Data/activity_labels.txt", quote="\"")
activities<-activity_labels$V2
levels(my_data$activity)<-activities
# 
#
# The first submission dataset file should be as 'my_data' but withouth the first three columns;
# with only the measurements on the mean and standard deviation for each measurement.
# **************
columnas<-dim(my_data)
FirstSubmissionDataset <- my_data[, 4:columnas[2]]
write.table(FirstSubmissionDataset, "./Data/FirstSubmissionDataset.txt", sep="\t")
# ReadingTest <- read.table("./Data/FirstSubmissionDataset.txt", quote="\"") ## Checked OK
# **************
#
#

