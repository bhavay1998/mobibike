#### Creating training data as a random sample of the 3 months data ####

# Change directory
setwd("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Project Data/Dresden_2023")

library(tidyverse)

# Reading the data for Feb 1st week
feb_01 <- map(str_c("Dresden-2023_02/2023-02-01/", dir("Dresden-2023_02/2023-02-01")), read_rds)
feb_02 <- map(str_c("Dresden-2023_02/2023-02-02/", dir("Dresden-2023_02/2023-02-02")), read_rds)
feb_03 <- map(str_c("Dresden-2023_02/2023-02-03/", dir("Dresden-2023_02/2023-02-03")), read_rds)
feb_04 <- map(str_c("Dresden-2023_02/2023-02-04/", dir("Dresden-2023_02/2023-02-04")), read_rds)
feb_05 <- map(str_c("Dresden-2023_02/2023-02-05/", dir("Dresden-2023_02/2023-02-05")), read_rds)
feb_06 <- map(str_c("Dresden-2023_02/2023-02-06/", dir("Dresden-2023_02/2023-02-06")), read_rds)
feb_07 <- map(str_c("Dresden-2023_02/2023-02-07/", dir("Dresden-2023_02/2023-02-07")), read_rds)

feb_1st_week_df <- bind_rows(feb_01, feb_02, feb_03, feb_04, feb_05, feb_06, feb_07)

# Save memory by removing daily data
remove(feb_01)
remove(feb_02)
remove(feb_03)
remove(feb_04)
remove(feb_05)
remove(feb_06)
remove(feb_07)

# Create a sample for 1st week
set.seed(25)
rsample_feb_1st_week <- feb_1st_week_df[sample(nrow(feb_1st_week_df),20000), ]

# Create test data for feb_1st_week
library(dplyr)
set.seed(25)
feb_1st_week_training_removed <- anti_join(feb_1st_week_df, rsample_feb_1st_week)
test_rsample_feb_1st_week <- feb_1st_week_training_removed[sample(nrow(feb_1st_week_training_removed),10000), ]

# Remove the df for feb_1st_week to save memory
remove(feb_1st_week_df)
remove(feb_1st_week_training_removed)

# Reading the data for Feb 2nd week
feb_08 <- map(str_c("Dresden-2023_02/2023-02-08/", dir("Dresden-2023_02/2023-02-08")), read_rds)
feb_09 <- map(str_c("Dresden-2023_02/2023-02-09/", dir("Dresden-2023_02/2023-02-09")), read_rds)
feb_10 <- map(str_c("Dresden-2023_02/2023-02-10/", dir("Dresden-2023_02/2023-02-10")), read_rds)
feb_11 <- map(str_c("Dresden-2023_02/2023-02-11/", dir("Dresden-2023_02/2023-02-11")), read_rds)
feb_12 <- map(str_c("Dresden-2023_02/2023-02-12/", dir("Dresden-2023_02/2023-02-12")), read_rds)
feb_13 <- map(str_c("Dresden-2023_02/2023-02-13/", dir("Dresden-2023_02/2023-02-13")), read_rds)
feb_14 <- map(str_c("Dresden-2023_02/2023-02-14/", dir("Dresden-2023_02/2023-02-14")), read_rds)

feb_2nd_week_df <- bind_rows(feb_08, feb_09, feb_10, feb_11, feb_12, feb_13, feb_14)

# Save memory by removing daily data
remove(feb_08)
remove(feb_09)
remove(feb_10)
remove(feb_11)
remove(feb_12)
remove(feb_13)
remove(feb_14)

# Create a sample for 2nd week
set.seed(25)
rsample_feb_2nd_week <- feb_2nd_week_df[sample(nrow(feb_2nd_week_df),20000), ]

# Create test data for feb_2nd_week
set.seed(25)
feb_2nd_week_training_removed <- anti_join(feb_2nd_week_df, rsample_feb_2nd_week)
test_rsample_feb_2nd_week <- feb_2nd_week_training_removed[sample(nrow(feb_2nd_week_training_removed),10000), ]

# Remove the df for feb_2nd_week to save memory
remove(feb_2nd_week_df)
remove(feb_2nd_week_training_removed)

