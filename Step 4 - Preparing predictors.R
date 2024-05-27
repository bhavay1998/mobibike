library(sf)
library(readxl)
Population <- read.csv2("Population_Age.csv", header = TRUE, sep = ",", check.names = FALSE, encoding = "UTF-8")
stadtteile <- read.csv2("Stadtteile(1).csv", header = TRUE, check.names = FALSE, encoding = "UTF-8")
stadtteile_sf <- st_read("District_polygons.geojson")
Car_owner <- read_excel("Car owner.xlsx")
unemployment <- read_excel("unemployment.xlsx")

library(tidyr)

# Separate the column into two new columns based on the space character
Population <- separate(Population, `Stadt/Stadtteil Dresden`, into = c("ID", "Stadtteile"), sep = "  ", extra = "drop", fill = "right")
#names(Car_owner)

Car_owner <- separate(Car_owner, `Stadt/Stadtteil\nDresden insgesamt`, into = c("ID", "Stadtteile"), sep = "  ", extra = "drop", fill = "right")
unemployment <- separate(unemployment, `district_name`, into = c("ID", "district_name"), sep = "  ", extra = "drop", fill = "right")

# Separate the column shape into two new columns based on the space character
stadtteile <- separate(stadtteile,`shape`, into = c("SRID", "POLYGON"), sep = ";", extra = "drop", fill = "right")


#class(stadtteile$blocknr)
stadtteile$blocknr <- as.integer(stadtteile$blocknr)
#class(Population$ID)
Population$ID <- as.integer(Population$ID)
#class(Car_owner$ID)
Car_owner$ID <- as.integer(Car_owner$ID)
unemployment$ID <- as.integer(unemployment$ID)


library(dplyr)

#combine the data frame Population and stadtteile to a new data frame, use same ID

stadtteile <- stadtteile %>%
  left_join(Population, by = c("blocknr" = "ID")) %>%
  arrange(blocknr)

stadtteile <- stadtteile %>%
  left_join(Car_owner, by = c("blocknr" = "ID")) %>%
  arrange(blocknr)

stadtteile <- stadtteile %>%
  left_join(unemployment, by = c("blocknr" = "ID")) %>%
  arrange(blocknr)

stadtteile1 <- stadtteile[,c(1,2,4,12,13,14,15,16,17,18,20,35)]

# Load the openxlsx package
#install.packages("openxlsx")
#library(openxlsx)
#write.xlsx(stadtteile1, "statteile1.xlsx")
#stadtteile1 <- read_excel("statteile1.xlsx")
#save(stadtteile1, file = "stadtteile1RData")

#load("stadtteile1RData")
stadtteile1 <- stadtteile1 %>%
  left_join(stadtteile_sf, by = c("bez" = "bez")) %>%
  arrange(bez)

stadtteile1 <- stadtteile1[,c(1,2,3,4,5,6,7,8,9,10,11,12,20)]
colnames(stadtteile1) <- c("blocknr","Stadtteile","flaeche_km2.x", "total_population",
                           "0-5 year","6 - 17 year","18 - 24 year","25 - 44 year","45 - 59 year",
                           "> 60 year" ,"total_car", "people get SGB II","geometry")


stadtteile1$flaeche_km2.x <- as.numeric(stadtteile1$flaeche_km2.x)
stadtteile1$total_population <- as.numeric(stadtteile1$total_population)
stadtteile1$`0-5 year` <- as.numeric(stadtteile1$`0-5 year`)
stadtteile1$`6 - 17 year` <- as.numeric(stadtteile1$`6 - 17 year`)
stadtteile1$`18 - 24 year` <- as.numeric(stadtteile1$`18 - 24 year`)
stadtteile1$`25 - 44 year` <- as.numeric(stadtteile1$`25 - 44 year`)
stadtteile1$`45 - 59 year` <- as.numeric(stadtteile1$`45 - 59 year`)
stadtteile1$`> 60 year` <- as.numeric(stadtteile1$`> 60 year`)
stadtteile1$total_car <- as.numeric(stadtteile1$total_car)
stadtteile1$`people get SGB II` <- as.numeric(stadtteile1$`people get SGB II`)

population_density <-stadtteile1$total_population/stadtteile1$flaeche_km2.x
age_density_0_5 <- stadtteile1$`0-5 year`/stadtteile1$flaeche_km2.x
age_density_6_17 <- stadtteile1$`6 - 17 year`/stadtteile1$flaeche_km2.x
age_density_18_24 <- stadtteile1$`18 - 24 year`/stadtteile1$flaeche_km2.x
age_density_25_44 <- stadtteile1$`25 - 44 year`/stadtteile1$flaeche_km2.x
age_density_45_59 <- stadtteile1$`45 - 59 year`/stadtteile1$flaeche_km2.x
age_density_over_60 <- stadtteile1$`> 60 year`/stadtteile1$flaeche_km2.x
car_density <- stadtteile1$total_car/stadtteile1$flaeche_km2.x
unemployment_density <- stadtteile1$`people get SGB II`/stadtteile1$flaeche_km2.x



# Create a data frame or matrix from the vectors
data_to_bind <- data.frame(
  population_density,
  age_density_0_5,
  age_density_6_17,
  age_density_18_24,
  age_density_25_44,
  age_density_45_59,
  age_density_over_60,
  car_density,
  unemployment_density)

# Now you can use rbind to add the data to stadtteile1
stadtteile1 <- cbind(stadtteile1, data_to_bind)
stadtteile1 <- stadtteile1[,c(1,2,3,4,15,16,17,18,19,20,14,11,21,12,22,13)]
colnames(stadtteile1) <- c("blocknr","Stadtteile","flaeche_km2.x","total_population","0 - 5 age_density",
                           "6 - 17 age_density","18-24 age_density","25-44 age_density","45-59 age_density",
                           ">60 age_density","population_density","total_car","car_density","people get SGB II\r\n",
                           "unemployment_density","geometry")
predictors <- stadtteile1
save(predictors, file = "predictors.RData")