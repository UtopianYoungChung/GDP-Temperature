########## Data Cleaning ###########

###### Load Packages ######
library(tidyverse)   # for its nice flow.
library(lubridate)   # for handling dates
library(sf)          # for geo manipulations
library(geojsonsf)   # for loading geojson files
library(htmltools)   # for leaflet support
library(leaflet)     # for fancy plots
library(dplyr)
library(readr)

### Set up locations ###
location = paste0(getwd(),"/")
location_gdpForestry <- paste0(location, "inputs/data/GDP/Forestry/")

### Read and merge datasets ###
dataset <- read_csv(paste0(location_gdpForestry, "Data_Full Data_data.csv"), 
                      na="######", show_col_types = FALSE)

### Remove some columns ###
gdp <- dataset %>% 
  select(Category, Year, `Volume (cubic metres) (En) Nulls`)

gdp <- gdp %>%
  filter(`Volume (cubic metres) (En) Nulls` != "NA", Category != 'Other industrial roundwood')

### group by month & calculate the mean value for each month ###
gdp <- gdp %>%
  group_by(Year, Category)


### save the data to /data folder ###
write.csv(gdp, file = paste0(location_gdpForestry, 
          "/gdp.csv"), 
          row.names = FALSE)

