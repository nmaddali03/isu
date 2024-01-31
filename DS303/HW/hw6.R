#Neha Maddali HW6
#DS303
#10/9/23

###############################################
## Problem 1: Follow-up to in-class activity ##
###############################################
################## 1b. ####################
insurance = read.csv("/Users/neham/Desktop/DS303/HW/insurance.csv")
insurance$gender = factor(insurance$gender)

#Part 2 from class
fit = lm(charges~age+bmi+gender,data=insurance)
males: Yhat = -5642.36 + 243.19*age + 327.54*bmi 
females: Yhat = -6986.82 + 243.19*age + 327.54*bmi

#Part 3 from class
males=insurance[insurance$gender=='male',]
females=insurance[insurance$gender=='female',]

fit_males = lm(charges~age+bmi,data=males)
males: Yhat = -8012.79 + 238.63*age + 409.87*bmi

fit_females = lm(charges~age+bmi,data=females)
females: Yhat = -4515.22 + 246.92*age + 241.32*bmi

#Modify part 2 to be exactly like part 3
fit = lm(charges~age+bmi+gender+age*gender+bmi*gender,data=insurance)
males: Yhat = -8012.79 + 238.63*age + 409.87*bmi
females: Yhat = -4515.22 + 246.92*age + 241.32*bmi

################## 1c. ####################
model_no_interaction = lm(charges ~ age + bmi + gender, data = insurance)
performance_no_interaction = summary(model_no_interaction)$r.squared

model_with_interaction = lm(charges ~ age + bmi + gender + age * gender + bmi * gender, data = insurance)
performance_with_interaction = summary(model_with_interaction)$r.squared


#################################################################
## Problem 2: Predictions in the presence of Multicollinearity ##
#################################################################
################## 2b. ####################
n=100
beta_0 = 3
beta_1 = 2
beta_2 = 4
set.seed(42)
x1 = runif(100)
x2 = 0.8*x1 + rnorm(100,0,0.1)

error = rnorm(n,0,2)
Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
Y
cor(x1,x2)

################## 2c. ####################
data = data.frame(Y,x1,x2)
train_index = sample(1:n, n/2, rep=FALSE)
train = data[train_index,]
test = data[-train_index,]
model_train = lm(Y~x1+x2, data=train)
predicted_values = predict(model_train,test)
MSE_test = mean((test$Y - predicted_values)^2)
MSE_test

################## 2d. ####################
B = 2500
MSE = rep(NA,B)
for(i in 1:B){
  error = rnorm(100,0,2)
  Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
  data = data.frame(Y,x1,x2)
  train = data[train_index,]
  test = data[-train_index,]
  model_train = lm(Y ~ x1+x2, data = train)
  MSE_test = mean((test$Y - predicted_values)^2)
  MSE[i] = MSE_test
}
mean(MSE)
hist(MSE)
abline(v=mean(MSE), col="blue", lwd=3)

################## 2e. ####################
set.seed(24)
x1 = runif(100)
x2 = rnorm(100,0,1)
error = rnorm(100,0,2)
Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
Y
cor(x1,x2)

################## 2f. ####################
data = data.frame(Y, x1, x2)
train = data[train_index,]
test = data[-train_index,]
model_train = lm(Y~x1+x2, data=train)
predicted_values = predict(model_train,test)
MSE_test = mean((test$Y - predicted_values)^2)
MSE_test

B = 2500
MSE = rep(NA,B)
for(i in 1:B){
  error = rnorm(100,0,2)
  Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
  data = data.frame(Y,x1,x2)
  train = data[train_index,]
  test = data[-train_index,]
  model_train = lm(Y ~ x1+x2, data = train)
  MSE_test = mean((test$Y - predicted_values)^2)
  MSE[i] = MSE_test
}
mean(MSE)
hist(MSE)
abline(v=mean(MSE), col="blue")


#########################################
### Problem 3: Regularized Regression ###
#########################################
library(ISLR)
library(glmnet)
data(College)
################## 3a. ####################
n=dim(College)[1]
set.seed(12)
train_index = sample(1:n,n/2,replace=F)
train_college = College[train_index,]
test_college = College[-train_index,]

################## 3b. ####################
train_x = model.matrix(Apps~.,data=train_college)[,-1]
train_y = train_college$Apps
grid = 10^seq(10,-2,length=100)
ridge.train=glmnet(train_x, train_y, alpha=0, lambda=grid)

################## 3c. ####################
set.seed(12)
cv.out = cv.glmnet(train_x, train_y, alpha=0, lambda=grid, nfolds=5)
bestlambda = cv.out$lambda.min
bestlambda

final = glmnet(train_x,train_y,alpha=0, nfolds=5, lambda=bestlambda)
coef(final)

################## 3d. ####################
coefficients_final = coef(final)[-1]

# Calculate the L2 norm of the coefficients
l2_norm = sqrt(sum(coefficients_final^2))
print(l2_norm)

################## 3e. ####################
test_x = model.matrix(Apps~., data=test_college)[,-1]
test_y = test_college$Apps
ridge.pred = predict(final, s = bestlambda, newx = test_x)
test_mse = mean((ridge.pred - test_y)^2)
test_mse

################## 3f. ####################
set.seed(12)
lasso.train = glmnet(train_x,train_y, alpha=1, lambda = grid)
cv.out.lasso = cv.glmnet(train_x,train_y, alpha=1, nfolds=5, lambda = grid)
bestlambda2 = cv.out.lasso$lambda.min
bestlambda2

final.lasso = glmnet(train_x,train_y,alpha=1,lambda=bestlambda2)
coef(final.lasso)

################## 3g. ####################
coefficients_final_lasso = coef(final.lasso)[-1]

# Calculate the L1 norm of the coefficients
l1_norm = sum(abs(coefficients_final_lasso))
print(l1_norm)

################## 3h. ####################
lasso.pred = predict(lasso.train, s=bestlambda2, newx=test_x)
mean((lasso.pred-test_y)^2)
