library(sf)
library(stars)

# load the independent variables and bikes data in random sample
load("predictors.RData")
load("Bike_Demand_Training.RData")

#Part 1: make sure bike_demand and predictor data frame has unique identifier
# predictor has "blocknr", bike_deman has "ID", both has unique identifier
Demand_by_cluster_train$ID <- seq_len(nrow(Demand_by_cluster_train))                         
Demand_by_cluster_train<- Demand_by_cluster_train[c(3,1,2)]

#Part 2: Calculate Overlapping Areas
# Convert self-made polygons data to sf object
Demand_by_cluster_train_sf <- st_as_sf(Demand_by_cluster_train)
st_crs(Demand_by_cluster_train_sf) <- st_crs(4326)


#calculate only population weight first
# Convert population data to sf object
predictors1 <- predictors[,c(1,2,3,4,11,16)]
predictors1_sf <- st_as_sf(predictors1)
st_crs(predictors1_sf) <- st_crs(4326)

#Now check if both objects have the same CRS
st_crs(Demand_by_cluster_train_sf) == st_crs(predictors1_sf) 

# Create an empty list to store the results
result_list_train <- list()

# Loop through each row of bike_demand_sf
for (i in 1:nrow(Demand_by_cluster_train_sf)) {
  # Get the current row from bike_demand_sf
  current_Demand_by_cluster_train <- Demand_by_cluster_train_sf[i, ]
  
  # Loop through each row of predictors1_sf
  for (j in 1:nrow(predictors1_sf)) {
    # Get the current row from predictors1_sf
    current_predictors_train <- predictors1_sf[j, ]
    
    # Calculate the intersection of polygons
    overlapping_areas <- st_intersection(current_Demand_by_cluster_train, current_predictors_train)
    
    # Check if there is any overlapping area
    if (nrow(overlapping_areas) > 0) {
      # Calculate the area of overlapping regions
      area_overlapping <- st_area(overlapping_areas)
      area_Demand_by_cluster_train <- st_area(current_Demand_by_cluster_train)
      area_predictors <- st_area(current_predictors_train)
      
      # Calculate the percentage contribution
      percentage <- area_overlapping / area_Demand_by_cluster_train 
      
      # Create a data frame with the results
      result_df_train <- data.frame(ID = current_Demand_by_cluster_train$ID,
                                    bike_demand = current_Demand_by_cluster_train$`Bike Demand`,      
                                    blocknr = current_predictors_train$blocknr,
                                    stadtteil = current_predictors_train$Stadtteile,
                                    percentage_Demand_by_cluster_train_sf = percentage)
      
      # Round the percentage values to 2 decimal places
      result_df_train$percentage_Demand_by_cluster_train_sf <- round(result_df_train$percentage_Demand_by_cluster_train_sf, 2)
      
      # Add the data frame to the result_list
      result_list_train[[paste0("bike_", i, "_predictors_", j)]] <- result_df_train
    }
  }
} 

# Print the combined result data frame
result_df_train <- do.call(rbind,result_list_train)
#print(result_df)
#check an example cluster 24
cluster_24 <- result_df_train[result_df_train$ID==24,]
cluster_24

##Part 3:  Perform the Area-Weighted Averages
library(dplyr)
#  join result_df with predictors data frame
result_df_train <- result_df_train %>%
  left_join(predictors, by = "blocknr")


# Calculate the weighted_population_density
result_df_train$weighted_population_density <- result_df_train$percentage_Demand_by_cluster_train_sf * result_df_train$population_density
result_df_train$weighted_population_density <- round(result_df_train$population_density, 2)

#calculate the weighted_age_density
#make young_group_density under 60 age
#old_group_density over 60 age
result_df_train$young_group_density <- round((result_df_train$`0 - 5 age_density` + result_df_train$`6 - 17 age_density` +
                                              result_df_train$`18-24 age_density` + result_df_train$`25-44 age_density` +
                                              result_df_train$`45-59 age_density`)/5, 2)

