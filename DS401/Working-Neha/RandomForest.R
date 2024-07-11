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

# not included
# Filter the dataset for "substance-driving" category
substance_driving_types <- cfs$cfs_type[cfs$category == "Substance-Driving"]
unique_types_substance_driving <- unique(substance_driving_types)
print(unique_types_substance_driving)

# Filter out data from 2023
cfs <- cfs %>%
  filter(cfs_year < 2023)

# create a weekday column to differentiate between weekday and weekend
cfs <- cfs %>%
  mutate(weekdays = ifelse(cfs_weekday %in% 2:6, "Weekday", "Weekend"))

# Remove unwanted variables
cfs <- cfs %>%
  select(-geocoded, -block_group_GEOID, -grid_id, -geometry, -latitude,
         -longitude)

cfs$cfs_date <- as.Date(cfs$cfs_date)
# Extract day (DD) from cfs_date
cfs$cfs_day <- day(cfs$cfs_date)

# aggregate the data
# predicting the number of calls in each hour
hourly_calls <- cfs %>%
  group_by(cfs_year, cfs_month, cfs_day, cfs_weekday, cfs_hour) %>%
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
predictions <- predict(rf_model, newdata = test_data)

# Combine actual and predicted values into a dataframe
comparison_data <- data.frame(Actual = test_data$total_calls, Predicted = predictions)
comparison_data <- data.frame(Date = as.Date(paste(test_data$cfs_year, test_data$cfs_month, test_data$cfs_day, sep = "-")),
                              Weekday = test_data$cfs_weekday,
                              Hour = test_data$cfs_hour,
                              Actual = test_data$total_calls,
                              Predicted = predictions)

# Plot actual versus predicted values
ggplot(comparison_data, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +  # Add a line of equality
  labs(x = "Actual Number of Calls", y = "Predicted Number of Calls", title = "Actual vs Predicted Number of Calls")

# Evaluate Test MSE
test_predictions <- predict(rf_model, newdata = test_data)
test_mse <- mean((test_predictions - test_data$total_calls)^2)
print(paste("Test MSE:", test_mse))

#R^2 value
r_squared <- R2(pred = predictions, obs = test_data$total_calls)
print(paste("R-squared value:", r_squared))

# Feature Importance
importance_rf <- importance(rf_model)
print(importance_rf)

# Plot Feature Importance
varImpPlot(rf_model)


##########################################################################
# cross validation
# Define the number of folds
num_folds <- 5

# Create folds
folds <- createFolds(hourly_calls$total_calls, k = num_folds)

# Initialize variables to store predictions and MSE
cv_predictions <- numeric(nrow(hourly_calls))
cv_mse <- numeric(num_folds)

# Perform cross-validation
for (i in 1:num_folds) {
  # Get the indices for training and testing sets for this fold
  test_indices <- folds[[i]]
  train_indices <- setdiff(seq_len(nrow(hourly_calls)), test_indices)

  # Create training and testing sets for this fold
  train_fold <- hourly_calls[train_indices, ]
  test_fold <- hourly_calls[test_indices, ]

  # Train the model
  rf_model_fold <- randomForest(total_calls ~ cfs_year + cfs_month + cfs_weekday + cfs_hour,
                                data = train_fold)

  # Predict on the entire dataset for this fold
  predictions_fold <- predict(rf_model_fold, newdata = hourly_calls)
  cv_predictions[test_indices] <- predictions_fold[test_indices]

  # Calculate MSE for this fold
  cv_mse[i] <- mean((predictions_fold[test_indices] - hourly_calls$total_calls[test_indices])^2)
}

# Calculate average MSE across all folds
average_cv_mse <- mean(cv_mse)
print(paste("Cross-validated Average Test MSE:", average_cv_mse))

# Combine actual and predicted values into a dataframe
comparison_data_cv <- data.frame(Actual = hourly_calls$total_calls, Predicted = cv_predictions)

# Plot actual versus predicted values from cross-validation
ggplot(comparison_data_cv, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(x = "Actual Number of Calls", y = "Predicted Number of Calls", title = "Cross-validated Actual vs Predicted Number of Calls")

# R^2
r_squared_cv <- R2(pred = cv_predictions, obs = hourly_calls$total_calls)
print(paste("Cross-validated R-squared value:", r_squared_cv))

# run over specific category of calls

##########################################################################
# Fit a bagged model
rf_model_bagged <- randomForest(total_calls ~ cfs_year + cfs_month + cfs_weekday + cfs_hour, data = hourly_calls, ntree = 500, keep.inbag = TRUE)

# Calculate out-of-bag (OOB) predictions
all_predictions <- predict(rf_model_bagged, newdata = hourly_calls, predict.all = TRUE)$individual

# Get the number of observations
n <- nrow(hourly_calls)

# Calculate OOB predictions
y_hat <- rep(NA, n)
for(i in 1:n) {
  y_hat[i] <- mean(all_predictions[i, rf_model_bagged$inbag[i,] == 0]) ## OOB prediction
}

# Calculate OOB MSE
oob_mse <- mean((y_hat - hourly_calls$total_calls)^2)
print(paste("OOB MSE:", oob_mse))

# calculate R^2
r_squared_bagged <- R2(pred = y_hat, obs = hourly_calls$total_calls)
print(paste("Bagged Random Forest R-squared value:", r_squared_bagged))

##########################################################################
# holidays
# Aggregating the data and grouping by date and hour
aggregated_cfs <- cfs %>%
  group_by(cfs_date, cfs_hour) %>%
  summarise(total_calls = n())

# Adding holiday column
holidays <- cal_events(cal_us_federal(), year = unique(cfs$cfs_year))
holiday_dates <- as.character(holidays$date)

# Mutate holiday column
aggregated_cfs <- aggregated_cfs %>%
  mutate(holiday = ifelse(cfs_date %in% holiday_dates, "Yes", "No"))

# Filter to include only holiday dates
# holiday_aggregated <- aggregated_cfs %>%
#   filter(holiday == "Yes")

View(aggregated_cfs)

# Split data into training and testing sets
set.seed(123)  # for reproducibility
train_index <- sample(1:nrow(aggregated_cfs), 0.8 * nrow(aggregated_cfs))
train_data <- aggregated_cfs[train_index, ]
test_data <- aggregated_cfs[-train_index, ]

# Fit random forest model on training data
rf_model_holiday <- randomForest(total_calls ~ cfs_date + cfs_hour + holiday, data = train_data, ntree = 500)
rf_model_holiday

# Calculate out-of-bag (OOB) predictions on training data
train_predictions <- predict(rf_model_holiday, newdata = train_data, predict.all = TRUE)$individual

# Predict on test set
test_predictions <- predict(rf_model_holiday, newdata = test_data)

# Calculate MSE on test set
test_mse <- mean((test_predictions - test_data$total_calls)^2)
print(paste("MSE for test set:", test_mse))

# Feature Importance
importance_rf <- importance(rf_model_holiday)
print(importance_rf)

# Plot Feature Importance
varImpPlot(rf_model_holiday)

# R^2
r_squared <- R2(pred = test_predictions, obs = test_data$total_calls)
print(paste("R-squared value:", r_squared))



##########################################################################







# NOTES FROM MEETING 4/3
# look into the sunset package - from pramit code
# maybe get rid of weekends, other category
     # look at a specific category (focus on call types) and try
     #  predicting number of calls for given category
# look into these specific call types (off premise substance)
     # underage liquor violations
     # public intoxication
     # drug activity and complaints
# look into these specific call types
     # violence

