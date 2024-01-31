library(MASS)

m1 = lm(medv~lstat,data=Boston)
m5 = lm(medv~poly(lstat,5,raw=TRUE),data=Boston)
m9 = lm(medv~poly(lstat,9,raw=TRUE),data=Boston)

par(mfrow=c(1,1))
plot(medv~lstat,data=Boston)
points(Boston$lstat,m1$fitted.values,col='red')
## m1$fitted values are the predicted values we obtain from the model m1

plot(medv~lstat,data=Boston)
points(Boston$lstat,m5$fitted.values,col='green')
## m5$fitted values are the predicted values we obtain from the model m5

plot(medv~lstat,data=Boston)
points(Boston$lstat,m9$fitted.values,col='blue')
## m9$fitted values are the predicted values we obtain from the model m9

set.seed(13)
n = dim(Boston)[1]
train_index = sample(1:n,n/2,replace=F)
train_boston = Boston[train_index,]
test_boston = Boston[-train_index,]

M1 = lm(medv~lstat,data=train_boston)
M5 = lm(medv~poly(lstat,5,raw=TRUE),data=train_boston)
M9 = lm(medv~poly(lstat,9,raw=TRUE),data=train_boston)

## training MSE from M1
mean((train_boston$medv - M1$fitted.values)^2)

## predicted values from the test set
Yhat_test = predict(M1,newdata=test_boston)
## how do we compute the test MSE from M1? 

###########################
#### In-class Activity ####
###########################

#### fit 9 models of increasing complexity on the training set: 
## M1 = lm(medv~poly(lstat,1,raw=TRUE),data=train_boston)
## M2 = lm(medv~poly(lstat,2,raw=TRUE),data=train_boston)
## M3 = lm(medv~poly(lstat,2,raw=TRUE),data=train_boston)
## ..
## ..
## M9 = lm(medv~poly(lstat,9,raw=TRUE),data=train_boston)

## obtain the training MSE and test MSE for each of these models. 
## Create a plot where the training MSE is on the y-axis and the 
## model complexity (1 - 9) is on the x-axis. 
## Create a similar plot for the test MSE. 


# Create vectors to store training and test MSE values
train_mse <- numeric(9)
test_mse <- numeric(9)

# Loop through different model complexities
for (degree in 1:9) {
  # Fit polynomial regression model
  formula <- as.formula(paste("medv ~ poly(lstat,", degree, ", raw=TRUE)"))
  model <- lm(formula, data = train_boston)
  
  train_pred <- predict(model, newdata = train_boston)
  test_pred <- predict(model, newdata = test_boston)
  
  train_mse[degree] <- mean((train_pred - train_boston$medv)^2)
  test_mse[degree] <- mean((test_pred - test_boston$medv)^2)
}

# Create a plot of training MSE vs. model complexity
plot(1:9, train_mse, type = "b", pch = 19, col = "blue",
     xlab = "Model Complexity", ylab = "Training MSE",
     main = "Training MSE vs. Model Complexity")

# Create a plot of test MSE vs. model complexity
plot(1:9, test_mse, type = "b", pch = 19, col = "red",
     xlab = "Model Complexity", ylab = "Test MSE",
     main = "Test MSE vs. Model Complexity")

## Work in groups to come up with a collective solution. 
## Copy/paste your code and plots into Ed Discussion 
## Please make sure you set.seed(13) so that we all get comparable results!
## Please be sure to list all your group members names so that everyone gets participation credit. 
## Only one group memeber needs to post on Ed Discussion. 

