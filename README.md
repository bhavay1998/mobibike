# mobibike
Urban Mobility: Prediction of Rentals in Bike Sharing Systems

The project begins with developing an understanding of the distribution of Mobi-bikes in Dresden, for identifying customer active regions and regions of high mobility. With this information, the project proceeds in developing a spatial prediction model to understand the relationship between bike availability (target variable) and spatial variables (feature variables) such as population density, vehicle density, age demographics, etc.

For the purpose of model development, decision trees along with ensemble methods such as bagging and random forests are used. This is contrasted with a custom model that uses Geographically Weighted Regression with Gaussian kernel, to accommodate spatial variation. The motivation of the project is to identify if there is a significant gap in performance between these two approaches. In addition, the aim of Geographically Weighted Regression (GWR) is to understand how relationship between target and feature variables vary spatially.

Result:
GWR has superior prediction performance compared to pruned decision trees, but has remarkably similar performance to ensemble methods such as bagging and random forest. Coefficients determined by GWR model are more interpretable since the relationships captured are not over-generalised. This is because they are captured at a local level.

Note:
This repository provides the project report as well as the code used for the analysis. The code is separated in a stepwise manner for the purpose of organization and comments within the code files largely explain what the code is meant to do. However, the data used in this project is not provided due to confidentiality reasons. The entire project is performed using R.
