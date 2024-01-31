#Neha Maddali HW11
#DS303
#11/27/23


#########################
## Problem 2: Boosting ##
#########################
################## 2a. ####################
library(ISLR)
library(magrittr)
library(dplyr)
str(Hitters)
Hitters %>%
  filter(!is.na(Salary)) %>%
  mutate(logSalary = log(Salary)) %>%
  select(-Salary) -> Hitters

################## 2b. ####################
train = Hitters[1:200,]
test = Hitters[-(1:200),]

################## 2c. ####################
library(gbm)
library(ISLR2)
library(caret)
set.seed(1)

formula = logSalary ~ .

# Create a grid of tuning parameters
mygrid <- expand.grid(interaction.depth = seq(1, 3, by = 1),
                      n.trees = c(100, 200, 300),
                      shrinkage = c(0.001, 0.01, 0.1),
                      n.minobsinnode = 5)  # Add n.minobsinnode to the grid

# Perform grid search using 10-fold cross-validation
set.seed(100)
gbm_model <- train(formula,
                   data = train,
                   method = "gbm",
                   tuneGrid = mygrid,
                   trControl = trainControl(method = "cv", number = 10))
print(gbm_model)

################## 2d. ####################
optimal_n_trees = gbm_model$bestTune$n.trees
optimal_interaction_depth = gbm_model$bestTune$interaction.depth
optimal_shrinkage = gbm_model$bestTune$shrinkage
set.seed(1)

# Boosting on the training set with optimal parameters
boost_model = gbm(logSalary ~ ., 
                   data = train, 
                   distribution = "gaussian", 
                   n.trees = optimal_n_trees, 
                   interaction.depth = optimal_interaction_depth, 
                   shrinkage = optimal_shrinkage)
summary(boost_model)

################## 2e. ####################
yhat_boost = predict(boost_model, newdata = test, n.trees = optimal_n_trees)
mse_boost = mean((yhat_boost - test$logSalary)^2)

################## 2f. ####################
library(randomForest)
set.seed(1)
m_values = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)
results_table = data.frame(M = numeric(), Mean_CV_Error = numeric())

for (m in m_values) {
  cv_errors = numeric()
  k = 5
  folds = cut(seq(1, nrow(Hitters)), breaks = k, labels = FALSE)
  
  for (i in 1:k) {
    # Create training and validation sets for this fold
    validation_indices = which(folds == i, arr.ind = TRUE)
    validation_set = Hitters[validation_indices, ]
    training_set = Hitters[-validation_indices, ]
    
    rf_model = randomForest(logSalary ~ ., data = training_set, mtry = m, ntree = 500, importance = TRUE)
    rf_pred = predict(rf_model, newdata = validation_set)
    
    cv_errors[i] = mean((rf_pred - validation_set$logSalary)^2)
  }
  mean_cv_error = mean(cv_errors)
  cat("m =", m, ", Mean CV Error =", mean_cv_error, "\n")
  results_table = rbind(results_table, data.frame(M = m, Mean_CV_Error = mean_cv_error))
}
optimal_m = results_table$M[which.min(results_table$Mean_CV_Error)]
optimal_m

# Apply random forest to the training set with the selected optimal_m
rf_model_optimal = randomForest(logSalary ~ ., data = train, mtry = optimal_m, ntree = 500, importance = TRUE)
rf_pred_test = predict(rf_model_optimal, newdata = test)
mse_rf = mean((rf_pred_test - test$logSalary)^2)
mse_rf


##############################
## Problem 3: Bias of Trees ##
##############################
################## 3a. ####################
library(tree)
predicted_values = numeric(1000)
set.seed(1)
num_simulations = 1000

for (iteration in 1:num_simulations) {
  n = 100
  p = 20
  Xmat = matrix(NA, nrow = n, ncol = p)
  
  for (i in 1:p) {
    Xmat[, i] = rnorm(n)
  }
  beta = rep(seq(1, 3, length.out = 5), 4)
  Y = Xmat %*% beta + rnorm(n, 0, 1)
  train_set = data.frame(Xmat, Y)
  
  tree_model = tree(Y ~ ., data = train_set)
  
  # Create a data frame with X values all equal to 1
  new_data = data.frame(matrix(1, nrow = 1, ncol = p))
  names(new_data) = names(train_set)[-length(names(train_set))]  # Exclude the response variable
  
  # Predict for X values all equal to 1
  predicted_value = predict(tree_model, newdata = new_data)
  predicted_values[iteration] <- predicted_value
}
predicted_values[1:5]

################## 3b. ####################
true_value = mean(rep(seq(1, 3, length.out = 5), 4))
bias_squared = mean((predicted_values - true_value)^2)
bias_squared
variance = mean((predicted_values - mean(predicted_values))^2)
variance