# Reading the data for Feb 3rd week
feb_15 <- map(str_c("Dresden-2023_02/2023-02-15/", dir("Dresden-2023_02/2023-02-15")), read_rds)
feb_16 <- map(str_c("Dresden-2023_02/2023-02-16/", dir("Dresden-2023_02/2023-02-16")), read_rds)
feb_17 <- map(str_c("Dresden-2023_02/2023-02-17/", dir("Dresden-2023_02/2023-02-17")), read_rds)
feb_18 <- map(str_c("Dresden-2023_02/2023-02-18/", dir("Dresden-2023_02/2023-02-18")), read_rds)
feb_19 <- map(str_c("Dresden-2023_02/2023-02-19/", dir("Dresden-2023_02/2023-02-19")), read_rds)
feb_20 <- map(str_c("Dresden-2023_02/2023-02-20/", dir("Dresden-2023_02/2023-02-20")), read_rds)
feb_21 <- map(str_c("Dresden-2023_02/2023-02-21/", dir("Dresden-2023_02/2023-02-21")), read_rds)

feb_3rd_week_df <- bind_rows(feb_15, feb_16, feb_17, feb_18, feb_19, feb_20, feb_21)

# Save memory by removing daily data
remove(feb_15)
remove(feb_16)
remove(feb_17)
remove(feb_18)
remove(feb_19)
remove(feb_20)
remove(feb_21)

# Create a sample for 3rd week
set.seed(25)
rsample_feb_3rd_week <- feb_3rd_week_df[sample(nrow(feb_3rd_week_df),20000), ]

# Create test data for feb_3rd_week
set.seed(25)
feb_3rd_week_training_removed <- anti_join(feb_3rd_week_df, rsample_feb_3rd_week)
test_rsample_feb_3rd_week <- feb_3rd_week_training_removed[sample(nrow(feb_3rd_week_training_removed),10000), ]

# Remove the df for feb_3rd_week to save memory
remove(feb_3rd_week_df)
remove(feb_3rd_week_training_removed)

# Reading the data for Feb 4th week
feb_22 <- map(str_c("Dresden-2023_02/2023-02-22/", dir("Dresden-2023_02/2023-02-22")), read_rds)
feb_23 <- map(str_c("Dresden-2023_02/2023-02-23/", dir("Dresden-2023_02/2023-02-23")), read_rds)
feb_24 <- map(str_c("Dresden-2023_02/2023-02-24/", dir("Dresden-2023_02/2023-02-24")), read_rds)
feb_25 <- map(str_c("Dresden-2023_02/2023-02-25/", dir("Dresden-2023_02/2023-02-25")), read_rds)
feb_26 <- map(str_c("Dresden-2023_02/2023-02-26/", dir("Dresden-2023_02/2023-02-26")), read_rds)
feb_27 <- map(str_c("Dresden-2023_02/2023-02-27/", dir("Dresden-2023_02/2023-02-27")), read_rds)
feb_28 <- map(str_c("Dresden-2023_02/2023-02-28/", dir("Dresden-2023_02/2023-02-28")), read_rds)

feb_4th_week_df <- bind_rows(feb_22, feb_23, feb_24, feb_25, feb_26, feb_27, feb_28)

# Save memory by removing daily data
remove(feb_22)
remove(feb_23)
remove(feb_24)
remove(feb_25)
remove(feb_26)
remove(feb_27)
remove(feb_28)

# Create a sample for 4th week
set.seed(25)
rsample_feb_4th_week <- feb_4th_week_df[sample(nrow(feb_4th_week_df),20000), ]

# Create test data for feb_4th_week
set.seed(25)
feb_4th_week_training_removed <- anti_join(feb_4th_week_df, rsample_feb_4th_week)
test_rsample_feb_4th_week <- feb_4th_week_training_removed[sample(nrow(feb_4th_week_training_removed),10000), ]

# Remove the df for feb_4th_week to save memory
remove(feb_4th_week_df)
remove(feb_4th_week_training_removed)

# Combine the rsamples for February
Feb_rsample <- rbind(rsample_feb_1st_week, rsample_feb_2nd_week, rsample_feb_3rd_week, rsample_feb_4th_week)

