acceleroAssignment Codebook
===========================
Data
---------------------------
Information on the original dataset can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). In summary, the data comes from 30 individuals doing 6 different activities wearing a Samsung Galaxy S II smartphone to capture measurements of linear acceleration and angular velocity. 

The data was/is preprocessed using noise filters and partitioned into two sets: training and test. In total, there are 10,299 observations with 561 attributes. The data was collected in December of 2012 and has no missing values.

Variables
---------------------------
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. The precursor t stands for time. Other transformations were applied to these data to produce even more variables including Jerk signals and frequency domain signals. In fear of approaching plagarism grounds, I direct the reader to download the dataset and read through features_info.txt from [here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/). Better than that may be to do a little reading on accelerometers. I found [this link](https://www.dimensionengineering.com/info/accelerometers) handy. 

Transformations
---------------------------
Working with the data was a bit easier than understanding how the measurements were captured. After downloading and unzipping the files into my working directory, I read in several of the txt files using read.table. This included features.txt, subject_train.txt, subject_test.txt, X_train.txt, X_test.txt, y_train.txt, and y_test.txt. I did not use the Inertial Signal folder since -- with my elementary understanding -- it seemed like the preprocessing was credible. I also did not read in the activity_labels.txt file --- I simply wrote a function (called changeToActivity) that would transform the numeric activity ID's into the appropriate descriptive names. We used these codings:

1-WALKING
2-WALKING_UPSTAIRS
3-WALKING_DOWNSTAIRS
4-SITTING
5-STANDING
6-LAYING

I first made a massive dataset and then scaled it down. I relabeld the variable names to match the features and I substituted the activity names for activity numbers. I combined x_train data with y_train data and x_test data with y_test data. After that I combined train data with test data to get the 10,299 observation, 561 feature dataframe. 

Grep helped me scale down the dataframe to only variables that measured mean or std. Then, I used gsub to clean up the variable names a bit... taking out dashes and text such as "()". I didn't change the names per se. It wasn't because I didn't know how, but rather because I didn't think it would help. Anyone confused by the original names would be confused by newer names. 

Finally, we wanted a tidy data set that broke down the average measurement of each feature (aka variable) for each subject for each activity. The reshape2 package made this easy with it's functions 'melt' and 'dcast'. The last line of code uses write.table to create a text file with the tidy dataframe in the users current working directory.
