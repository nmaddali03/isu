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

## using lags with random forest -- not good model

# Read data
cfs <- read_rds("C:/Users/neham/Desktop/DS401/DS 401 Spring 2024/Source Data/CGC_CFS_2018-2023.rds")

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

complete_data <- expand.grid(days = unique(cfs$cfs_date), hour = 0:23)
complete_data$total_calls = NA

aggregated_cfs <- cfs %>%
  group_by(cfs_date, cfs_hour) %>%
  summarise(total_calls = n())

complete_data$days <- as.Date(complete_data$days)

complete_data$year <- format(complete_data$days, "%Y")

complete_data <- merge(complete_data, aggregated_cfs, by.x = c("days", "hour"), by.y = c("cfs_date", "cfs_hour"), all.x = TRUE)
complete_data <- complete_data[, !(names(complete_data) %in% c("total_calls.x"))]

complete_data$total_calls[is.na(complete_data$total_calls.y)] <- 0

complete_data$total_calls <- ifelse(is.na(complete_data$total_calls.y), 0, 1)

complete_data <- complete_data %>%
  mutate(
    lag1 = lag(total_calls, 25),
    lag7 = lag(total_calls, 169),
    lag52w = lag(total_calls, 8761)
    ## lag 1 day lag 7 days lag 1 year
  )

## 1 means one or more calls during the hour 0 means 0 (total-lag52w)
complete_data <- subset(complete_data, select = -total_calls.y)

## NA values filled with 0 
complete_data[is.na(complete_data)] <- 0
head(complete_data)

# Split data into training and testing sets
set.seed(123)
train_index <- sample(1:nrow(complete_data), 0.8 * nrow(complete_data))
train_data <- complete_data[train_index, ]
test_data <- complete_data[-train_index, ]

rf_model <- randomForest(total_calls ~ lag1 + lag7 + lag52w, data = train_data)
rf_model

# Predict on the test set
predictions <- predict(rf_model, newdata = test_data)

# Combine actual and predicted values into a dataframe
comparison_data <- data.frame(Actual = test_data$total_calls, Predicted = predictions)

# Plot actual versus predicted values
ggplot(comparison_data, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(x = "Actual Number of Calls", y = "Predicted Number of Calls", title = "Actual vs Predicted Number of Calls")

# Evaluate Test MSE
test_mse <- mean((predictions - test_data$total_calls)^2)
print(paste("Test MSE:", test_mse))

# R-squared value
r_squared <- R2(pred = predictions, obs = test_data$total_calls)
print(paste("R-squared value:", r_squared))

# Feature Importance
importance_rf <- importance(rf_model)
print(importance_rf)

# Plot Feature Importance
varImpPlot(rf_model)


# Fit a bagged model
rf_model_bagged <- randomForest(total_calls ~ lag1 + lag7 + lag52w, 
                                data = complete_data, ntree = 500, 
                                keep.inbag = TRUE)

# Calculate out-of-bag (OOB) predictions
all_predictions <- predict(rf_model_bagged, newdata = complete_data, predict.all = TRUE)$individual

# Get the number of observations
n <- nrow(complete_data)

# Calculate OOB predictions
y_hat <- rep(NA, n)
for(i in 1:n) {
  y_hat[i] <- mean(all_predictions[i, rf_model_bagged$inbag[i,] == 0]) ## OOB prediction
}

# Calculate OOB MSE
oob_mse <- mean((y_hat - complete_data$total_calls)^2)
print(paste("OOB MSE:", oob_mse))

# calculate R^2
r_squared_bagged <- R2(pred = y_hat, obs = complete_data$total_calls)
print(paste("Bagged Random Forest R-squared value:", r_squared_bagged))



######################################################################