remove(rsample_feb_1st_week)
remove(rsample_feb_2nd_week)
remove(rsample_feb_3rd_week)
remove(rsample_feb_4th_week)

# Combine the rsamples for February -- test data
Feb_rsample_test <- rbind(test_rsample_feb_1st_week, test_rsample_feb_2nd_week, test_rsample_feb_3rd_week, test_rsample_feb_4th_week)

remove(test_rsample_feb_1st_week)
remove(test_rsample_feb_2nd_week)
remove(test_rsample_feb_3rd_week)
remove(test_rsample_feb_4th_week)

# Remove unnecessary columns
Feb_rsample <- Feb_rsample[,c(2,4,5,6,7,8,19)]
Feb_rsample_test <- Feb_rsample_test[,c(2,4,5,6,7,8,19)]

####################################################################################

# Now we repeat the same procedure for March

# March 1st week: Reading Data
march_01 <- map(str_c("Dresden-2023_03/2023-03-01/", dir("Dresden-2023_03/2023-03-01")), read_rds)
march_02 <- map(str_c("Dresden-2023_03/2023-03-02/", dir("Dresden-2023_03/2023-03-02")), read_rds)
march_03 <- map(str_c("Dresden-2023_03/2023-03-03/", dir("Dresden-2023_03/2023-03-03")), read_rds)
march_04 <- map(str_c("Dresden-2023_03/2023-03-04/", dir("Dresden-2023_03/2023-03-04")), read_rds)
march_05 <- map(str_c("Dresden-2023_03/2023-03-05/", dir("Dresden-2023_03/2023-03-05")), read_rds)
march_06 <- map(str_c("Dresden-2023_03/2023-03-06/", dir("Dresden-2023_03/2023-03-06")), read_rds)
march_07 <- map(str_c("Dresden-2023_03/2023-03-07/", dir("Dresden-2023_03/2023-03-07")), read_rds)

march_1st_week_df <- bind_rows(march_01, march_02, march_03, march_04, march_05, march_06, march_07)

# Save memory by removing daily data
remove(march_01)
remove(march_02)
remove(march_03)
remove(march_04)
remove(march_05)
remove(march_06)
remove(march_07)

# Create a sample for 1st week
set.seed(87)
rsample_march_1st_week <- march_1st_week_df[sample(nrow(march_1st_week_df),20000), ]

# Create test data for march_1st_week
set.seed(87)
march_1st_week_training_removed <- anti_join(march_1st_week_df, rsample_march_1st_week)
test_rsample_march_1st_week <- march_1st_week_training_removed[sample(nrow(march_1st_week_training_removed),10000), ]

# Remove the df for march_1st_week to save memory
remove(march_1st_week_df)
remove(march_1st_week_training_removed)

# March 2nd week: Reading Data
march_08 <- map(str_c("Dresden-2023_03/2023-03-08/", dir("Dresden-2023_03/2023-03-08")), read_rds)
march_09 <- map(str_c("Dresden-2023_03/2023-03-09/", dir("Dresden-2023_03/2023-03-09")), read_rds)
march_10 <- map(str_c("Dresden-2023_03/2023-03-10/", dir("Dresden-2023_03/2023-03-10")), read_rds)
march_11 <- map(str_c("Dresden-2023_03/2023-03-11/", dir("Dresden-2023_03/2023-03-11")), read_rds)
march_12 <- map(str_c("Dresden-2023_03/2023-03-12/", dir("Dresden-2023_03/2023-03-12")), read_rds)
march_13 <- map(str_c("Dresden-2023_03/2023-03-13/", dir("Dresden-2023_03/2023-03-13")), read_rds)
march_14 <- map(str_c("Dresden-2023_03/2023-03-14/", dir("Dresden-2023_03/2023-03-14")), read_rds)

march_2nd_week_df <- bind_rows(march_08, march_09, march_10, march_11, march_12, march_13, march_14)

# Save memory by removing daily data
remove(march_08)
remove(march_09)
remove(march_10)
remove(march_11)
remove(march_12)
remove(march_13)
remove(march_14)

# Create a sample for 2nd week
set.seed(87)
rsample_march_2nd_week <- march_2nd_week_df[sample(nrow(march_2nd_week_df),20000), ]

