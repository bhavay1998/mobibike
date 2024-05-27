load("final_train.RData")

final_result_df_train <- train_summary[,c(7,2,3,4,5,6)]

### random forest for training data
set.seed(1234)
install.packages("randomForest")
library(randomForest)
colnames(final_result_df_train) <- c("bike_demand", "pop_de","ygrp_de","ogrp_de","car_de","unem_de")
train.bikes <- randomForest(final_result_df_train$bike_demand ~ ., data = final_result_df_train, ntree = 300, mtry = 5, importance = TRUE)
plot(train.bikes, col="red3", lwd =3)
varImpPlot (train.bikes, pch = 19)

# Now you can try running the partialPlot() function again with the converted data frame
#install.packages("randomForest")
library(randomForest)
par(mfrow = c(2, 3))  # Set the plot layout to have 2 rows and 3 columns
partialPlot(train.bikes, pred.data = final_result_df_train, x.var = "pop_de")
partialPlot(train.bikes, pred.data = final_result_df_train, x.var = "ygrp_de" )
partialPlot(train.bikes, pred.data = final_result_df_train, x.var = "ogrp_de" )
partialPlot(train.bikes, pred.data = final_result_df_train, x.var = "car_de" )
partialPlot(train.bikes, pred.data = final_result_df_train, x.var = "unem_de" )
par(mfrow = c(1, 1))  # Restore the default plot layout

## To check R2 to look model fitness on the training data
predicted_value_train <- predict(train.bikes, newdata = final_result_df_train[,-1])
# Calculate the total sum of squares (SST)
actual_bike_demand_train <- final_result_df_train$bike_demand  # Replace "target_variable" with the actual name of your target variable
mean_bike_demand_train <- mean(final_result_df_train$bike_demand)
mean_bike_demand_train
SST <- sum((actual_bike_demand_train - mean_bike_demand_train)^2)
# Calculate the sum of squares of residuals (SSE)
SSE <- sum((actual_bike_demand_train - predicted_value_train)^2)
# Calculate R-squared (R2)
R2 <- 1 - (SSE / SST)
R2

load("final_test.RData")
final_result_df_test <- test_summary[,c(7,2,3,4,5,6)]
colnames(final_result_df_test) <- c("bike_demand", "pop_de","ygrp_de","ogrp_de","car_de","unem_de")
# Calculate RMSE
install.packages("caret")  # Install the caret package
library(caret)  # Load the caret package
library(car)
predictions <- predict(train.bikes, newdata = final_result_df_test[,-1])
RMSE(predictions,final_result_df_test$bike_demand)
MAE(predictions,final_result_df_test$bike_demand)
mean_bike_demand <- mean(final_result_df_test$bike_demand)
mean_bike_demand
median_bike_demand <- median(final_result_df_test$bike_demand)
median_bike_demand


# adaptive boosting 
library(mboost)
boost.bikedemand = blackboost(final_result_df_train$bike_demand ~., data = final_result_df_train, 
                               control = boost_control(mstop = 100))
predictions_boosting <- predict(boost.bikedemand, newdata = final_result_df_test[,-1])

## To check R2 to look model fitness on the training data on boosting
predicted_value_train_boosting <- predict(boost.bikedemand, newdata = final_result_df_train[,-1])
# Calculate the total sum of squares (SST)
actual_bike_demand_train <- final_result_df_train$bike_demand  # Replace "target_variable" with the actual name of your target variable
mean_bike_demand_train <- mean(final_result_df_train$bike_demand)
SST <- sum((actual_bike_demand_train - mean_bike_demand_train)^2)
# Calculate the sum of squares of residuals (SSE)
SSE <- sum((actual_bike_demand_train - predicted_value_train_boosting)^2)
# Calculate R-squared (R2)
R2 <- 1 - (SSE / SST)
R2

RMSE(predictions_boosting,final_result_df_test$bike_demand)
MAE(predictions_boosting,final_result_df_test$bike_demand)
