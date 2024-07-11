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
  group_by(cfs_year, cfs_month, cfs_day, cfs_hour, cfs_type) %>%
  summarise(total_calls = n())


####### testing correlation coefficients ######
# Aggregate the data: predicting the number of calls in each hour
hourly_calls <- category_data %>%
  +     group_by(cfs_year, cfs_month, cfs_day, cfs_hour, cfs_type, cfs_weekday, cfs_minute, jurisdiction, weekdays) %>%
  +     summarise(total_calls = n())
# Compute correlation matrix
correlation_matrix <- cor(hourly_calls[, c("total_calls", "cfs_hour", "cfs_month", "cfs_day", "cfs_year", "cfs_weekday", "cfs_minute")])
# Sort correlations with total_calls
sorted_correlations <- sort(correlation_matrix["total_calls", ], decreasing = TRUE)
print(sorted_correlations)

# cfs_hour seems to be the only positively correlated variable with total_calls
##############################################


# 1. Split the Data
set.seed(123)  # For reproducibility
train_index <- sample(1:nrow(hourly_calls), 0.7 * nrow(hourly_calls))
train_data <- hourly_calls[train_index, ]
test_data <- hourly_calls[-train_index, ]

# 2. Build the Random Forest Model
set.seed(123)  # For reproducibility
rf_model <- randomForest(total_calls ~ cfs_type + cfs_year + cfs_month + cfs_hour + cfs_day, data = train_data)
rf_model

# 3. Evaluate the Model
# Make predictions on the test data
predictions <- predict(rf_model, newdata = test_data)
# Calculate mean absolute error (MAE)
mae <- mean(abs(predictions - test_data$total_calls))
mae
# Calculate mean squared error (MSE)
mse <- mean((predictions - test_data$total_calls)^2)
mse
# Calculate R-squared
r_squared <- cor(predictions, test_data$total_calls)^2
r_squared
# Calculate Pearson's correlation coefficient
correlation <- cor(predictions, test_data$total_calls)

# 4. Hyperparameter Tuning with Cross-Validation
set.seed(123)  # For reproducibility
# Define a grid of hyperparameters to search over
grid <- expand.grid(mtry = c(1, 2, 3, 4))
# Perform cross-validation with different hyperparameter combinations
rf_cv <- train(total_calls ~ cfs_type + cfs_year + cfs_month + cfs_hour + cfs_day,
               data = train_data,
               method = "rf",
               tuneGrid = grid,
               trControl = trainControl(method = "cv", number = 5))
# Get the best hyperparameters
best_mtry <- rf_cv$bestTune$mtry
cat("Best mtry:", best_mtry, "\n")

# 5. Build the Random Forest Model with Best Hyperparameters
set.seed(123)  # For reproducibility
# Fix the number of trees (ntree) to a reasonable value
ntree <- 500
rf_model_tuned <- randomForest(total_calls ~ cfs_type + cfs_year + cfs_month + cfs_hour + cfs_day,
                               data = train_data,
                               mtry = best_mtry,
                               ntree = ntree)
rf_model_tuned

# 6. Evaluate the Tuned Model
# Make predictions on the test data
predictions_tuned <- predict(rf_model_tuned, newdata = test_data)
# Calculate mean absolute error (MAE)
mae_tuned <- mean(abs(predictions_tuned - test_data$total_calls))
mae_tuned
# Calculate mean squared error (MSE)
mse_tuned <- mean((predictions_tuned - test_data$total_calls)^2)
mse_tuned
# Calculate R-squared
r_squared_tuned <- cor(predictions_tuned, test_data$total_calls)^2
r_squared_tuned
# Calculate Pearson's correlation coefficient
correlation_tuned <- cor(predictions_tuned, test_data$total_calls)

# 7. Apply Bagging to the Random Forest Model
set.seed(123)  # For reproducibility
bagged_rf_model <- randomForest(total_calls ~ cfs_type + cfs_year + cfs_month + cfs_hour + cfs_day,
                                data = train_data,
                                mtry = best_mtry,
                                ntree = ntree,
                                importance = TRUE,
                                keep.forest = TRUE,
                                keep.inbag = TRUE)

# Make predictions on the test data using bagged model
predictions_bagged <- predict(bagged_rf_model, newdata = test_data)
# Calculate mean absolute error (MAE) for bagged model
mae_bagged <- mean(abs(predictions_bagged - test_data$total_calls))
mae_bagged
# Calculate mean squared error (MSE) for bagged model
mse_bagged <- mean((predictions_bagged - test_data$total_calls)^2)
mse_bagged
# Calculate R-squared for bagged model
r_squared_bagged <- cor(predictions_bagged, test_data$total_calls)^2
r_squared_bagged
# Calculate Pearson's correlation coefficient for bagged model
correlation_bagged <- cor(predictions_bagged, test_data$total_calls)

# Calculate OOB error for bagged_rf_model
oob_predictions <- predict(bagged_rf_model, newdata = train_data, predict.all = TRUE)$individual

# Initialize a vector to store OOB predictions
oob_pred <- rep(NA, nrow(train_data))

# Loop over each observation
for (i in 1:nrow(train_data)) {
  # Extract predictions for observations not in the bag
  oob_pred[i] <- names(table(oob_predictions[i, bagged_rf_model$inbag[i,] == 0]))[which.max(table(oob_predictions[i, bagged_rf_model$inbag[i,] == 0]))]
}

oob_error <- mean(oob_pred != train_data$total_calls)
cat("Out-of-Bag (OOB) Error:", oob_error, "\n")

#################################################################################
# Variable Importance Plot
varImpPlot(rf_model_tuned, main = "Variable Importance Plot")



# run the model on theft/shoplifting
# run the model on hit and run collisions