# Create test data for march_2nd_week
set.seed(87)
march_2nd_week_training_removed <- anti_join(march_2nd_week_df, rsample_march_2nd_week)
test_rsample_march_2nd_week <- march_2nd_week_training_removed[sample(nrow(march_2nd_week_training_removed),10000), ]

# Remove the df for march_2nd_week to save memory
remove(march_2nd_week_df)
remove(march_2nd_week_training_removed)

# March 3rd week: Reading Data
march_15 <- map(str_c("Dresden-2023_03/2023-03-15/", dir("Dresden-2023_03/2023-03-15")), read_rds)
march_16 <- map(str_c("Dresden-2023_03/2023-03-16/", dir("Dresden-2023_03/2023-03-16")), read_rds)
march_17 <- map(str_c("Dresden-2023_03/2023-03-17/", dir("Dresden-2023_03/2023-03-17")), read_rds)
march_18 <- map(str_c("Dresden-2023_03/2023-03-18/", dir("Dresden-2023_03/2023-03-18")), read_rds)
march_19 <- map(str_c("Dresden-2023_03/2023-03-19/", dir("Dresden-2023_03/2023-03-19")), read_rds)
march_20 <- map(str_c("Dresden-2023_03/2023-03-20/", dir("Dresden-2023_03/2023-03-20")), read_rds)
march_21 <- map(str_c("Dresden-2023_03/2023-03-21/", dir("Dresden-2023_03/2023-03-21")), read_rds)

march_3rd_week_df <- bind_rows(march_15, march_16, march_17, march_18, march_19, march_20, march_21)

# Save memory by removing daily data
remove(march_15)
remove(march_16)
remove(march_17)
remove(march_18)
remove(march_19)
remove(march_20)
remove(march_21)

# Create a sample for 3rd week
set.seed(87)
rsample_march_3rd_week <- march_3rd_week_df[sample(nrow(march_3rd_week_df),20000), ]

# Create test data for march_3rd_week
set.seed(87)
march_3rd_week_training_removed <- anti_join(march_3rd_week_df, rsample_march_3rd_week)
test_rsample_march_3rd_week <- march_3rd_week_training_removed[sample(nrow(march_3rd_week_training_removed),10000), ]

# Remove the df for march_3rd_week to save memory
remove(march_3rd_week_df)
remove(march_3rd_week_training_removed)

# March 4th week: Reading Data
march_22 <- map(str_c("Dresden-2023_03/2023-03-22/", dir("Dresden-2023_03/2023-03-22")), read_rds)
march_23 <- map(str_c("Dresden-2023_03/2023-03-23/", dir("Dresden-2023_03/2023-03-23")), read_rds)
march_24 <- map(str_c("Dresden-2023_03/2023-03-24/", dir("Dresden-2023_03/2023-03-24")), read_rds)
march_25 <- map(str_c("Dresden-2023_03/2023-03-25/", dir("Dresden-2023_03/2023-03-25")), read_rds)
march_26 <- map(str_c("Dresden-2023_03/2023-03-26/", dir("Dresden-2023_03/2023-03-26")), read_rds)
march_27 <- map(str_c("Dresden-2023_03/2023-03-27/", dir("Dresden-2023_03/2023-03-27")), read_rds)
march_28 <- map(str_c("Dresden-2023_03/2023-03-28/", dir("Dresden-2023_03/2023-03-28")), read_rds)
march_29 <- map(str_c("Dresden-2023_03/2023-03-29/", dir("Dresden-2023_03/2023-03-29")), read_rds)
march_30 <- map(str_c("Dresden-2023_03/2023-03-30/", dir("Dresden-2023_03/2023-03-30")), read_rds)
march_31 <- map(str_c("Dresden-2023_03/2023-03-31/", dir("Dresden-2023_03/2023-03-31")), read_rds)

march_4th_week_df <- bind_rows(march_22, march_23, march_24, march_25, march_26, march_27, march_28, march_29, march_30, march_31)

# Save memory by removing daily data
remove(march_22)
remove(march_23)
remove(march_24)
remove(march_25)
remove(march_26)
remove(march_27)
remove(march_28)
remove(march_29)
remove(march_30)
remove(march_31)

