setwd("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/All Code - Organised")

# Load packages
library(sp)
library(sf)
library(spgwr)

# Load Final Data
load("final_train.RData")
train_summary <- train_summary[,-1]
colnames(train_summary)[6] <- "bike_demand"
train_summary <- subset(train_summary, select=c(6, 1, 2, 3, 4, 5, 7))
train_summary <- train_summary[order(train_summary$bike_demand),]
row.names(train_summary) <- 1:nrow(train_summary)
train_summary <- st_as_sf(train_summary, crs = 4326)
train_summary$cluster_centres <- st_centroid(train_summary$`Cluster Region`)
final_train <- train_summary
remove(train_summary)
final_train <- as.data.frame(final_train)

# Some columns in the data are not numeric
final_train[,3] <- as.numeric(unlist(final_train[,3]))
final_train[,4] <- as.numeric(unlist(final_train[,4]))
final_train[,5] <- as.numeric(unlist(final_train[,5]))
final_train[,6] <- as.numeric(unlist(final_train[,6]))

# Create a vector for cluster centres
cluster_centres <- final_train[,8]
cluster_centres <- st_as_sf(cluster_centres, crs = 4326)

# Redefine final_train dataframe by removing centres
final_train <- final_train[,-8]
final_train <- st_as_sf(final_train, crs = 4326)

# Get Bandwidth for our GWR Model
GWRbandwidth <- gwr.sel(bike_demand ~ f_pop_density + f_ygrp_density + 
                          f_ogrp_density + f_car_density + f_unemployment_density
                          , data = final_train, coords = st_coordinates(cluster_centres)
                          , adapt = T)

# Run GWR
gwr.model <- gwr(bike_demand ~ f_pop_density + f_ygrp_density + 
                   f_ogrp_density + f_car_density + f_unemployment_density,
                data = final_train,
                adapt=GWRbandwidth,
                coords = st_coordinates(cluster_centres),
                hatmatrix=TRUE,
                se.fit=TRUE)

gwr.model

# We see the range of coefficients for each variable. 
# (We need a map to visualize how spatial coefficients vary (for each variable) with space)
results <-as.data.frame(gwr.model$SDF)
names(results)
dresden <- st_read("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Training and Test Data/Calculations for Cluster Region/District_polygons.geojson")
gwr.map <- cbind(final_train, as.matrix(results))
gwr.map2 <- st_as_sf(gwr.map)

# Plot the results on the map

library(ggplot2)
ggplot() +
  geom_sf(
    data = gwr.map2,
    mapping = aes(
      fill = localR2)) +
  theme_minimal() +
  scale_fill_viridis_c()

# We get the results for clusters. Now, we must find the overlapping areas with Dresden.
new_gwr.map2 <- st_intersection(gwr.map2, dresden)

ggplot() +
  geom_sf(
    data = new_gwr.map2,
    mapping = aes(
      fill = localR2)) +
  theme_minimal() +
  scale_fill_viridis_c() # The R2 map for clusters inside Dresden

# We can get the spatial coefficients for each variable

ggplot() +
  geom_sf(
    data = new_gwr.map2,
    mapping = aes(
      fill = f_pop_density.1)) +
  theme_minimal() +
  scale_fill_viridis_c() # varying coefficients for f_pop_density

ggplot() +
  geom_sf(
    data = new_gwr.map2,
    mapping = aes(
      fill = f_unemployment_density.1)) +
  theme_minimal() +
  scale_fill_viridis_c() # varying coefficients for f_unemployment_density

# method for prediction:
        # Get cluster centers for clusters in the test data
        # for a given regression point in training data, use st_intersects() to identify the cluster where this point belongs in the test data
        # Assign the value of the spatial coefficient to clusters in the test data



# Loading test data
load("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Training and Test Data/Final_Data_all_variables_Test.RData")

# Reorder columns to be same as training cols
colnames(final_test)
final_test <- final_test[,-1]
final_test <- final_test[, c(6, 1, 2, 3, 4, 5, 7, 8)]
colnames(final_test)[1] <- "bike_demand"
colnames(final_test)[8] <- "cluster_centres"

