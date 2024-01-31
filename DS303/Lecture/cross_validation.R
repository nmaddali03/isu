library(ISLR2)

################################
### Validation Set Approach ####
################################

# randomly split our data into a training set and testing set
# 50/50 split

head(Auto)
Auto = na.omit(Auto)

n = dim(Auto)[1]

train_index = sample(1:n,n/2,rep=FALSE)

train = Auto[train_index,]
test = Auto[-train_index,]

M1 = lm(mpg~horsepower,data=train)
M2 = lm(mpg~poly(horsepower,2), data=train)

summary(M1)
summary(M2)

## evaluate our model on our test set using predict()

M1_mpg = predict(M1,newdata=test[,-1])
M2_mpg = predict(M2,newdata=test[,-1])

## obtain our test MSE

mean((test$mpg - M1_mpg)^2)
mean((test$mpg - M2_mpg)^2)

# if we had chosen a different training set, 
# we would obtain slightly different errors on the test set.

##############
### LOOCV ###
##############

# There are automated functions in R that do this for you, 
# but they are usually restricted to a class of models.
# It's not so hard to write your own loop to carry out LOOCV:

MSE_M1 = MSE_M2 = rep(0,n)
for(i in 1:n){
  test = Auto[i,]
  train = Auto[-i,]
  
  M1 = lm(mpg~horsepower,data=train)
  M2 = lm(mpg~poly(horsepower,2),data=train)
  
  M1_mpg = predict(M1,newdata=test)
  M2_mpg = predict(M2,newdata=test)
  
  MSE_M1[i] = (test$mpg - M1_mpg)^2
  MSE_M2[i] = (test$mpg - M2_mpg)^2
}


mean(MSE_M1)
mean(MSE_M2)


# linear models, use PRESS
PRESS <- function(model,n) {
    i <- residuals(model)/(1 - lm.influence(model)$hat)
    sum(i^2)/n
}

m1 = lm(mpg~horsepower,data=Auto)
PRESS(m1,n)

m2 = lm(mpg~poly(horsepower,2),data=Auto)
PRESS(m2,n)

#################
### K-fold CV ###
#################

k = 10
folds = sample(1:k,nrow(Auto),replace=TRUE)

#install.packages('caret')
library(caret)
flds <- createFolds(Auto$mpg, k = 10, list = TRUE, returnTrain = FALSE)
names(flds)
flds[[1]]
flds[[2]]

MSE_M1 = MSE_M2 = rep(NA,k)
for(i in 1:k){
  test_index = flds[[i]]
  
  test = Auto[test_index,]
  train = Auto[-test_index,]
  
  M1 = lm(mpg~horsepower,data=train)
  M2 = lm(mpg~poly(horsepower,2),data=train)
  
  M1_mpg = predict(M1,newdata=test[,-1])
  M2_mpg = predict(M2,newdata=test[,-1])
  
  MSE_M1[i]=mean((test$mpg - M1_mpg)^2)
  MSE_M2[i]=mean((test$mpg - M2_mpg)^2)
  
}

