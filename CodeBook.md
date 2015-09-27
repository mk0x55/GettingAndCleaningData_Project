#####################################################################
###  Project assignment for the course Getting and Cleaning Data  ###
###  Matus Korman <matusk@gmail.com>, 2015-09-27                  ###
###  CODE BOOK                                                    ###
#####################################################################

[THE SOURCE DATA SET]
The source data set is described on the following site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The source data set can be downloaded using the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

[THE VARIABLES]
The resulting data set has the following columns ([number]. [name] - [description]):
  1. Subject - the number of the subject from the original data set.
  2. ActivityLabel - the textual label of the activity the subject was doing during the experiment (values may be "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", and "WALKING_UPSTAIRS").
  3 through 68. [feature name from the old data set]-mean - the mean value of each mean and standard deviation measurement from the original data set.

[THE DATA]
The data contains a number, activity in a time window, and a number of movement records for a set of subjects.

[THE CLEANING PROCESS]
The original data was processed using the R programming language. Within the processing, only mean and standard deviation measurements were selected.
Measurement variable names were kept, and since mean values of these per subject and activity were extracted instead of the original values, the new variable titles contain the old variable names, appended by "-mean". Additionally, each activity label is present in a textual form instead of the original numeric one.
