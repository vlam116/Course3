## Getting and Cleaning Data: Course Project

#######################################################################
## Step 1: Merging the training and test sets to create one data set.## 
#######################################################################

## Reading in packages
library(tidyverse)
library(plyr)
library(stringr)

## Reading in the training and testing sets and the activity labels, then converting to tibble format for
## better readability. 

train = read.table("X_train.txt")
test = read.table("X_test.txt")
train_y = read.table("y_train.txt")
test_y = read.table("y_test.txt")
train = as_tibble(train)
test = as_tibble(test)
train_y = as_tibble(train_y)
test_y = as_tibble(test_y)

## Doing the same for each of the estimated variables from the 3 raw signals. 

bax_test = read.table("body_acc_x_test.txt")
bax_train = read.table("body_acc_x_train.txt")
bay_test = read.table("body_acc_y_test.txt")
bay_train = read.table("body_acc_y_train.txt")
baz_test = read.table("body_acc_z_test.txt")
baz_train = read.table("body_acc_z_train.txt")
bgx_test = read.table("body_gyro_x_test.txt")
bgx_train = read.table("body_gyro_x_train.txt")
bgy_test = read.table("body_gyro_y_test.txt")
bgy_train = read.table("body_gyro_y_train.txt")
bgz_train = read.table("body_gyro_z_train.txt")
bgz_test = read.table("body_gyro_z_test.txt")
tax_test = read.table("total_acc_x_test.txt")
tax_train = read.table("total_acc_x_train.txt")
tay_train = read.table("total_acc_y_train.txt")
tay_test = read.table("total_acc_y_test.txt")
taz_test = read.table("total_acc_z_test.txt")
taz_train = read.table("total_acc_z_train.txt")
bax_test = as.tibble(bax_test)
bax_test = as_tibble(bax_test)
bax_train = as_tibble(bax_train)
bay_test = as_tibble(bax_test)
bay_train = as_tibble(bay_train)
baz_test = as_tibble(baz_test)
baz_train = as_tibble(baz_train)
bgx_test = as_tibble(bgx_test)
bgx_train = as_tibble(bgx_train)
bgy_test = as_tibble(bgx_test)
bgy_test = as_tibble(bgy_test)
bgy_train = as_tibble(bgy_train)
bgz_train = as_tibble(bgz_train)
bgz_test = as_tibble(bgz_test)
tax_test = as_tibble(tax_test)
tax_train = as_tibble(tax_train)
tay_train = as_tibble(tay_train)
tay_test = as_tibble(tay_test)
taz_test = as_tibble(taz_test)
taz_train = as_tibble(taz_train)

## Now reading in the final txt files containing the numeric labels for each of the 30 participants. 

subject_test = read.table("subject_test.txt")
subject_train = read.table("subject_train.txt")
subject_test = as_tibble(subject_test)
subject_train = as_tibble(subject_train)

## Combining the rows from the 561 features in the training and testing sets. This will be the "main"
## dataframe that I will gradually bind other cleaned features and labels to. 
## The features table contains duplicate names that need to be replaced. From the additional
## info texts and README, I was able to deduce the names of these features. The features being duplicated
## came from the bandsEnergy() variables estimated from the raw signals. Measurements along the X,Y, and
## Z-axes are very common throughout many of the data frames, so I appended the bandsEnergy variables with
## the XYZ labels to remedy the duplication issue. Then, I was able to reformat the features file properly
## by pivoting the rows to become the columns, then replace the missing column names in the combined train
## /test set with the variable names. 

x_bind = bind_rows(train, test)
y_bind = bind_rows(train_y, test_y)

features = read.table("features.txt")
features = as_tibble(features)
features$V2 = as.character(features$V2) # Convert to char so we can modify the strings  

features$V2[c(303:316,382:395,461:474)] = str_replace(features$V2[c(303:316,382:395,461:474)], "f","Xf")
features$V2[c(317:330,396:409,475:488)] = str_replace(features$V2[c(317:330,396:409,475:488)], "f","Yf")
features$V2[c(331:344,410:423,489:502)] = str_replace(features$V2[c(331:344,410:423,489:502)], "f","Zf")
features = features %>% pivot_wider(names_from = V2, values_from = V1) # Renaming duplicates by labelling 
## with proper axis using stringr function str_replace, then using pivot_wider to pivot rows into columns

