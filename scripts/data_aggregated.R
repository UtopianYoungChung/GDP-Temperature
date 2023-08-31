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
location_climQC <- paste0(location, "inputs/data/climate_data/Quebec/")

### Read and merge datasets ###
dataset_1 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_1_10000.csv"), 
                      na="######", show_col_types = FALSE)
dataset_2 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_10001_20000.csv"), 
                      na="######", show_col_types = FALSE)
dataset_3 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_20001_30000.csv"), 
                      na="######", show_col_types = FALSE)
dataset_4 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_30001_40000.csv"), 
                      na="######", show_col_types = FALSE)
dataset_5 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_40001_50000.csv"), 
                      na="######", show_col_types = FALSE)
dataset_6 <- read_csv(paste0(location_climQC, "ahccd-monthly_QB_50001_54864.csv"), 
                      na="######", show_col_types = FALSE)

dataset_6$station_id__id_station <- as.character(dataset_6$station_id__id_station)
clim_QC <- bind_rows(dataset_1, dataset_2, dataset_3, dataset_4, dataset_5, dataset_6)

### Remove some columns ###
clim_QC <- clim_QC %>% 
  select(-`x`, -`y`, -`identifier__identifiant`, -`period_value__valeur_periode`, 
         -`period_group__groupe_periode`, -`province__province`,  
         -`temp_mean_units__temp_moyenne_unites`, -`temp_max_units__temp_max_unites`, 
         -`temp_min_units__temp_min_unites`, -`total_precip_units__precip_totale_unites`, 
         -`rain_units__pluie_unites`, -`snow_units__neige_unites`, 
         -`pressure_sea_level_units__pression_niveau_mer_unite`, 
         -`pressure_station_units__pression_station_unites`, 
         -`wind_speed_units__vitesse_vent_unites`)

### Fix the warning problems ###
clim_QC$date <- as.Date(paste0(clim_QC$date, "-01"))
clim_QC$month <- month(clim_QC$date)
clim_QC$year <- year(clim_QC$date)

problems(clim_QC)
glimpse(clim_QC)

### Check missing values ###
table(clim_QC['year'])

### try mean temp column first ###
temp_missing <- clim_QC %>%
  filter(temp_mean__temp_moyenne == "-9999.9") %>%
  select(station_id__id_station, date, temp_mean__temp_moyenne) %>% glimpse()

### we know that 
### 1. the # of weather stations was reducing
### 2. for the mean temp, there are 3,632 values missing

### Clean the -9999.9 for mean temp column and create the mean tables ###
### create a new temp dataset that without the -9999.9 values ###
temp_without_missing <- clim_QC %>%
  filter(temp_mean__temp_moyenne != "-9999.9")

### group by month & calculate the mean value for each month ###
meantemp_month <- temp_without_missing %>%
  group_by(month,year) %>%
  summarise(mean_temp = mean(temp_mean__temp_moyenne, na.rm = TRUE)) #%>%glimpse() 

### reframe the dataframe ###
meantemp_month_wide <- meantemp_month %>%
  spread(key = month, value = mean_temp)

### save the data to /data folder ###
write.csv(meantemp_month_wide, file = paste0(location_climQC, 
                                             "/meantemp_month.csv"), 
                                             row.names = FALSE)