# Create a sample for 4th week
set.seed(87)
rsample_march_4th_week <- march_4th_week_df[sample(nrow(march_4th_week_df),20000), ]

# Create test data for march_4th_week
set.seed(87)
march_4th_week_training_removed <- anti_join(march_4th_week_df, rsample_march_4th_week)
test_rsample_march_4th_week <- march_4th_week_training_removed[sample(nrow(march_4th_week_training_removed),10000), ]

# Remove the df for march_4th_week to save memory
remove(march_4th_week_df)
remove(march_4th_week_training_removed)

# Remove the 'pedelec_battery' column from sample 4
rsample_march_4th_week <- rsample_march_4th_week[,c(1:25)]
test_rsample_march_4th_week <- test_rsample_march_4th_week[,c(1:25)]

# Create march sample by combining weekly samples
March_rsample <- rbind(rsample_march_1st_week, rsample_march_2nd_week, rsample_march_3rd_week, rsample_march_4th_week)

remove(rsample_march_1st_week)
remove(rsample_march_2nd_week)
remove(rsample_march_3rd_week)
remove(rsample_march_4th_week)

# Combine the rsamples for March -- test data
March_rsample_test <- rbind(test_rsample_march_1st_week, test_rsample_march_2nd_week, test_rsample_march_3rd_week, test_rsample_march_4th_week)

remove(test_rsample_march_1st_week)
remove(test_rsample_march_2nd_week)
remove(test_rsample_march_3rd_week)
remove(test_rsample_march_4th_week)

# Remove unnecessary columns
March_rsample <- March_rsample[,c(2,4,5,6,7,8,19)]
March_rsample_test <- March_rsample_test[,c(2,4,5,6,7,8,19)]

####################################################################################

# Now we repeat the same procedure for April

# April 1st week: Reading Data
apr_01 <- map(str_c("Dresden-2023_04/2023-04-01/", dir("Dresden-2023_04/2023-04-01")), read_rds)
apr_02 <- map(str_c("Dresden-2023_04/2023-04-02/", dir("Dresden-2023_04/2023-04-02")), read_rds)
apr_03 <- map(str_c("Dresden-2023_04/2023-04-03/", dir("Dresden-2023_04/2023-04-03")), read_rds)
apr_04 <- map(str_c("Dresden-2023_04/2023-04-04/", dir("Dresden-2023_04/2023-04-04")), read_rds)
apr_05 <- map(str_c("Dresden-2023_04/2023-04-05/", dir("Dresden-2023_04/2023-04-05")), read_rds)
apr_06 <- map(str_c("Dresden-2023_04/2023-04-06/", dir("Dresden-2023_04/2023-04-06")), read_rds)
apr_07 <- map(str_c("Dresden-2023_04/2023-04-07/", dir("Dresden-2023_04/2023-04-07")), read_rds)

apr_1st_week_df <- bind_rows(apr_01, apr_02, apr_03, apr_04, apr_05, apr_06, apr_07)

# Save memory by removing daily data
remove(apr_01)
remove(apr_02)
remove(apr_03)
remove(apr_04)
remove(apr_05)
remove(apr_06)
remove(apr_07)

# Create a sample for 1st week
set.seed(192)
rsample_apr_1st_week <- apr_1st_week_df[sample(nrow(apr_1st_week_df),20000), ]

# Create test data for apr_1st_week
set.seed(192)
apr_1st_week_training_removed <- anti_join(apr_1st_week_df, rsample_apr_1st_week)
test_rsample_apr_1st_week <- apr_1st_week_training_removed[sample(nrow(apr_1st_week_training_removed),10000), ]

# Remove the df for apr_1st_week to save memory
remove(apr_1st_week_df)
remove(apr_1st_week_training_removed)

