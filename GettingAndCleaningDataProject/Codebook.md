##Codebook

This codebook provides information about the specific parameters created as a result of running the run_analysis.R file.

####Resulting Columns
Below is a list of the columns shown in the final tidy dataset with some short information provided to show what they represent. 

| Column Name     |                     Information                       |         Values          |
| :-----------:   |:-----------------------------------------------------:|:-----------------------:|
| Subject         | ID of the subject who performed the task              | integer from 1 to 30    |
| ActivityName    | Activity performed by the subject                     | (see below)             |
| DomainSignal    | Type of domain signal                                 | Frequency, Time         |
| RawSignal       | Type of 3-axial raw signal                            | Accelerometer, Gyroscope|
| Acceleration    | Type of acceleration signal                           | Body, Gravity           |
| Magnitude       | Was Euclidean norm used to calculate magnitude        | Magnitude, NA           |
| Measure         | Calculation was used to make the measurement          | Mean, Std Dev           |
| JerkSignal      | Was jerk signal obtained                              | Jerk, NA                |
| Axis            | Which axis was used for the measurement               | X, Y, Z, NA             |
| count           | Number of observations with related factor combination| integer value           |
| average         | mean of observation values for each combination       | numeric value           |

The values for ActivityName can be:  
LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS or WALKING_UPSTAIRS.


####Where Columns Were Obtained From
The bullet point list below provides some details on where the columns came from. Where ***feature*** is mentioned, it is refering to the original names for the features found in the *features.txt* file. For more specific details on the steps taken to obtain the data from the original file see README.R. 

**Subject** - These were found in the *subject_test.txt* and *subject_train.txt* files. The ID's were joined with the observation results to assocatie each subject to the rest of the related information of the study.

**ActivityName** - The list of activity names were provided in the *activity_labels.txt* file. Each had a corresponding activity number found in the *y_test.txt* and *y_train.txt* files. Therefore, through merging, it was possible to replace the activity number with the acitivty name column.

**DomainSignal** - This was derived from the first letter of the ***feature***. If the first letter was t then it meant the domain signal used was time, if f then it was frequency.

**RawSignal** - Derived from ***feature***. If the text 'Acc' or 'Gyro' was present then it represented the raw signal used. 'Acc' corresponded to accelerometer, and 'Gyro' corresponded to gyroscope.

**Acceleration** - Derived from ***feature***. If the text 'Body' or 'Gravity' was present then it represented the type of acceleration signal. 'Body' corresponded to body, and 'Gravity' corresponded to gravity.

**Magnitude** - Derived from ***feature***. If the text 'Mag' was present then it showed that the associated value was the magnitude found by using the Euclidean norm calculation.

**Measure** - Derived from ***feature***. The text 'mean()' or 'std()' represented the type of calculation used for the value observation. All features had one or the other present since the data frame had been filtered to contain only columns that included them earlier. 'mean()' corresponds to Mean, and 'std()' corresponds to Std Dev.

**JerkSignal** - Derived from ***feature***. If the text 'Jerk' was present then it meant that a jerk signal was obtained.

**Axis** - Found by taking the last letter of ***feature***. If it was 'X' then it meant the x-axis was the one being observed, 'Y' meant the y-axis, and 'Z' meant the z-axis.

**count** - This number was found by counting the number of observations that matched each combination of the above 9 factors.

**average** - This was found by averaging the values for the observations for each combination of the 9 factors used for count.


####Example Output

          Subject   ActivityName DomainSignal    RawSignal    Acceleration Magnitude Measure JerkSignal Axis count  average
    1:       1          LAYING     Frequency    Accelerometer      Body        NA     Mean       NA     X    50  -0.9390991
    2:       1          LAYING     Frequency    Accelerometer      Body        NA     Mean       NA     Y    50  -0.8670652
    3:       1          LAYING     Frequency    Accelerometer      Body        NA     Mean       NA     Z    50  -0.8826669
    4:       1          LAYING     Frequency    Accelerometer      Body        NA     Mean      Jerk    X    50  -0.9570739
    5:       1          LAYING     Frequency    Accelerometer      Body        NA     Mean      Jerk    Y    50  -0.9224626
    11876:  30    WALKING_UPSTAIRS    Time       Gyroscope         Body        NA     Std Dev   Jerk    Z    65  -0.6651506
    11877:  30    WALKING_UPSTAIRS    Time       Gyroscope         Body   Magnitude   Mean       NA    NA    65  -0.1136084
    11878:  30    WALKING_UPSTAIRS    Time       Gyroscope         Body   Magnitude   Mean      Jerk   NA    65  -0.7187803
    11879:  30    WALKING_UPSTAIRS    Time       Gyroscope         Body   Magnitude   Std Dev    NA    NA    65  -0.1692935
    11880:  30    WALKING_UPSTAIRS    Time       Gyroscope         Body   Magnitude   Std Dev   Jerk   NA    65  -0.7744391

