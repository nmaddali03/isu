# DS303 Final Exam
# Neha Maddali
# 12/12/2023

#############################
### Part 2: Random Forest ###
#############################
library(randomForest)
library(caret)

############# 2a. ################
heart = read.table('https://hastie.su.domains/ElemStatLearn/datasets/SAheart.data', sep=",",head=T,row.names=1)
set.seed(1)
heart$chd = as.factor(heart$chd)
possible_m = c(2, 3, 4, 5)

train_data = heart[101:nrow(heart), ]
test_data = heart[1:100, ]

cv_error <- function(m) {
  set.seed(1)
  cv_errors <- numeric(5)
  
  for (i in 1:5) {
    # attempt to prevent double dipping
    test_indices <- seq((i - 1) * 20 + 1, i * 20)
    train_fold <- train_data[-test_indices, ]
    test_fold <- train_data[test_indices, ]
    
    rf_model = randomForest(chd ~ ., data=train_fold, mtry=m, ntree=500)
    predictions = predict(rf_model, newdata=test_fold)
    cv_errors[i] = mean(predictions != test_fold$chd)
  }
  return(mean(cv_errors))
}

cv_errors = sapply(possible_m, cv_error)
cv_errors
optimal_m = possible_m[which.min(cv_errors)]
optimal_m

############# 2b. ################
optimal_m = 3

rf_model = randomForest(chd ~ ., data=train_data, mtry=optimal_m, ntree=500)
predictions = predict(rf_model, newdata=test_data)

misclassification_rate = mean(predictions != test_data$chd)
misclassification_rate

############# 2c. ################
rf_model_full = randomForest(chd ~ ., data=heart, mtry=optimal_m, ntree=500, importance=TRUE, keep.inbag=TRUE)
all_pred = predict(rf_model_full, newdata = heart, predict.all = TRUE)$individual

oob_predictions = rep(NA, nrow(heart))
for (i in 1:nrow(heart)) {
  oob_predictions[i] = names(table(all_pred[i, rf_model_full$inbag[i,] == 0]))[which.max(table(all_pred[i, rf_model_full$inbag[i,] == 0]))]
}
oob_error = mean(oob_predictions != heart$chd)
oob_error

############# 2d. ################
observation_2 = heart[2, -ncol(heart)]
probability_Y1 = predict(rf_model_full, newdata=observation_2, type='prob')
probability_Y1

############# 2e. ################
bootstrap_estimates = numeric(1000)
num_trees =  25

for (i in 1:1000) {
  bootstrap_sample = heart[sample(nrow(heart), replace=TRUE), ]
  
  rf_model_bootstrap = randomForest(chd ~ ., data=bootstrap_sample, mtry=optimal_m, ntree=num_trees, importance=TRUE, keep.inbag=TRUE)
  
  observation_2 <- bootstrap_sample[2, -ncol(bootstrap_sample)]
  probability_Y1_bootstrap = predict(rf_model_bootstrap, newdata=observation_2, type='response')
  bootstrap_estimates[i] = probability_Y1_bootstrap
}

se_bootstrap <- sd(bootstrap_estimates)
se_bootstrap