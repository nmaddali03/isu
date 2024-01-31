#Neha Maddali HW5
#DS301
#3/9/22

################## 1a. ####################
x1 = rnorm(100)

################## 1b. ####################
error = rnorm(100,0,2)

################## 1c. ####################
#set.seed(1)
b0 = 2
b1 = 3
b2 = 4
b3 = 5
y = b0 + b1*x1 + b2*x1^2 + b3*x1^3 + error

################## 1d. ####################
df = data.frame(y,x1)
n=100
train_index = sample(1:n,n/2,rep=FALSE)
train = df[train_index,]
test = df[-train_index,]

################## 1e. ####################
MSEtrain = MSEtest = rep(NA,10)
for(i in 1:10){
  model_train = lm(y~poly(x1, i), data = train)
  MSE_train = mean((train$y - model_train$fitted.values)^2)
  MSEtrain[i] = MSE_train
  
  predicted_values = predict(model_train, test)
  MSE_test = mean((test$y - predicted_values)^2)
  MSEtest[i] = MSE_test
}

################## 1f. ####################
plot(MSEtrain, type='b')

################## 1g. ####################
plot(MSEtest, type='b')

################## 1h. ####################
b4 = 7
b5 = 8
b6 = 9
b7 = 10
y = b0 + b1*x1 + b2*x1^2 + b3*x1^3 + b4*x1^4 + b5*x1^5 + b6*x1^6 + b7*x1^7+error
df = data.frame(y, x1)
train_index = sample(1:n,n/2,rep=FALSE)
train = df[train_index,]
test = df[-train_index,]
MSEtrain = MSEtest = rep(NA,10)
for(i in 1:10){
  model_train = lm(y~poly(x1, i), data = train)
  MSE_train = mean((train$y - model_train$fitted.values)^2)
  MSEtrain[i] = MSE_train
  predicted_values = predict(model_train, test)
  MSE_test = mean((test$y - predicted_values)^2)
  MSEtest[i] = MSE_test
}
plot(MSEtrain, type='b')
plot(MSEtest, type='b')

################## 2a. ####################
prostate = read.table("/Users/neham/Desktop/DS301/prostate.data",header=TRUE)
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

################## 2b. ####################
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

################## 2c.i ####################
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

################## 2c.ii ####################
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

################## 3c. ####################
set.seed(1)
x = rnorm(100)
error = rnorm(100,0,1)
y = x - 2 * x^2 + error

################## 3d. ####################
set.seed(1)
Data <- data.frame(x, y)

PRESS <- function(model,n) {
  i <- residuals(model)/(1 - lm.influence(model)$hat)
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

################## 3e. ####################
set.seed(10)
m1 = lm(y~x,data=Data)
PRESS(m1,100)
m2 = lm(y~poly(x,2),data=Data)
PRESS(m2,100)
m3 = lm(y~poly(x,3),data=Data)
PRESS(m3,100)
m4 = lm(y~poly(x,4),data=Data)
PRESS(m4,100)

################## 3g. ####################
summary(m4)

  