# April 2nd week: Reading Data
apr_08 <- map(str_c("Dresden-2023_04/2023-04-08/", dir("Dresden-2023_04/2023-04-08")), read_rds)
apr_09 <- map(str_c("Dresden-2023_04/2023-04-09/", dir("Dresden-2023_04/2023-04-09")), read_rds)
apr_10 <- map(str_c("Dresden-2023_04/2023-04-10/", dir("Dresden-2023_04/2023-04-10")), read_rds)
apr_11 <- map(str_c("Dresden-2023_04/2023-04-11/", dir("Dresden-2023_04/2023-04-11")), read_rds)
apr_12 <- map(str_c("Dresden-2023_04/2023-04-12/", dir("Dresden-2023_04/2023-04-12")), read_rds)
apr_13 <- map(str_c("Dresden-2023_04/2023-04-13/", dir("Dresden-2023_04/2023-04-13")), read_rds)
apr_14 <- map(str_c("Dresden-2023_04/2023-04-14/", dir("Dresden-2023_04/2023-04-14")), read_rds)

apr_2nd_week_df <- bind_rows(apr_08, apr_09, apr_10, apr_11, apr_12, apr_13, apr_14)

# Save memory by removing daily data
remove(apr_08)
remove(apr_09)
remove(apr_10)
remove(apr_11)
remove(apr_12)
remove(apr_13)
remove(apr_14)

# Create a sample for 2nd week
set.seed(192)
rsample_apr_2nd_week <- apr_2nd_week_df[sample(nrow(apr_2nd_week_df),20000), ]

# Create test data for apr_2nd_week
set.seed(192)
apr_2nd_week_training_removed <- anti_join(apr_2nd_week_df, rsample_apr_2nd_week)
test_rsample_apr_2nd_week <- apr_2nd_week_training_removed[sample(nrow(apr_2nd_week_training_removed),10000), ]

# Remove the df for apr_2nd_week to save memory
remove(apr_2nd_week_df)
remove(apr_2nd_week_training_removed)

# April 3rd week: Reading Data
apr_15 <- map(str_c("Dresden-2023_04/2023-04-15/", dir("Dresden-2023_04/2023-04-15")), read_rds)
apr_16 <- map(str_c("Dresden-2023_04/2023-04-16/", dir("Dresden-2023_04/2023-04-16")), read_rds)
apr_17 <- map(str_c("Dresden-2023_04/2023-04-17/", dir("Dresden-2023_04/2023-04-17")), read_rds)
apr_18 <- map(str_c("Dresden-2023_04/2023-04-18/", dir("Dresden-2023_04/2023-04-18")), read_rds)
apr_19 <- map(str_c("Dresden-2023_04/2023-04-19/", dir("Dresden-2023_04/2023-04-19")), read_rds)
apr_20 <- map(str_c("Dresden-2023_04/2023-04-20/", dir("Dresden-2023_04/2023-04-20")), read_rds)
apr_21 <- map(str_c("Dresden-2023_04/2023-04-21/", dir("Dresden-2023_04/2023-04-21")), read_rds)

apr_3rd_week_df <- bind_rows(apr_15, apr_16, apr_17, apr_18, apr_19, apr_20, apr_21)

# Save memory by removing daily data
remove(apr_15)
remove(apr_16)
remove(apr_17)
remove(apr_18)
remove(apr_19)
remove(apr_20)
remove(apr_21)

# Create a sample for 3rd week
set.seed(192)
rsample_apr_3rd_week <- apr_3rd_week_df[sample(nrow(apr_3rd_week_df),20000), ]

# Create test data for apr_3rd_week
set.seed(192)
apr_3rd_week_training_removed <- anti_join(apr_3rd_week_df, rsample_apr_3rd_week)
test_rsample_apr_3rd_week <- apr_3rd_week_training_removed[sample(nrow(apr_3rd_week_training_removed),10000), ]

# Remove the df for apr_3rd_week to save memory
remove(apr_3rd_week_df)
remove(apr_3rd_week_training_removed)

