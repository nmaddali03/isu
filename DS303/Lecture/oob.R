
# ############ OOB error estimation ################
library(randomForest)
library(ISLR2)
# Recall that the key to bagging is that trees are repeatedly fit to bootstrapped subsets of the observations. 

## We showed in a HW assignment, that on average, each bagged tree makes use of what proportion of the original data?

## The remaining unused observations are referred to as the out-of-bag (OOB) observations.
## We can predict the response for the ith observation using each of the trees in which
## that observation was OOB. 
## How many predictions will that yield for the ith observation (on average)?
## Since we have multiple predictions, how do we then obtain a single prediction for the ith observation? 
## This is called our OOB prediction. 

## An OOB prediction can be obtained in this way for each of the n observations. 
## This is called our overall OOB MSE (for regression) or overall OOB misclassification error (for classification).
## Is this a valid estimate of the test error for our bagged model? 

## The OOB approach for estimating the test error is particularly convenient when 
## performing bagging on large data sets for which cross-validation would be computationally onerous.

rf.boston = randomForest(medv ~., data = Boston, mtry = 6, importance = TRUE, ntree = 500, keep.inbag=TRUE)

## how many times did the first observation NOT show up in a tree?
rf.boston$inbag[1,]
table(rf.boston$inbag[1,]==0)

allpred = predict(rf.boston,newdata=Boston,predict.all=TRUE)$individual

n = dim(Boston)[1]

yhat = rep(NA,n)
for(i in 1:n){
  yhat[i] = mean(allpred[i,rf.boston$inbag[i,]==0]) ## OOB prediction
}

mean((yhat-Boston$medv)^2)
#rf.boston$mse[500]


#################################################
#for hw10 problem h.iii
#################################################
allpred = predict(rf_model_carseats, newdata = Carseats, predict.all = TRUE)$individual
n=dim(Carseats)[1]
yhat = rep(NA, n)
for(i in 1:n){
  pred = (allpred[i, rf_model_carseats$inbag[i,]==0])
  sum_yes = length(pred[pred=='Yes'])
  yhat[i] = sum_yes > n/2
}
mean((yhat != Carseats$High)^2)


