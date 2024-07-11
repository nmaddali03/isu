library(readr)
library(sf)
library(lubridate)
library(tigris)
library(leaflet)
library(ggplot2)
library(dplyr)
library(randomForest)
library(caret)
library(tidyr)
library(almanac)

# Read data
cfs <- read_rds("C:/Users/neham/Desktop/DS401/DS 401 Spring 2024/Source Data/CGC_CFS_2018-2023.rds")

# Filter out data from 2023 and remove "Other" category
cfs_filtered <- cfs %>%
  filter(cfs_year < 2023, category != "Other")

# create a weekday column to differentiate between weekday and weekend
cfs_filtered <- cfs_filtered %>%
  mutate(weekdays = ifelse(cfs_weekday %in% 2:6, "Weekday", "Weekend"))

# Remove unwanted variables
cfs_filtered <- cfs_filtered %>%
  select(-geocoded, -block_group_GEOID, -grid_id, -geometry, -latitude,
         -longitude)
cfs <- st_drop_geometry(cfs)

# Convert cfs_date to Date format
cfs_filtered$cfs_date <- as.Date(cfs_filtered$cfs_date)

# Extract day (DD) from cfs_date
cfs_filtered$cfs_day <- day(cfs_filtered$cfs_date)

# Get unique categories
categories <- unique(cfs_filtered$category)

# Create a list to store models and results
model_list <- list()
mse_list <- list()
r_squared_list <- list()


# FOCUS ON big nuisance category (nuisance/noise complaint/....)
# Nuisance: This category contains calls that indicate possible nuisances to neighbors, including disturbances, noise complaints, parties, and disputes.

# Loop over categories
for (category in categories) {
  cat("\n\nCategory:", category, "\n")
  
  # Filter data for the current category
  category_data <- cfs_filtered %>%
    filter(category == !!category)
  
  # Aggregate the data: predicting the number of calls in each hour
  hourly_calls <- category_data %>%
    group_by(cfs_year, cfs_month, cfs_weekday, cfs_hour) %>%
    summarise(total_calls = n())
  
  # Split data into training and testing sets
  set.seed(123)  # for reproducibility
  train_index <- sample(1:nrow(hourly_calls), 0.8 * nrow(hourly_calls))
  train_data <- hourly_calls[train_index, ]
  test_data <- hourly_calls[-train_index, ]
  
  # Build the random forest model
  rf_model <- randomForest(total_calls ~ cfs_year + cfs_month +
                             cfs_weekday + cfs_hour, data = train_data, 
                           mtry = 8, ntree = 500)
  
  # Predict on the test set
  predictions <- predict(rf_model, newdata = test_data)
  
  # Evaluate Test MSE
  test_mse <- mean((predictions - test_data$total_calls)^2)
  cat("Test MSE:", test_mse, "\n")
  
  # R^2 value
  r_squared <- R2(pred = predictions, obs = test_data$total_calls)
  cat("R-squared value:", r_squared, "\n")
  
  # Store model and results
  model_list[[category]] <- rf_model
  mse_list[[category]] <- test_mse
  r_squared_list[[category]] <- r_squared
}

# Print summary of MSE and R-squared for each category
cat("\n\nSummary of MSE and R-squared for each category:\n")
for (category in categories) {
  cat("\nCategory:", category, "\n")
  cat("Test MSE:", mse_list[[category]], "\n")
  cat("R-squared value:", r_squared_list[[category]], "\n")
}