# April 4th week: Reading Data
apr_22 <- map(str_c("Dresden-2023_04/2023-04-22/", dir("Dresden-2023_04/2023-04-22")), read_rds)
apr_23 <- map(str_c("Dresden-2023_04/2023-04-23/", dir("Dresden-2023_04/2023-04-23")), read_rds)
apr_24 <- map(str_c("Dresden-2023_04/2023-04-24/", dir("Dresden-2023_04/2023-04-24")), read_rds)
apr_25 <- map(str_c("Dresden-2023_04/2023-04-25/", dir("Dresden-2023_04/2023-04-25")), read_rds)
apr_26 <- map(str_c("Dresden-2023_04/2023-04-26/", dir("Dresden-2023_04/2023-04-26")), read_rds)
apr_27 <- map(str_c("Dresden-2023_04/2023-04-27/", dir("Dresden-2023_04/2023-04-27")), read_rds)
apr_28 <- map(str_c("Dresden-2023_04/2023-04-28/", dir("Dresden-2023_04/2023-04-28")), read_rds)
apr_29 <- map(str_c("Dresden-2023_04/2023-04-29/", dir("Dresden-2023_04/2023-04-29")), read_rds)
apr_30 <- map(str_c("Dresden-2023_04/2023-04-30/", dir("Dresden-2023_04/2023-04-30")), read_rds)

apr_4th_week_df <- bind_rows(apr_22, apr_23, apr_24, apr_25, apr_26, apr_27, apr_28, apr_29, apr_30)

# Save memory by removing daily data
remove(apr_22)
remove(apr_23)
remove(apr_24)
remove(apr_25)
remove(apr_26)
remove(apr_27)
remove(apr_28)
remove(apr_29)
remove(apr_30)

# Create a sample for 4th week
set.seed(192)
rsample_apr_4th_week <- apr_4th_week_df[sample(nrow(apr_4th_week_df),20000), ]

# Create test data for apr_4th_week
set.seed(192)
apr_4th_week_training_removed <- anti_join(apr_4th_week_df, rsample_apr_4th_week)
test_rsample_apr_4th_week <- apr_4th_week_training_removed[sample(nrow(apr_4th_week_training_removed),10000), ]

# Remove the df for apr_4th_week to save memory
remove(apr_4th_week_df)
remove(apr_4th_week_training_removed)

# Create april sample by combining weekly samples
April_rsample <- rbind(rsample_apr_1st_week, rsample_apr_2nd_week, rsample_apr_3rd_week, rsample_apr_4th_week)

remove(rsample_apr_1st_week)
remove(rsample_apr_2nd_week)
remove(rsample_apr_3rd_week)
remove(rsample_apr_4th_week)

# Create april sample by combining weekly samples -- test data
April_rsample_test <- rbind(test_rsample_apr_1st_week, test_rsample_apr_2nd_week, test_rsample_apr_3rd_week, test_rsample_apr_4th_week)

remove(test_rsample_apr_1st_week)
remove(test_rsample_apr_2nd_week)
remove(test_rsample_apr_3rd_week)
remove(test_rsample_apr_4th_week)

# Remove unnecessary columns
April_rsample <- April_rsample[,c(2,4,5,6,7,8,19)]
April_rsample_test <- April_rsample_test[,c(2,4,5,6,7,8,19)]

############################################################################
# FINAL TRAINING DATA - Combine the 3 month data #
############################################################################
training <- rbind(April_rsample, Feb_rsample, March_rsample)
test <- rbind(April_rsample_test, Feb_rsample_test, March_rsample_test)

remove(April_rsample)
remove(March_rsample)
remove(Feb_rsample)
remove(April_rsample_test)
remove(March_rsample_test)
remove(Feb_rsample_test)

# Convert to sf objects
test_sf <- st_as_sf(test, coords = c("lng","lat"), crs = 4326)
train_sf <- st_as_sf(training, coords = c("lng","lat"), crs = 4326)
remove(test)
remove(training)

### Remove outliers from both data files
dresden <- st_read("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/export.geojson")

# Removing outliers from training data 
row_index_train <- as.data.frame(st_intersects(train_sf, dresden))
train_sf <- train_sf[(row_index_train[ , 1]), ]
remove(row_index_train)

# Removing outliers from test data
row_index_test <- as.data.frame(st_intersects(test_sf, dresden))
test_sf <- test_sf[(row_index_test[ , 1]), ]
remove(row_index_test)

# Check for outliers using a map

library(leaflet)

leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = T, opacity = 0.5, weight = 1) %>%
  addCircles(data = train_sf, color = "purple")

leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = T, opacity = 0.5, weight = 1) %>%
  addCircles(data = test_sf, color = "purple")


# Save data
save(train_sf, file = "Training_Data_no_outliers.RData")
save(test_sf, file = "Test_Data_no_outliers.RData")
