### This file is for calculating bike demand for each cluster region -- training data ###

setwd("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Training and Test Data/Calculations for Cluster Region")

library(sf)
dresden <- st_read("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Training and Test Data/Calculations for Cluster Region/District_polygons.geojson")

# Now load the training data
load("C:/Users/singh/OneDrive/Desktop/Courses - Semester 2 (TU Dresden)/Applications in Data Analytics/Training and Test Data/Calculations for Cluster Region/Training_Data_no_outliers.RData")

# Perform clustering on the data
coord <- st_coordinates(train_sf$geometry)
set.seed(40)
clustering <- kmeans(coord, 100, 150)

# Get center of clusters into sf object
center_df <- as.data.frame(clustering$centers)
center_df_sf <- st_as_sf(center_df, coords = c("X", "Y"), crs = 4326)

# Voronoi diagram 
voronoi <- st_voronoi(x = st_union(center_df_sf))

library(leaflet)
tessellation <- leaflet() %>%
  addProviderTiles(provider = "CartoDB") %>%
  addPolygons(data = dresden, color = "green",
              fill = F, opacity = 1, weight = 0.5) %>%
  addCircles(data = center_df_sf, color = "red") %>%
  addPolygons(data = st_collection_extract(voronoi), 
              color = "blue", opacity = 1, weight = 1, fill = F)

tessellation

# Create a customized dataframe for bike demand
Demand_by_cluster <- data.frame()
Demand_by_cluster[1:100,1] <- 0

# Add cluster polygons from voronoi to a new object
regions <- st_as_sf(st_collection_extract(voronoi[1]), crs=4326)

# Adding region POLYGON list as a column
for (i in 1:100) {
  Demand_by_cluster[i,2] = regions[i,1]
}

colnames(Demand_by_cluster)[1] = 'Bike Demand'
colnames(Demand_by_cluster)[2] = 'Cluster Region'

# Calculating Bike Demand for each cluster region in the df
for (j in 1:100) {
  Demand_by_cluster[j,1] <- nrow(as.data.frame(st_intersects(train_sf, regions[j,1])))
}

# Saving Bike Demand
Demand_by_cluster_train <- st_as_sf(Demand_by_cluster, crs = 4326)
remove(Demand_by_cluster)
save(Demand_by_cluster_train, file = "Bike_Demand_Training.RData")
