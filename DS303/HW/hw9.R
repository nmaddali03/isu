#Neha Maddali HW9
#DS303
#11/4/23


#################################################
## Problem 1: MNIST handwritten digit database ##
#################################################
################## 1a. ####################
setwd("C:/Users/neham/Desktop/DS303/HW")
source("C:/Users/neham/Desktop/DS303/HW/mnist_load_script.R", echo=TRUE)
mnist = load_mnist()

library(class)
library(caret)
index.train = sample(1:dim(train$x)[1],3000, replace=FALSE)
index.test = sample(1:dim(test$x)[1],100, replace=FALSE)
train.X = train$x[index.train,]
test.X = test$x[index.test,]
train.Y = train$y[index.train]
test.Y = test$y[index.test]
flds <- createFolds(train.Y, k=10, list=TRUE, returnTrain=FALSE)
names(flds)
K = c(1,5,7,9)
cv_error = matrix(NA,10,4)
for(j in 1:4){
  k=K[j]
  for(i in 1:10){
    test_index = flds[[i]]
    testX = train.X[test_index,]
    trainX = train.X[-test_index,]
    trainY = train.Y[-test_index]
    testY = train.Y[test_index]
    knn.pred = knn(trainX, testX, trainY, k=k)
    cv_error[i,j] = mean(testY!=knn.pred)
  }
}
apply(cv_error, 2, mean)
knn.pred = knn(train.X, test.X, train.Y, k=5)
table(knn.pred, test.Y)
mean(test.Y!=knn.pred)

################## 1b. ####################
library(MASS)
df = cbind(train$y, train$x)
df <- as.data.frame(df)
lda.fit = lda(train$y~train$x, data=df)


##############################
## Problem 2: Fashion MNIST ##
##############################
################## 2a. ####################
setwd("/Users/neham/Desktop/DS303/HW/fashion")
source("/Users/neham/Desktop/DS303/HW/mnist_load_script.R", echo=TRUE)
fashion_mnist = load_mnist()
labels <- paste(train$y[1:5],collapse = ", ")
par(mfrow=c(2,5), mar=c(0.1,0.1,0.1,0.1))
for(i in 1:5) show_digit(train$x[i,], axes=F)

################## 2b. ####################
library(class)
library(caret)
index.train = sample(1:dim(train$x)[1],3000, replace=FALSE)
index.test = sample(1:dim(test$x)[1],100, replace=FALSE)
train.X = train$x[index.train,]
test.X = test$x[index.test,]
train.Y = train$y[index.train]
test.Y = test$y[index.test]
flds <- createFolds(train.Y, k=10, list=TRUE, returnTrain=FALSE)
names(flds)
K = c(1,5,7,9)
cv_error = matrix(NA,10,4)
for(j in 1:4){
  k=K[j]
  for(i in 1:10){
    test_index = flds[[i]]
    testX = train.X[test_index,]
    trainX = train.X[-test_index,]
    trainY = train.Y[-test_index]
    testY = train.Y[test_index]
    knn.pred = knn(trainX, testX, trainY, k=k)
    cv_error[i,j] = mean(testY!=knn.pred)
  }
}
apply(cv_error, 2, mean)
knn.pred = knn(train.X, test.X, train.Y, k=5)
table(knn.pred, test.Y)
mean(test.Y!=knn.pred)


##################################
## Problem 5: Email Spam Part 2 ##
##################################
################## 5b. ####################
library(caret)
spam = read.csv('/Users/neham/Desktop/DS303/HW/spambase.data',header=FALSE)
table(spam['V58'])
set.seed(10)
train_spam = sample(1:nrow(spam),nrow(spam)/2)
train = spam[train_spam,]
test = spam[-train_spam,]
table(train['V58'])
table(test['V58'])
logit_model = glm(V58~., data=test, family=binomial)
summary(logit_model)
probs = predict(logit_model, type="response")
head(probs,10)
preds = rep(0, nrow(test))
preds[probs > .5] = 1
table(preds, test$V58)
1-mean(preds == test$V58)

