acceleroAssignment
==================
Goal
------------------
The goal of this script is to convert raw data measurements of linear acceleration and angular velocity collected from 30 Samsung Galaxy S II smartphones into a tidy set of average measurments across each phone during different types of activities. 

Steps to Reproduce Tidy Dataset
------------------
1. Run run_analysis.R. The script will do everything from downloading the raw data from the web into your working directory to writing a tidy data text file into that same directory.
2. If you want to manually download and unzip the files you can find them [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). In this case, when you run run_analysis begin from line 21 right under the line of hashtags.

What Actually Happens
------------------
Each group of code in the run_analysis.R file gives a desciption of what is happening. Here are some of the higher level steps involved:
* load required packages
* find and set/create wd and download zip file to that directory for unzip
* read in multiple files getting ready to combine and clean data
  * features.txt
  * subject_train.txt and subject_test.txt
  * X_train.txt and y_train.txt
  * X_test.txt and y_test.txt
* merge those files into one giant file
* filter out variables on the mean and std
* break variables into ID's and measurements and summarize data by mean for subject and activity
* write final dataset into text file in working directory

What Doesn't Happen
------------------
1. I didn't use the rawest data in Inertial Signals files. It seemed wiser to use the aggregated data since nothing was getting lost.
2. I didn't go crazy renaming the variables. This data is difficult enough to understand and I felt as though the names in the tidyData set are sufficient.
3. I am aware this script could be a lot shorter and a lot faster. Time constraints will keep it as it is for now.
