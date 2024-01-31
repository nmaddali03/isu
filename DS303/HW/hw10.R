#Neha Maddali HW9
#DS303
#11/13/23


#########################################
## Problem 2: Basics of Decision Trees ##
#########################################
################## 2a. ####################
library(ISLR)
library(tree)
#set.seed(123)
train = sample(nrow(OJ), 800)
test = -train
train_OJ = OJ[train,]
test_OJ = OJ[test,]
  
################## 2b. ####################
tree_oj = tree(Purchase ~., data = train_OJ)
summary(tree_oj)

################## 2c. ####################
tree_oj

################## 2d. ####################
plot(tree_oj)
text(tree_oj, pretty=0)

################## 2e. ####################
tree_pred = predict(tree_oj, test_OJ, type = "class") 
test_outcome = test_OJ$Purchase
table(test_outcome, tree_pred)
mean(tree_pred != test_outcome)# test error

################## 2f. ####################
#set.seed(1000)
cv_tree_oj = cv.tree(tree_oj,FUN = prune.misclass) 
cv_tree_oj
plot(cv_tree_oj$size, cv_tree_oj$dev, type = "b", xlab = "Tree Size", ylab = "Deviance")

################## 2g. ####################
which.min(cv_tree_oj$size)

################## 2h. ####################
prune_tree_oj = prune.misclass(tree_oj, best = 4)
plot(prune_tree_oj)
text(prune_tree_oj, pretty = 0)

################## 2i. ####################
summary(tree_oj)
summary(prune_tree_oj)

################## 2j. ####################
unpruned_tree_error = mean(tree_pred != test_outcome)
unpruned_tree_error

prune_tree_pred = predict(prune_tree_oj, test_OJ, type = "class")
table(test_OJ$Purchase,prune_tree_pred)
prune_tree_error = mean(prune_tree_pred != test_OJ$Purchase)
prune_tree_error


###########################################
## Problem 3: Bagging and Random Forests ##
###########################################
################## 3a. ####################
library(ISLR)
library(tree)
Carseats$High = factor(ifelse(Carseats$Sales <=8, "No", "Yes"))
set.seed(6)
train = sample(1:nrow(Carseats), 200)
Carseats.test = Carseats[-train, ]

################## 3b. ####################
tree.carseats = tree(High ~ . - Sales, split = c("gini"), data = Carseats, subset = train)
plot(tree.carseats)
text(tree.carseats, pretty = 0)
summary(tree.carseats)

tree.train.pred = predict(tree.carseats, Carseats[train, ], type = 'class')
train_error = mean(tree.train.pred != Carseats$High[train])

tree.test.pred = predict(tree.carseats, Carseats.test, type = 'class')
test_error = mean(tree.test.pred != Carseats.test$High)

################## 3c. ####################
set.seed(7)
cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass)
cv.carseats
plot(cv.carseats$size, cv.carseats$dev, type = "b")
which.min(cv.carseats$dev)
cv.carseats$size[5]

prune.carseats = prune.misclass(tree.carseats, best = 5)
plot(prune.carseats)
text(prune.carseats, pretty = 0)

tree.pred_pruned = predict(prune.carseats, Carseats.test, type = 'class')
test_error_pruned = mean(tree.pred_pruned != Carseats.test$High)

################## 3d. ####################
library(randomForest)
set.seed(1)
bag.carseats = randomForest(High ~ . - Sales, data = Carseats, subset = train, mtry = 10, ntree = 500, importance=TRUE)
rf_pred <- predict(bag.carseats, newdata = Carseats.test)
# Calculate test error
test_error <- mean(rf_pred != Carseats.test$High)

importance(bag.carseats)
varImpPlot(bag.carseats)

################## 3e. ####################
set.seed(1)
m_values = c(1,2,3,4,5,6,7,8,9,10)  # Experiment with different values of m
results_table = data.frame(M = numeric(), Test_Error = numeric())

for (m in m_values) {
  rf_model = randomForest(High ~ . - Sales, data = Carseats, subset = train, mtry = m, ntree = 500, importance = TRUE)
  
  # Make predictions on the test set
  rf_pred = predict(rf_model, newdata = Carseats.test)
  test_error = mean(rf_pred != Carseats.test$High)
  
  cat("m =", m, ", Test Error =", test_error, "\n")
  results_table = rbind(results_table, data.frame(M = m, Test_Error = test_error))
}
print(results_table)

################## 3g. ####################
set.seed(1)
results_table = data.frame(M = numeric(), Mean_CV_Error = numeric())

for (m in m_values) {
  cv_errors = numeric()
  k = 5
  folds = cut(seq(1, nrow(Carseats)), breaks = k, labels = FALSE)
  
  for (i in 1:k) {
    # Create training and validation sets for this fold
    validation_indices <- which(folds == i, arr.ind = TRUE)
    validation_set <- Carseats[validation_indices, ]
    training_set <- Carseats[-validation_indices, ]
    
    rf_model = randomForest(High ~ . - Sales, data = training_set, mtry = m, ntree = 500, importance = TRUE)
    rf_pred = predict(rf_model, newdata = validation_set)
    
    cv_errors[i] = mean(rf_pred != validation_set$High)
  }
  mean_cv_error = mean(cv_errors)
  cat("m =", m, ", Mean CV Error =", mean_cv_error, "\n")
  results_table = rbind(results_table, data.frame(M = m, Mean_CV_Error = mean_cv_error))
}
optimal_m <- results_table$M[which.min(results_table$Mean_CV_Error)]
optimal_m

################## 3h. ####################
set.seed(1)
rf_model_carseats = randomForest(High ~ . - Sales, data = Carseats, mtry = 6, ntree = 500, importance = TRUE, keep.inbag=TRUE)

# i
rf_model_carseats$inbag[4,]
table(rf_model_carseats$inbag[4,] == 0)

# ii
rf_model_carseats$inbag[10,]
pred_10th = predict(rf_model_carseats, newdata = Carseats[10, , drop = FALSE], predict.all = TRUE)$individual
prop_10th = table(pred_10th[rf_model_carseats$inbag[10,] == 0])
prop_10th = prop_10th / sum(prop_10th)
cat("OOB Proportions for Observation 10:\n", prop_10th, "\n")

#iii
all_pred = predict(rf_model_carseats, newdata = Carseats, predict.all = TRUE)$individual
oob_predictions = rep(NA, nrow(Carseats))

for (i in 1:nrow(Carseats)) {
  oob_predictions[i] = names(table(all_pred[i, rf_model_carseats$inbag[i,] == 0]))[which.max(table(all_pred[i, rf_model_carseats$inbag[i,] == 0]))]
}
oob_error = mean(oob_predictions != Carseats$High)
oob_error