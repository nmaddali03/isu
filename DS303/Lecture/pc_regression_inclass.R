## Principal Components Regression

## involves constructing the first M principal components Z1, Z2, ..., ZM
## and then using the components as the predictors in a linear regression model 
## that is fit using least squares

## key idea: often a small number of principal components suffice to explain most 
## of the variability in the data. 

## if this holds, then fitting a model to Z1, .., Zm should do better than 
## fitting a model directly to X1, .., Xp. Why? 

## How could we choose M? 
## do we need to scale each predictor? 

library(pls)
library(ISLR2)
########################
## In-class Activity  ##
########################
## 1. ## Divide the Hitters dataset into a training and test set using the following code: 
Hitters = na.omit(Hitters)
set.seed(1)
train = sample(1:nrow(Hitters), nrow(Hitters) / 2) 
test = (-train)

# Use pcr() function to fit a principal components regression model on the training dataset. 
## let Salary be the response and all remaining variables be the predictors
## Check the help documentation to make sure you correctly specify the arguments 'scale' and 'validation'

pcr.fit = pcr(Salary~.,data=Hitters[train,], scale=TRUE,validation="CV")

## 2. Look at the summary() of your pcr object. How much variance is explained by the first principal component? 
## How many principal components do we need to use to explain at least 80% of the variance? 
## The function explvar() might also come in handy. 

summary(pcr.fit)
cumsum(explvar(pcr.fit))

## 3. What is the optimal M? Use the following code to plot the cross-validation scores and eyeball it
validationplot(...., val.type = "MSEP")

validationplot(pcr.fit, val.type = "MSEP")
RMSEP(pcr.fit)$val[1,,]

## 4. Evaluate this model (with your optimal M) on your test set. You can use the predict() function: 
predict(..., newdata, ncomp = ...) # where ncomp is your chosen number of principal components

pcr.pred = predict(pcr.fit, Hitters[test,], ncomp = 5)
y.test = Hitters[test,]$Salary
mean((pcr.pred - y.test)^2)

## 5. How does this model's test MSE compare to the test MSE of a least square model using 
## all p predictors? 

ls.fit = lm(Salary~.,data=Hitters[train,])
ls.pred = predict(ls.fit,Hitters[test,])
mean((ls.pred - y.test)^2)