library(ROCR)
ROCRpred = prediction(probs,test$V58)
plot(performance(ROCRpred,'tpr','fpr'),colorize=TRUE,
     print.cutoffs.at=seq(0,1,by=0.05), text.adj=c(-0.2,1.7))

################## 5c. ####################
table(preds, test$V58)
fp = 89 / (89+1351)
fn = 64 / (64+797)

################## 5d. ####################
preds[probs > 0.15] = 1
table(preds, test$V58)
fp = 16 / (16+1172)
fn = 243 / (243+870)

################## 5e. ####################
library(MASS)
lda_model = lda(V58 ~ ., data = train)
lda_probs = predict(lda_model, newdata = test, type = "response")$posterior[, "1"]
# part b
ROCRpred_lda = prediction(lda_probs, test$V58)
ROCRperf_lda = performance(ROCRpred_lda, "tpr", "fpr")
plot(ROCRperf_lda, colorize = TRUE, print.cutoffs.at = seq(0, 1, by = 0.05), text.adj = c(-0.2, 1.7))

#part c
lda_preds = rep(0, nrow(test))
lda_preds[lda_probs > 0.5] = 1
lda_confusion = table(lda_preds, test$V58)
fp_lda = lda_confusion[2, 1] / sum(lda_confusion[, 1])  # False positive rate
fn_lda = lda_confusion[1, 2] / sum(lda_confusion[, 2])  # False negative rate

#part d
lda_preds = rep(0, nrow(test))
lda_preds[lda_probs > 0.08] = 1
table(lda_preds, test$V58)
fp_lda_adjusted = 25 / (25+918)
fp_lda_adjusted
fn_lda_adjusted = 497 / (497+861)
fn_lda_adjusted

################## 5f. ####################
#QDA
qda_model = qda(V58 ~ ., data = train)
qda_probs = predict(qda_model, newdata = test, type="response")$posterior[, "1"]
qda_preds = rep(0, nrow(test))
qda_preds[qda_probs > 0.08] = 1
qda_confusion = table(qda_preds, test$V58)
qda_confusion[2, 1] / sum(qda_confusion[, 1])  # False positive rate
qda_confusion[1, 2] / sum(qda_confusion[, 2])  # False negative rate

#Naive Bayes
library(e1071)
nb.fit = naiveBayes(V58 ~ ., data = train)
nb.class = predict(nb.fit, test)
table(nb.class, test$V58)
mean(nb.class == test$V58)
44 / (44+812) #false postiive
595 / (595+850) #false negative

#KNN
library(class)
train_scaled <- scale(train[, -58])  # Standardize all predictors except the target variable
test_scaled <- scale(test[, -58])
K_values = c(1, 5, 7, 9)
cv_errors = matrix(NA, nrow = 10, ncol = length(K_values))
flds <- createFolds(train$V58, k = 10, list = TRUE, returnTrain = FALSE)

# Loop through different values of K and perform cross-validation
for (j in 1:length(K_values)) {
  k = K_values[j]
  for (i in 1:10) {
    test_index = flds[[i]]
    testX = train_scaled[test_index, ]
    trainX = train_scaled[-test_index, ]
    trainY = train$V58[-test_index]
    testY = train$V58[test_index]
    
    # Fit the KNN model and make predictions
    knn.pred = knn(trainX, testX, trainY, k = k)
    
    # Calculate and store cross-validation error
    cv_errors[i, j] = mean(testY != knn.pred)
  }
}
mean_cv_errors = apply(cv_errors, 2, mean)
mean_cv_errors

# Choose the K with the lowest mean cross-validation error
best_K = K_values[which.min(mean_cv_errors)]

# Fit the final KNN model with the best K value on the test dataset
final_knn_pred = knn(train_scaled, test_scaled, train$V58, k = best_K)

confusion_matrix = table(final_knn_pred, test$V58)
confusion_matrix
test_error_rate = 1 - sum(diag(confusion_matrix)) / sum(confusion_matrix)
test_error_rate

126 / (126+1245) #fp
162 / (162+768) #fn
