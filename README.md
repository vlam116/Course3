Getting and Cleaning Data Course Project README 

This readme outlines the steps taken to create a script that tidies the Human Activity Recognition Using 
Smartphones Dataset. The assignment calls for a script that does the following: 

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script I provided does exactly this, although in a slightly different order. Naturally, the first step in the process is to actually read in the data, which is done in the first step of the code. I specifically used the read.table with default arguments. since the data is stored in numerous txt files. This takes a little while to run, since the dimensions are a decent size. If you examine the txt files first either using a text editor like Notepad++ or VSCode, there are no column names and observations are separated by a space (" "). So read.table does the job just fine. 

The read.table data frames are converted to "tibbles" using the dplyr function as_tibble, a package that is part of the tidyverse package. Tibbles are easier to work with because it displays the data very neatly and compactly. They can also be used with other dplyr functions such as summarize, rename, filter, etc. which will come in handy later on. 

Once all the data has been read into R, the first step of the assignment calls for the training and testing sets to be merged into one data set. On the surface, this is a very simple process, but the nature of how the data is stored in this particular dataset can be confusing. One has to carefully read the readme and information files provided with the data files in order to gain an understanding of what goes where. The readme provides us with a simple description of what each txt file contains. 

- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

So now, we have to match the txt files accordingly, we cannot just blindly bind rows or columns together from different data sets and expect the observations to line up. 

First things first, the logical choice is to create the main dataframe we will be binding other variables to, which can be done by combining the train and test dataframes with their corresponding testing dataframes, and then performing a rowbind. This makes sense because the training set contains 70% of the observations, and the testing set contains the other 30%, so the number of columns (representing variables) in each set are the same. 
Thus, we rowbind the labels (contained in train/y_train) and then rowbind the sets. This will create a column containing the activity labels, and our main dataframe with all 561 variables.

The next step is to prepare column names for our newly created main dataframe. The main dataframe is missing column names, which have placeholders V1:V561. The names for these columns can all be found in the features.txt file, however since there are so many variables it would be difficult and time consuming to manually rename every column. Fortunately, the variable names in features.txt are already in order, i.e the name of column 1 in our main dataframe corresponds to the first variable name in features.txt. So the goal is simple, we would like to insert the names from the features file into every column in the main dataframe in the order that they appear. There are a couple problems, however. The first is that the names are stored in rows, not columns. This makes it impossible to use the names() function to get every variable name that we need. Second, there are duplicate variable names in the features.txt, so we will be short on column names when we eventually replace the ones in the main dataframe.  

The solution is to find the identical rows in the features dataframe, rename those rows accoringly, then pivot the rows to create 561 columns. The duplicates can be identified by examining the features.txt file, or through subsetting rows. With the duplicates located and modified, the rows can then be pivoted properly (rows with the same name as other rows obviously cannot create new columns) and the names of every feature can be properly stored in a vector called replacement for use in a for loop. The loop goes through every name of the column index in the main dataframe and replaces it with its corresponding character string from the replacement vector. 

After giving proper column names to the label columns, we can look at the activity_labels text file and manually replace the integer values with the actual names of each activity. Now, these columns are ready to be binded to the main dataframe. So far, steps 1,3, and 4 have been performed to some degree.

Now we have to deal with the datasets containing the raw variables used to derive the 561 features in the main dataframe. There are 3 raw variables measured along the XYZ axes, creating a total of 9 raw variables: tAcc-XYZ, tGyro-XYZ, and what is described as "estimated body acceleration", which we can call eBodyAcc-XYZ. The data was split by measurement, then by axis, then by training and test set, creating 3*3*2 = 18 different files in which the measurements were stored. Like the previous data sets, when read in using read.table, column names were missing. However, there is a lot less to do since we are given the following information from the readme: there are 128 readings per window. This explains the 128 columns for each of the 18 datasets. So, we don't have to worry about giving each column a unique name, just some variation of *measurement*_*axis*_*reading#*. After the columns are renamed, we can simply combine the training and testing sets like before and then finally create a finished main dataframe. This concludes steps 1,3, and 4. 

Step 2 calls for extracting the columns in which only mean and standard deviation are measured for the given variable. So in hindsight, we didn't really have to work with all of those different data sets, we only needed to work with the original 516 variables and extract out the ones where mean and standard deviation were measured. However, since we used the literal names of each variable provided by the features.txt file, our jobs were made much easier. A couple R commands allows us to extract only the columns where mean and std are measured, and then subset the main dataframe. 

Last, step 5 requires us to create a second, independent tidy data set from step 4 which gives the average of each variable for each activity and each subject. What this means is that for every given combination of person and activity, we need to return the average of each column. so in total, there should be number of participants (30) times the number of different activities (6) = 180 rows in the final tidy data set, and the number of columns should be unchanged from step 4. This can be very easily done by using the group_by function coupled with summarize_all, which returns the final dataframe that we need. The only thing left to do is to rename the columns appropriately and then writing the data frame to a file that will be submitted. 
