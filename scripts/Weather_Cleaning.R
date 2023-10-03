#KNN to find mean temperature, UNFINISH
##############################
library(dplyr)
library(class)
library(readr)

# 写一个function 用KNN clean missing
knn_impute <- function(dataset, latitude, longitude, AA, K) {

  features <- cbind(dataset$latitude, dataset$longitude)
  
  missing_rows <- is.na(dataset$AA)
  known_data <- dataset[!missing_rows, ]
  missing_data <- dataset[missing_rows, ]
  
  if (nrow(missing_data) > 0) {
    #Perform KNN
    imputed_values <- knn(
      train = known_data[, c("latitude", "longitude")],
      test = missing_data[, c("latitude", "longitude")],
      cl = known_data$AA,
      k = K
    )
    
    # Replace missing values in AA with imputed values
    dataset[missing_rows, "AA"] <- imputed_values
  }
  
  return(dataset)
}

#TEST 一下
data <- data.frame(
  A = c(40.71, 41.83, 42.45, 39.93, 39.93),
  B = c(-74.01, -87.63, -71.07, 39.93, -75.82),
  C = c("2022-01", "2022-02", "2022-03", "2022-04", "2022-05"),
  D = c(50, 55, 60, NA, 45)
)



knn_impute(data,data$A,data$B,D,3)




ahccd_monthly_QB_1_10000 <- read_csv("inputs/data/climate_data/Quebec/ahccd-monthly_QB_1_10000.csv")
View(ahccd_monthly_QB_1_10000)

meantemp_month <- read_csv("inputs/data/climate_data/Quebec/meantemp_month.csv")
View(meantemp_month)