# The clusters in test data are outside Dresden. Re-define clusters and re-calculate centroids
library(leaflet)
leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = T, opacity = 0.5, weight = 1) %>%
  addPolygons(data = final_test$`Cluster Region`, color = "purple")

final_test <- final_test[,-8] # cluster centres removed

for(q in 1:100){
final_test$cluster_region[q] <- st_union(st_intersection(final_test$`Cluster Region`[q], dresden))
}

final_test <- st_drop_geometry(final_test)
final_test <- st_as_sf(final_test, crs=4326)

# Now, we want to re-define cluster centres for edited clusters
cluster_centres <- st_centroid(final_test[,7])
cluster_centres <- st_as_sf(cluster_centres, crs = 4326)

leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = T, opacity = 0.5, weight = 1) %>%
  addPolygons(data = final_test$cluster_region, color = "purple") %>%
  addCircles(data = cluster_centres, color = "red")


# Now, we try to check for cluster center in the test data with clusters in the training data
library(leaflet)
leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = T, opacity = 0.5, weight = 1) %>%
  addPolygons(data = final_train$`Cluster Region`[86], color = "purple") %>%
  addCircles(data = cluster_centres[1:3,], color = "red")
# Checking for 1st, 2nd and 3rd cluster center in the test data, cluster 86 is identified as a common cluster

# We want to identify clusters(from training data) that intersect cluster centers from test data(for each center)
cluster_centres$common_cluster_num <- 0
for(i in 1:100){
  cluster_centres$common_cluster_num[i] <- unlist(st_intersects(cluster_centres[i,1], final_train$`Cluster Region`))
}

# Now, we want to make predictions for each cluster center in the test data
cluster_centres$predicted_demand <- 0
for(i in 1:100){
  cluster_centres$predicted_demand[i] <- sum((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],8]) 
                                          , ((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],9])*(as.data.frame(final_test)[i,2]))
                                          , ((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],10])*(as.data.frame(final_test)[i,3]))
                                          , ((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],11])*(as.data.frame(final_test)[i,4]))
                                          , ((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],12])*(as.data.frame(final_test)[i,5]))
                                          , ((as.data.frame(gwr.map2)[as.data.frame(cluster_centres)[i,2],13])*(as.data.frame(final_test)[i,6]))
  )}

# We have both the predicted demand as well as the real bike demand. We would like to know the quality of our predictions
library(Metrics)
rmse(final_test$bike_demand, cluster_centres$predicted_demand)
mae(final_test$bike_demand, cluster_centres$predicted_demand)

# Investigating spatial autocorrelation:
# Creating Rook contiguity based neighbors
library(spdep)
wm_r <- poly2nb(final_train, queen = FALSE)
summary(wm_r)

## define spatial weight matrix
listw <- nb2listw(wm_r)
listw

## Global Moran test
# Perform Moran's I test for the filtered data 
pop_de_moran <- moran.test(final_train$f_pop_density, listw)
ygrp_dens_moran <- moran.test(final_train$f_ygrp_density, listw)
ogrp_dens_moran <- moran.test(final_train$f_ogrp_density, listw)
car_dens_moran <- moran.test(final_train$f_car_density, listw)
unem_de_moran <- moran.test(final_train$f_unemployment_density, listw)
bike_de_moran <- moran.test(final_train$bike_demand, listw)

# Check for Moran Test Statistic
pop_de_moran
ygrp_dens_moran
ogrp_dens_moran
car_dens_moran
unem_de_moran
bike_de_moran

#### Local spatial autocorrelation
# Moran scatterplot
moran.plot(final_train$f_pop_density, listw = nb2listw(wm_r), pch = 19)
moran.plot(final_train$f_ygrp_density, listw = nb2listw(wm_r), pch = 19)
moran.plot(final_train$f_ogrp_density, listw = nb2listw(wm_r), pch = 19)
moran.plot(final_train$f_car_density, listw = nb2listw(wm_r), pch = 19)
moran.plot(final_train$f_unemployment_density, listw = nb2listw(wm_r), pch = 19)
moran.plot(final_train$bike_demand, listw = nb2listw(wm_r), pch = 19)

