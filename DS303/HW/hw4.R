#Neha Maddali HW4
#DS303
#9/18/23

#Question 1: Best subset selection
################## 1a. ####################
prostate = read.table("/Users/neham/Desktop/DS303/HW/prostate.data",header=TRUE)
library(leaps)
head(prostate)
dim(prostate)
is.na(prostate$lpsa)
sum(is.na(prostate$lpsa))

regfit = regsubsets(lpsa~.,data=prostate,nbest=1,nvmax=9)
regfit.sum = summary(regfit)
regfit.sum
names(regfit.sum)

n = dim(prostate)[1]
p = rowSums(regfit.sum$which)
adjr2 = regfit.sum$adjr2
cp = regfit.sum$cp
rss = regfit.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,adjr2,cp,AIC,BIC)
which.min(BIC)
which.min(AIC)
which.min(cp)
which.max(adjr2)
coef(regfit,5)

################## 1b. ####################
train = subset(prostate,train==TRUE)[,1:9]
test = subset(prostate,train==FALSE)[,1:9]
best.train = regsubsets(lpsa~.,data=train,nbest=1,nvmax=8)

val.errors = rep(NA,8)
for(i in 1:8){
  test.mat = model.matrix(lpsa~.,data=test)
  
  coef.m = coef(best.train,id=i)
  
  pred = test.mat[,names(coef.m)]%*%coef.m
  val.errors[i] = mean((test$lpsa-pred)^2)
}
val.errors
which.min(val.errors)
coef(regfit,3)

################## 1c.i ####################
k = 10
folds = sample(1:k,nrow(prostate),replace=TRUE)
val.errors = matrix(NA,k,8)

## loop over k folds (for j in 1:k)
for(j in 1:k){
  test = prostate[folds==j,]
  train = prostate[folds!=j,]
  
  best.fit = regsubsets(lpsa~.,data=train,nbest=1,nvmax=8)
  
  for(i in 1:8){
    test.mat = model.matrix(lpsa~.,data=test)
    
    coef.m = coef(best.fit,id=i)
    
    pred = test.mat[,names(coef.m)]%*%coef.m
    val.errors[j,i] = mean((test$lpsa-pred)^2)
  }
  
}
cv.errors = apply(val.errors,2,mean)
which.min(cv.errors)

################## 1c.ii ####################
regfit = regsubsets(lpsa~.,data=prostate,nbest=1,nvmax=9)
regfit.sum = summary(regfit)
regfit.sum
names(regfit.sum)

n = dim(prostate)[1]
p = rowSums(regfit.sum$which)
adjr2 = regfit.sum$adjr2
cp = regfit.sum$cp
rss = regfit.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,rss,adjr2,cp,AIC,BIC)
which.min(BIC)
which.min(AIC)
which.min(cp)
which.max(adjr2)
coef(regfit,7)


#Question 2: Simulation Studies
library(MASS)
library(leaps)
################## 2a. ####################
set.seed(1)
p = 20
n = 1000
X = rnorm(1000)
X = matrix(rnorm(1000*20), nrow=1000)
betas = c(5, 1, 6, 3, 9, 2, 0, 0, 0, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
error = rnorm(n,0,1)
Y = X %*% betas + error
# Add a column of 1s to X (for the intercept)
Xmat = cbind(rep(1, n), X)

################## 2b. ####################
train_size = 100  # Size of the training set
test_size = 900   # Size of the test set
index = sample(1:n, train_size)
train_data = data.frame(Y = Y[index], X = X[index, ])
test_data = data.frame(Y = Y[-index], X = X[-index, ])

################## 2c. ####################
regfit = regsubsets(Y~., data=train_data, nbest=1, nvmax=20)
regfit.sum = summary(regfit)
plot(regfit.sum$rss, xlab = "Number of Predictors", ylab = "Training Set MSE")
regfit.sum$rss

################## 2d. ####################
test_mse = rep(NA, 20)
for (i in 1:20) {
  predictors = names(which(coef(regfit, id=i) != 0))[-1]  # Get the predictors for this model
  model_matrix = model.matrix(Y ~ ., data = test_data[, c("Y", predictors)])  # Create the model matrix
  test_preds = model_matrix %*% coef(regfit, id = i)  # Predict on test data
  test_mse[i] = mean((test_data$Y - test_preds)^2)  # Calculate test MSE
}
plot(1:20, test_mse, xlab = "Number of Predictors", ylab = "Test Set MSE")
test_mse

################## 2e. ####################
min_test_mse_index = which.min(test_mse)
min_test_mse = test_mse[min_test_mse_index]
cat("Minimum Test Set MSE:", min_test_mse)
cat("Model Size for Minimum Test Set MSE:", min_test_mse_index)

################## 2f. ####################
best_model_size = which.min(test_mse)
best_model_coefs = coef(regfit, id = best_model_size)
print(best_model_coefs)


#Question 3: Cross-validation
################## 3c. ####################
set.seed(1)
x = rnorm(100)
error = rnorm(100,0,1)
y = x - 2 * x^2 + error

################## 3d. ####################
lm_model <- lm(y ~ x)

# Create a diagnostic plot
par(mfrow = c(2, 2))  # Set up a 2x2 grid of plots
plot(lm_model, pch = 16, col = "blue")  # Residuals vs Fitted plot
abline(h = 0, col = "red")  # Add a horizontal line at y = 0

################## 3e. ####################
set.seed(1)
Data = data.frame(x, y)

PRESS <- function(model,n) {
  i = residuals(model)/(1 - lm.influence(model)$hat)
  sum(i^2)/n
}

m1 = lm(y~x,data=Data)
PRESS(m1,100)
m2 = lm(y~poly(x,2),data=Data)
PRESS(m2,100)
m3 = lm(y~poly(x,3),data=Data)
PRESS(m3,100)
m4 = lm(y~poly(x,4),data=Data)
PRESS(m4,100)

################## 3f. ####################
set.seed(10)
m1 = lm(y~x,data=Data)
PRESS(m1,100)
m2 = lm(y~poly(x,2),data=Data)
PRESS(m2,100)
m3 = lm(y~poly(x,3),data=Data)
PRESS(m3,100)
m4 = lm(y~poly(x,4),data=Data)
PRESS(m4,100)

################## 3h. ####################
summary(m4)