replacement = c(names(features)) # create a vector storing the colnames from features

# loop through each of the missing column name indices in x_bind and replace with the names from features
for(i in 1:length(replacement)) {
  names(x_bind)[i] = replacement[i]
}

y_bind = y_bind %>% rename(Activity = V1) # Give proper column name 
y_bind$Activity = as.factor(y_bind$Activity) # Factorize and rename levels to the activity labels
levels(y_bind$Activity) = mapvalues(y_bind$Activity, 
                                from = c(1,2,3,4,5,6), 
                                to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                                       "SITTING", "STANDING", "LAYING"))

subject_train = subject_train %>% rename(ID = V1)
subject_test = subject_test %>% rename(ID = V1)
subject_all = bind_rows(subject_train, subject_test) # Proper column name then combine

xy_bind = bind_cols(y_bind, x_bind) # Combine dfs, making sure to put Activity and ID cols furthest left
id_xy_bind = bind_cols(subject_all, xy_bind)

## The rest of the txt files each contain 128 readings from the "accelerometer and gyroscope 3-axial raw
## signals" (tAcc-XYZ, tGyro-XYZ) and the estimated body acceleration described in the README, which we
## can call eBodyAcc-XYZ for a total of 9 different raw variables which were used to derive the above
## 561 features. These dataframes are missing column names but are otherwise rather tidy. All that needs
## to be done is to add proper column names and append them to the main dataframe. 

## First, dealing with the estimated body acceleration readings. We can simply replace the column names
## with some variation of eBodyAcc(XYZ)Reading(1:128). 

## As usual, combine training and testing set first before perfoming transformation 
bax_bind = bind_rows(bax_train, bax_test)
bay_bind = bind_rows(bay_train, bay_test)
baz_bind = bind_rows(baz_train, baz_test)

## Using str_replace to rename the column names efficiently
bax_bind = bax_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","eBodyAccXReading")))
bay_bind = bay_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","eBodyAccYReading")))
baz_bind = baz_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","eBodyAccZReading")))

## Same thing now for the tGyro-XYZ variables.

bgx_bind = bind_rows(bgx_train, bgx_test)
bgy_bind = bind_rows(bgy_train, bgy_test)
bgz_bind = bind_rows(bgz_train, bgz_test)

bgx_bind = bgx_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tGyroXReading")))
bgy_bind = bgy_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tGyroYReading")))
bgz_bind = bgz_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tGyroZReading")))

## And now for tAcc-XYZ.

tax_bind = bind_rows(tax_train, tax_test)
tay_bind = bind_rows(tay_train, tay_test)
taz_bind = bind_rows(taz_train, taz_test)

tax_bind = tax_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tAccXReading")))
tay_bind = tay_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tAccYReading")))
taz_bind = taz_bind %>% rename_at(vars(starts_with("V")), funs(str_replace(.,"V","tAccZReading")))

## Finally, we can column bind these raw variables to the main dataframe and have one complete data set.

## Create a list of the dfs we want to column bind to the main dataframe, then bind.

raw_vars = c(bax_bind,bay_bind,baz_bind,bgx_bind,bgy_bind,bgz_bind,tax_bind,tay_bind,taz_bind)
all_data = bind_cols(id_xy_bind, raw_vars)

#######################################################################################################
## Step 2: Extracting only the measurements on the mean and standard deviation for each measurement. ##
#######################################################################################################

## Now that we have a tidy data set with each variable having its own column, each observation forming
## a row, and each type of observational unit forming a table, we now have to filter all columns in the
## data set so that only the mean and sd for each measurement remains. There are currently 1,715 columns
## in our data set, with several additional measurements such as min, max, correlation, etc. The nice thing
## is we have already given descriptive activity names to the activities in the data set (Step 3) and labeled
## the data set with descriptive variable names (Step 4) in the first part. 