################## 3c. ####################
library(randomForest)
rf_predicted_values = numeric(1000)
set.seed(1)
num_trees = 200

for (iteration in 1:num_simulations) {
  n = 100
  p = 20
  Xmat = matrix(NA, nrow = n, ncol = p)
  
  for (i in 1:p) {
    Xmat[, i] = rnorm(n)
  }
  
  beta = rep(seq(1, 3, length.out = 5), 4)
  Y = Xmat %*% beta + rnorm(n, 0, 1)
  train_set = data.frame(Xmat, Y)
  
  # Train random forest
  rf_model = randomForest(Y ~ ., data = train_set, mtry = 10, ntree = num_trees)
  
  # Create a data frame with X values all equal to 1
  new_data = data.frame(matrix(1, nrow = 1, ncol = p))
  names(new_data) = names(train_set)[-length(names(train_set))]  # Exclude the response variable
  
  # Predict for X values all equal to 1
  rf_predicted_value = predict(rf_model, newdata = new_data)
  rf_predicted_values[iteration] = rf_predicted_value
}
rf_predicted_values[1:5]

################## 3d. ####################
true_value = mean(rep(seq(1, 3, length.out = 5), 4))
rf_bias_squared = mean((rf_predicted_values - true_value)^2)
rf_bias_squared
rf_variance = mean((rf_predicted_values - mean(rf_predicted_values))^2)
rf_variance

################## 3e. ####################
change_in_order_of_magnitude_bias = log10(rf_bias_squared / bias_squared)
change_in_order_of_magnitude_bias

################## 3f. ####################
change_in_order_of_magnitude_variance <- log10(rf_variance / variance)
change_in_order_of_magnitude_variance


######################################
## Problem 4: Understanding K-Means ##
######################################
################## 4c.i. ####################
x = cbind(c(1, 1, 0, 5, 6, 4), c(4, 3, 4, 1, 2, 0))
plot(x[,1], x[,2])

################## 4c.ii. ####################
set.seed(1)
labels = sample(2, nrow(x), replace = T)
labels
plot(x[, 1], x[, 2], col = (labels + 1), pch = 20, cex = 2)

################## 4c.iii. ####################
centroid1 = c(mean(x[labels == 1, 1]), mean(x[labels == 1, 2]))
centroid2 = c(mean(x[labels == 2, 1]), mean(x[labels == 2, 2]))
plot(x[,1], x[,2], col=(labels + 1), pch = 20, cex = 2)
points(centroid1[1], centroid1[2], col = 2, pch = 4)
points(centroid2[1], centroid2[2], col = 3, pch = 4)

################## 4c.iv. ####################
euclidean_distance <- function(point1, point2) {
  sqrt(sum((point1 - point2)^2))
}

for (i in 1:nrow(x)) {
  distance_to_centroid1 <- euclidean_distance(x[i, ], centroid1)
  distance_to_centroid2 <- euclidean_distance(x[i, ], centroid2)
  
  # Assign the observation to the cluster with the closest centroid
  if (distance_to_centroid1 < distance_to_centroid2) {
    labels[i] <- 1
  } else {
    labels[i] <- 2
  }
}
labels
plot(x[,1], x[,2], col=(labels + 1), pch = 20, cex = 2)
points(centroid1[1], centroid1[2], col = 2, pch = 4)
points(centroid2[1], centroid2[2], col = 3, pch = 4)

################## 4c.v. ####################
centroid1 = c(mean(x[labels == 1, 1]), mean(x[labels == 1, 2]))
centroid2 = c(mean(x[labels == 2, 1]), mean(x[labels == 2, 2]))
plot(x[,1], x[,2], col=(labels + 1), pch = 20, cex = 2)
points(centroid1[1], centroid1[2], col = 2, pch = 4)
points(centroid2[1], centroid2[2], col = 3, pch = 4)

################## 4c.vi. ####################
plot(x[, 1], x[, 2], col=(labels + 1), pch = 20, cex = 2)


###########################
## Problem 5: Dendrogram ##
###########################
################## 5a. ####################
library(tidyverse)
library(ggdendro)
matrix(1:9, ncol = 3) %>%
  dist() %>%
  as.matrix()
q2_dist_vec = c(
  0,      0.3,    0.4,    0.7,
  0.3,    0,      0.5,    0.8,
  0.4,    0.5,    0,      0.45,
  0.7,    0.8,    0.45,   0
)

matrix(q2_dist_vec, ncol = 4) %>%
  as.dist() %>%
  hclust(method='complete') %>%
  ggdendrogram()

################## 5b. ####################
matrix(q2_dist_vec, ncol = 4) %>%
  as.dist() %>%
  hclust(method='single') %>%
  ggdendrogram()