#young group density
result_df_train$weighted_ygrp_density <- round((result_df_train$percentage_Demand_by_cluster_train_sf*result_df_train$young_group_density), 2)
#old group density
result_df_train$weighted_ogrp_density <- round((result_df_train$percentage_Demand_by_cluster_train_sf*result_df_train$`>60 age_density`), 2)

#calculate the weighted_car_density
#calculate the weighted_unemployment_density

result_df_train$weighted_car_density <- round((result_df_train$percentage_Demand_by_cluster_train_sf*result_df_train$car_density), 2)
result_df_train$weighted_unemployment_density <- round((result_df_train$percentage_Demand_by_cluster_train_sf*result_df_train$unemployment_density), 2)

##get the variables what we need
result_df_train<-result_df_train[,c(1,2,21,23,24,25,26)]

result_df_train$bike_demand <- as.numeric(result_df_train$bike_demand)
result_df_train$weighted_population_density <- as.numeric(result_df_train$weighted_population_density)
result_df_train$weighted_ygrp_density <- as.numeric(result_df_train$weighted_ygrp_density)
result_df_train$weighted_ogrp_density <- as.numeric(result_df_train$weighted_ogrp_density)
result_df_train$weighted_car_density <- as.numeric(result_df_train$weighted_car_density)
result_df_train$weighted_unemployment_density <- as.numeric(result_df_train$weighted_unemployment_density)

#because we have blocknr 33, 34, 44
result_df_train[is.na(result_df_train)] <-0
colSums(is.na(result_df_train))

train_summary <- result_df_train %>% 
  group_by(ID) %>% 
  summarize(f_pop_density = sum(weighted_population_density, na.rm=TRUE),
            f_ygrp_density = sum(weighted_ygrp_density, na.rm=TRUE),
            f_ogrp_density = sum(weighted_ogrp_density, na.rm=TRUE),
            f_car_density = sum(weighted_car_density, na.rm=TRUE),
            f_unemployment_density = sum(weighted_unemployment_density,na.rm=TRUE))

library(dplyr)
train_summary <- train_summary %>%
  left_join(Demand_by_cluster_train, by = c("ID" = "ID")) %>%
  arrange(ID)

save(train_summary, file = "final_train.RData")


####### prepare test data 
load("Bike_Demand_Test.RData")

#Part 1: make sure bike_demand and predictor data frame has unique identifier
# predictor has "blocknr", bike_deman has "ID", both has unique identifier
Demand_by_cluster_test$ID <- seq_len(nrow(Demand_by_cluster_test))                         
Demand_by_cluster_test<- Demand_by_cluster_test[c(3,1,2)]

#Part 2: Calculate Overlapping Areas
# Convert self-made polygons data to sf object
Demand_by_cluster_test_sf <- st_as_sf(Demand_by_cluster_test)
st_crs(Demand_by_cluster_test_sf) <- st_crs(4326)

#Now check if both objects have the same CRS
st_crs(Demand_by_cluster_test_sf) == st_crs(predictors1_sf) 

# Create an empty list to store the results
result_list_test <- list()

# Loop through each row of bike_demand_sf
for (i in 1:nrow(Demand_by_cluster_test_sf)) {
  # Get the current row from bike_demand_sf
  current_Demand_by_cluster_test <- Demand_by_cluster_test_sf[i, ]
  
  # Loop through each row of predictors1_sf
  for (j in 1:nrow(predictors1_sf)) {
    # Get the current row from predictors1_sf
    current_predictors_test <- predictors1_sf[j, ]
    
    # Calculate the intersection of polygons
    overlapping_areas <- st_intersection(current_Demand_by_cluster_test, current_predictors_test)
    
    # Check if there is any overlapping area
    if (nrow(overlapping_areas) > 0) {
      # Calculate the area of overlapping regions
      area_overlapping <- st_area(overlapping_areas)
      area_Demand_by_cluster_test <- st_area(current_Demand_by_cluster_test)
      area_predictors <- st_area(current_predictors_test)
      
      # Calculate the percentage contribution
      percentage <- area_overlapping / area_Demand_by_cluster_test 
      
      # Create a data frame with the results
      result_df_test <- data.frame(ID = current_Demand_by_cluster_test$ID,
                                    bike_demand = current_Demand_by_cluster_test$`Bike Demand`,      
                                    blocknr = current_predictors_test$blocknr,
                                    stadtteil = current_predictors_test$Stadtteile,
                                    percentage_Demand_by_cluster_test_sf = percentage)
      
      # Round the percentage values to 2 decimal places
      result_df_test$percentage_Demand_by_cluster_test_sf <- round(result_df_test$percentage_Demand_by_cluster_test_sf, 2)
      
      # Add the data frame to the result_list
      result_list_test[[paste0("bike_", i, "_predictors_", j)]] <- result_df_test
    }
  }
} 

