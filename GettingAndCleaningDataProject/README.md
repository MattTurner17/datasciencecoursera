##ReadMe file explaining steps taken within the run_analysis.R file

This Readme contains a step by step breakdown of what is being done when tidying the data in the UCI HAR Dataset. For information about what the parameters used represent then see the codebook.md file.

###Steps taken:

1) After the relevant libraries and path to working directory have been found, there is a check to establish whether the UCI HAR Dataset exists. If it doesn't then the file is downloaded and unzipped.

2) Next, the 6 files needed in order to tidy the data are downloaded. These 6 files are the following:
* subject_test.txt
* subject_train.txt
* y_test.txt
* y_train.txt
* X_test.txt
* X_train.txt

3) These files are then joined by row (by subject, y, X) to produce 3 data frames, and finally these are joined by column to produce a single dataframe containing all the needed information

4) Now, we want to subset this data frame so that only columns containing the mean and standard deviation are put into a new data frame.

5) The activity names found from the file activity_labels.txt are then merged in based on the activity number. Then the data frame is melted so that feature becomes a single column rather than having a separate column for each feature.

6) Next, the feature names are used to create new columns that can categorise each aspect of the feature. These new columns are added to the existing data frame. 

7) The aspects are then removed from the feature name, resulting in the feature column becoming redundant. To ensure this is the case there is a check to make sure that every feature element is empty before removing this column from the data frame.

8) Finally, the data frame is reordered to make it make readable before then being melted again by each feature aspect. Doing this allows the mean (ad also the count) to be calculated for every possible combination of feature aspects. 
The resulting dataframe, named 'finalTidyDataset' is the output and contains the finished tidy data set as required.

[in oreder to write this data frame to a .txt file use the command write.table(finalTidyDataset, "filenname").]


