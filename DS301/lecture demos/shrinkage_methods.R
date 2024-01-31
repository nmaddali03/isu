library(ISLR2)

######################
## Ridge Regression ##
######################

## install.packages('glmnet')
library(glmnet)

## This package includes a function called glmnet() 
## Syntax for glmnet() is slightly different from what we've been using so far. 

## glmnet() only takes  numerical, quantitative inputs. 
## we'll use model.matrix() to ensure that all our predictors are numerical. 
Hitters = na.omit(Hitters)
x = model.matrix(Salary~.,data=Hitters)[,-1] 
#the [,-1] removes the intercept term. 
Y = Hitters$Salary

## glmnet() has an alpha argument that determines what type of model is fit. 
## If alpha = 0, then a ridge regression model is fit. 
## If alpha = 1, then a lasso model is fit. 

## First choose a range of lambda values: 

grid = 10^seq(10,-2,length=100)
ridge_model = glmnet(x,Y,alpha=0, lambda=grid)

## Comments: 
## By default the glmnet() function performs ridge regression over a grid of values. 
## We specify those values to be from 10^10 to 10^-2. 

## Also! A nice feature of glmnet() is it automatically standardizes the 
## variables so that they are on the same scale. 
## To turn off this default setting, use the argument `standardize = FALSE` 
## when you call the function. 


## glmnet() will output for you the estimated regression coefficients for each value 
## of lambda.
## You can access them directly by coef().

coef(ridge_model) #20 by 100 matrix (20 rows = one row for each predictor + intercept, 100 colummns = 1 for each value of lambda)
dim(coef(ridge_model)) 

ridge_model$lambda[50]
coef(ridge_model)[,50]
sqrt(sum(coef(ridge_model)[-1,50]^2))


ridge_model$lambda[60]
coef(ridge_model)[,60]

## obtain the ridge regression coefficients for a new value of lambda, say 50: 

predict(ridge_model,s = 50, type = 'coefficients')[1:20,]

################################################# 
###### How to select the tuning parameter?  #####
################################################# 

## Regularized regression can improve our prediction accuracy
## and it's also heavily dependent on our choice of lambda. 
## We usually pick an 'optimal' lambda based on cross-validation 
## (which is only done on training set)

### split into training and testing
set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]

ridge.train = glmnet(x[train,],Y[train],alpha=0,lambda=grid)

### select an optimal lambda 
set.seed(1)
cv.out = cv.glmnet(x[train,],Y[train],alpha = 0, lambda = grid) 
#default performs 10-fold CV, but you can change this using the argument `nfolds` 
plot(cv.out)
bestlambda = cv.out$lambda.min
bestlambda

## what is the test MSE associated with this value of lambda? 
### glmnet() has its own predict() function! This is different than the predict() 
## we are use to using, so the syntax is slightly different. 

ridge.pred = predict(ridge.train,s=bestlambda,newx=x[test,])
mean((ridge.pred-Y.test)^2)

## We can refit the ridge regression model on the full data set, using the value 
## of lambda chosen by cross-validation: 

final = glmnet(x,Y,alpha=0,lambda = bestlambda)
coef(final)

####################################################################### 
## You could repeat all of this for lasso just by setting alpha = 1. ## 
####################################################################### 

cv.out.lasso = cv.glmnet(x[train,],Y[train],alpha = 1, lambda = grid) 
#default performs 10-fold CV, but you can change this using the argument `nfolds` 
plot(cv.out.lasso)
bestlambda2 = cv.out.lasso$lambda.min
bestlambda2

lasso.train = glmnet(x[train,],Y[train],alpha=1,lambda=grid)

which(grid==bestlambda2)
lasso.train$lambda[77]
coef(lasso.train)[,77]

lasso.pred = predict(lasso.train,s=bestlambda2,newx=x[test,])
mean((lasso.pred-Y.test)^2)

final.lasso = glmnet(x,Y,alpha=1,lambda=bestlambda2)
coef(final.lasso)