# Print the combined result data frame
result_df_test <- do.call(rbind,result_list_test)

#check an example cluster 24
cluster_24 <- result_df_test[result_df_test$ID==24,]
cluster_24

##Part 3:  Perform the Area-Weighted Averages
library(dplyr)
#  join result_df with predictors data frame
result_df_test <- result_df_test %>%
  left_join(predictors, by = "blocknr")


# Calculate the weighted_population_density
result_df_test$weighted_population_density <- result_df_test$percentage_Demand_by_cluster_test_sf * result_df_test$population_density
result_df_test$weighted_population_density <- round(result_df_test$population_density, 2)

#calculate the weighted_age_density
#make young_group_density under 60 age
#old_group_density over 60 age
result_df_test$young_group_density <- round((result_df_test$`0 - 5 age_density` + result_df_test$`6 - 17 age_density` +
                                                result_df_test$`18-24 age_density` + result_df_test$`25-44 age_density` +
                                                result_df_test$`45-59 age_density`)/5, 2)

#young group density
result_df_test$weighted_ygrp_density <- round((result_df_test$percentage_Demand_by_cluster_test_sf*result_df_test$young_group_density), 2)
#old group density
result_df_test$weighted_ogrp_density <- round((result_df_test$percentage_Demand_by_cluster_test_sf*result_df_test$`>60 age_density`), 2)

#calculate the weighted_car_density
#calculate the weighted_unemployment_density

result_df_test$weighted_car_density <- round((result_df_test$percentage_Demand_by_cluster_test_sf*result_df_test$car_density), 2)
result_df_test$weighted_unemployment_density <- round((result_df_test$percentage_Demand_by_cluster_test_sf*result_df_test$unemployment_density), 2)

# delete missing values for 33,34,44 district, because they don't have population, age, car and unemployment.
#result_df_test <- na.omit(result_df_test)
#colSums(is.na(result_df_train))

##get the variables what we need
result_df_test<-result_df_test[,c(1,2,21,23,24,25,26)]

result_df_test$bike_demand <- as.numeric(result_df_test$bike_demand)
result_df_test$weighted_population_density <- as.numeric(result_df_test$weighted_population_density)
result_df_test$weighted_ygrp_density <- as.numeric(result_df_test$weighted_ygrp_density)
result_df_test$weighted_ogrp_density <- as.numeric(result_df_test$weighted_ogrp_density)
result_df_test$weighted_car_density <- as.numeric(result_df_test$weighted_car_density)
result_df_test$weighted_unemployment_density <- as.numeric(result_df_test$weighted_unemployment_density)

#because we have blocknr 33, 34, 44
result_df_test[is.na(result_df_test)] <-0
colSums(is.na(result_df_test))

test_summary <- result_df_test %>% 
  group_by(ID) %>% 
  summarize(f_pop_density = sum(weighted_population_density, na.rm=TRUE),
            f_ygrp_density = sum(weighted_ygrp_density, na.rm=TRUE),
            f_ogrp_density = sum(weighted_ogrp_density, na.rm=TRUE),
            f_car_density = sum(weighted_car_density, na.rm=TRUE),
            f_unemployment_density = sum(weighted_unemployment_density,na.rm=TRUE))

library(dplyr)
test_summary <- test_summary %>%
  left_join(Demand_by_cluster_test, by = c("ID" = "ID")) %>%
  arrange(ID)

save(test_summary, file = "final_test.RData")

