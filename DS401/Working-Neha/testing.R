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

# Filter the dataset for "substance-driving" category
substance_driving_data <- cfs[cfs$category == "Substance-Driving", ]

# Remove unwanted variables
substance_driving_data <- substance_driving_data %>%
  select(-geocoded, -block_group_GEOID, -grid_id, -geometry, -latitude, -longitude)

# Filter out data from 2023
substance_driving_data <- substance_driving_data %>%
  filter(cfs_year < 2023)

# Create a weekday column to differentiate between weekday and weekend
substance_driving_data <- substance_driving_data %>%
  mutate(weekdays = ifelse(cfs_weekday %in% 2:6, "Weekday", "Weekend"))

# Aggregate the data to predict the number of calls in each hour
hourly_calls <- substance_driving_data %>%
  group_by(cfs_year, cfs_month, cfs_weekday, cfs_hour) %>%
  summarise(total_calls = n())

# Split data into training and testing sets
set.seed(123)  # for reproducibility
train_index <- sample(1:nrow(hourly_calls), 0.8 * nrow(hourly_calls))
train_data <- hourly_calls[train_index, ]
test_data <- hourly_calls[-train_index, ]

# Build the random forest model
rf_model <- randomForest(total_calls ~ cfs_year + cfs_month +
                           cfs_weekday + cfs_hour, data = train_data)
rf_model

# Predict on the test set
test_predictions <- predict(rf_model, newdata = test_data)

# Combine actual and predicted values into a dataframe
comparison_data <- data.frame(Date = as.Date(paste(test_data$cfs_year, test_data$cfs_month, "01", sep = "-")),
                              Hour = test_data$cfs_hour,
                              Actual = test_data$total_calls,
                              Predicted = test_predictions)

# Print the comparison data
print(comparison_data)

# Evaluate Test MSE
test_predictions <- predict(rf_model, newdata = test_data)
test_mse <- mean((test_predictions - test_data$total_calls)^2)
print(paste("Test MSE:", test_mse))

#R^2 value
r_squared <- R2(pred = test_predictions, obs = test_data$total_calls)
print(paste("R-squared value:", r_squared))


######################################################################
#testing 4/20/24 tuning grid

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
  select(-geocoded, -block_group_GEOID, -grid_id, -latitude,
         -longitude)
cfs_filtered <- st_drop_geometry(cfs_filtered)

# Convert cfs_date to Date format
cfs_filtered$cfs_date <- as.Date(cfs_filtered$cfs_date)

# Extract day (DD) from cfs_date
cfs_filtered$cfs_day <- day(cfs_filtered$cfs_date)

# Get unique categories
categories <- unique(cfs_filtered$category)

# Filter data for the "Nuisance" category
category_data <- cfs_filtered %>%
  filter(category == "Nuisance")

# Aggregate the data: predicting the number of calls in each hour
hourly_calls <- category_data %>%
  group_by(cfs_year, cfs_month, cfs_weekday, cfs_hour, cfs_type) %>%
  summarise(total_calls = n())

# Split data into training and testing sets
set.seed(123)  # for reproducibility
train_index <- sample(1:nrow(hourly_calls), 0.8 * nrow(hourly_calls))
trainData <- hourly_calls[train_index, ]
testData <- hourly_calls[-train_index, ]

rf_model <- randomForest(total_calls ~ ., data = trainData,
                         mtry = 5, ntree = 500)
predictions <- predict(rf_model, newdata = testData)
testMSE <- mean((predictions - testData$total_calls)^2) # 0.6526939
r2 <- R2(pred = predictions, obs = testData$total_calls) # 0.08342965


# Define a tuning grid with only mtry
tune_grid <- expand.grid(
  mtry = seq(2, ncol(trainData) - 1, by = 2)  # Adjust the step size as needed
)

# Set up control parameters for caret
ctrl <- trainControl(method = "cv", number = 5)  # 5-fold cross-validation

# Tune the random forest model using caret
rf_tune <- train(
  total_calls ~ cfs_year + cfs_month + cfs_weekday + cfs_hour + cfs_type,
  data = trainData,
  method = "rf",
  trControl = ctrl,
  tuneGrid = tune_grid
)

# Get the best model from tuning
best_rf_model <- rf_tune$finalModel

# Print the best tuning parameters
print(best_rf_model)

# Predict on the test set
predictions <- predict(best_rf_model, newdata = testData)

# Evaluate Test MSE
test_mse <- mean((predictions - testData$total_calls)^2)
cat("Test MSE:", test_mse, "\n")

# R^2 value
r_squared <- R2(pred = predictions, obs = testData$total_calls)
cat("R-squared value:", r_squared, "\n")
