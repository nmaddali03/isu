#Neha Maddali HW4
#DS301
#2/23/22

##################1a.####################
insurance = read.csv("/Users/neham/Desktop/DS301/insurance.csv")

insurance$gender <- factor(insurance$gender)
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)

##################1b.####################
fit=lm(charges~age+bmi+gender,data=insurance)
summary(fit)

##################1d.####################
males=insurance[insurance$gender=="male",]
fit_males = lm(charges~bmi+age, data=males)
summary(fit_males)

females=insurance[insurance$gender=="female",]
fit_females = lm(charges~bmi+age, data=females)
summary(fit_females)

##################2b.####################
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

##################2c.####################
data = data.frame(Y,x1,x2)
train_index = sample(1:n, n/2, rep=FALSE)
train = data[train_index,]
test = data[-train_index,]
model_train = lm(Y~x1+x2, data=train)
predicted_values = predict(model_train,test)
MSE_test = mean((test$Y - predicted_values)^2)
MSE_test

##################2d.####################
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

##################2e.####################
set.seed(24)
x1 = runif(100)
x2 = rnorm(100,0,1)
error = rnorm(100,0,2)
Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
Y
cor(x1,x2)

##################2f.####################
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

##################3a.####################
library(ISLR2)
head(Auto)
plot(Auto)

##################3b.####################
model = lm(mpg ~ . - name, data = Auto)
summary(model)

##################3e.####################
par(mfrow=c(2,2))
plot(model)

library(car)
vif(model)

##################3g.####################
m1 = lm(mpg~horsepower,data=Auto)
summary(m1)
par(mfrow=c(2,2))
plot(m1)

library(MASS)
par(mfrow=c(1,1))
bc = boxcox(m1)
names(bc)
lambda = bc$x[which.max(bc$y)]
lambda

m2 = lm(mpg^lambda~horsepower,data=Auto)
summary(m2)
par(mfrow=c(1,3))
plot(model, which=3)
plot(m2, which=3)

m3 = lm(log(mpg)~horsepower,data=Auto)
summary(m3)
plot(m3, which=3)

plot(Auto$mpg, Auto$horsepower)
plot(m1, which=1)

m_new = lm(log(mpg)~horsepower + I(horsepower^2), data=Auto)
summary(m_new)
par(mfrow=c(2,2))
plot(m_new)

m_new2 = lm(mpg~poly(horsepower,2),data=Auto) 

m_new2 = lm(log(mpg)~poly(horsepower,5)+acceleration+year+poly(displacement,2),data=Auto) 
summary(m_new2)
plot(m_new2)

m_new3 = lm(mpg ~ poly(horsepower, 5)+acceleration, data = Auto)
summary(m_new3)
plot(m_new3)
