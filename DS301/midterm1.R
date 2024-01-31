#Neha Maddali Midterm 1
#DS301
#2/28/22

######### 2c. ###########
X1 = seq(0,10,length.out=100)
X2 = runif(100,0,2)
n = 100
beta_0 = 2
beta_1 = 3
beta_2 = 4
error = rnorm(n,0,1)
Y = beta_0 + beta_1*X1 + beta_2*X2 + error 

data = data.frame(Y,2,1)
train_index = sample(1:n, n/2, rep=FALSE)
train = data[train_index,]
test = data[-train_index,]
model_train = lm(Y~X1+X2, data=train)
mean(predict(model_train,test))
#MSE_test = mean((test$Y - predicted_values)^2)

######### 2d. ###########
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
Yhat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*X2 + error 
  data = data.frame(Y,2,1)
  train = data[train_index,]
  test = data[-train_index,]
  model_train = lm(Y ~ X1+X2, data = train)
  predicted_values = predict(model_train,test)
  Yhat[i] = predicted_values
}
mean(Yhat)

######### 2e. ###########
hist(Yhat)
abline(v=mean(Yhat), col="blue")

######### 2f. ###########
predict(model_train,test,interval='prediction',level=0.05)

######### 3a. ###########
library(ISLR2)
head(College)
model = lm(Grad.Rate~., data=College)
summary(model)

######### 3d. ###########
sum(model$residual^2)/(777-(18+1))
