#Neha Maddali HW10
#DS301
#4/27/22

################## 1a. ####################
setwd("C:/Users/neham/Desktop/ISU/DS301")
source("C:/Users/neham/Desktop/ISU/DS301/mnist_load_script.R", echo=TRUE)
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

################## 2a. ####################
setwd("/Users/neham/Desktop/DS301/fashion")
source("/Users/neham/Desktop/DS301/mnist_load_script.R", echo=TRUE)
fashion_mnist = load_mnist()
labels <- paste(train$y[1:5],collapse = ", ")
par(mfrow=c(2,5), mar=c(0.1,0.1,0.1,0.1))
for(i in 1:5) show_digit(train$x[i,], axes=F)

################## 2b. ####################
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

################## 3a. ####################
library(caret)
spam = read.csv('/Users/neham/Desktop/DS301/spambase.data',header=FALSE)
table(spam['V58'])

################## 3b. ####################
set.seed(1)
train_spam = sample(1:nrow(spam),nrow(spam)/2)
train = spam[train_spam,]
test = spam[-train_spam,]
table(train['V58'])
table(test['V58'])
logit_model <- glm(V58~., data=test, family=binomial)
summary(logit_model)
probs = predict(logit_model, type="response")
head(probs,10)
preds = rep(0, nrow(test))
preds[probs > .5] = 1
table(preds, test$V58)
1-mean(preds == test$V58)

library(ROCR)
ROCRpred <- prediction(probs,test$V58)
plot(performance(ROCRpred,'tpr','fpr'),colorize=TRUE,
     print.cutoffs.at=seq(0,1,by=0.05), text.adj=c(-0.2,1.7))

################## 3c. ####################
table(preds, test$V58)
fp = 89 / (89+1351)
fn = 64 / (64+797)

################## 3d. ####################
preds[probs > 0.15] = 1
table(preds, test$V58)
fp = 16 / (16+1172)
fn = 243 / (243+870)
