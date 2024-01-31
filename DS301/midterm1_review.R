#Neha Maddali Midterm 1 Review
#DS301

####################
#### Homework 1 ####
####################
library(ISLR2)
head(College)
str(College) #check observations and variables
College[278,] #extract row 278 from dataset
model2 = lm(Grad.Rate~S.F.Ratio, data=College)
model2$coefficients
plot(College$Grad.Rate ~ College$S.F.Ratio, xlab = "student-to-faculty-ratio", 
     ylab="graduation rate") #plot the model
abline(reg=lm(College$Grad.Rate ~ College$S.F.Ratio)) #least squares line
head(model2$residuals) #residuals ei
head(model2$fitted.values) #fitted values y hat i

x <- data.frame(S.F.Ratio=10) #find prediction when S.F.Ration is 10
predict(model2,newdata=x)

#find prediction accuracy of model on data it has never seen before
set.seed(100)
n = nrow(College)
train_index = sample(1:n,n/2,rep=FALSE)
train_College = College[train_index,]
test_College = College[-train_index,]

model_train = lm(College$Grad.Rate ~ College$S.F.Ratio,data=train_College)
MSE_train = mean((train_College$Grad.Rate - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_College)
MSE_test = mean((test_College$Grad.Rate - predicted_values)^2)
MSE_test

#Generate 100 observations Yi using the true population regression line
#Yi = 2 + 3*X1i + 5*log(X2i) + ei (i = 1, . . . , n), ei ??? N (0, 1^2)
X1 = seq(0,10,length.out =100) #generates 100 equally spaced values from 0 to 10.
X2 = runif(100) #generates 100 uniform values.
n = 100
beta_0 = 2
beta_1 = 3
beta_2 = 5
error = rnorm(n,0,1)
Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
Y
plot(X1, Y)
plot(X2, Y)

#simple simulation to show that ??^1 and ??^2 is an unbiased estimator of ??
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
  fit = lm(Y~X1 + log(X2))
  beta1hat[i] = fit$coefficients[[2]]
  beta2hat[i] = fit$coefficients[[3]]
}
beta1hat[i]
beta2hat[i]

hist(beta1hat)
abline(v=beta_1, col="blue")
hist(beta2hat)
abline(v=beta_2, col="blue")

####################
#### Homework 2 ####
####################
set.seed(2)
x = matrix(NA,1000,200)
n=1000
beta_0 = 0
beta_1 = 1
beta_2 = 2
beta_3 = 3
beta_4 = 4
beta_5 = 5
error = rnorm(n,0,1)

#Fit a MLR model on all 200 predictors and report the number of individual t-tests 
#that are significant at ?? = 0.05
for(i in 1:200){
  x[,i] = rnorm(1000)
}
Y = beta_0 + beta_1*x[,1] + beta_2*x[,2] + beta_3*x[,3] + beta_4*x[,4] + beta_5*x[,5] + error
data = as.data.frame(cbind(Y,x))

fit = lm(Y~.,data=data)
summary(fit)
p_values = summary(fit)$coefficients[,4]  
length(which(p_values<0.05))

####################
#### Homework 3 ####
####################
patient = read.table("/Users/neham/Desktop/DS301/patient.txt",header=FALSE) #import txt
names(patient) = c("satisf","age","severe","anxiety") #name columns in txt file
head(patient) # check to make sure the data was read in correctly

model1=lm(satisf~age+severe+anxiety,data=patient) #MLR model (or satisf~.,data=patient)
summary(model1) #can prove if at least 1 predictor has relationship w/ Y by f-stat
deviance(model1) #residual sum of squares
null = lm(satisf~1, data = patient) #model with no predictors

#Choose one regression coefficient and test whether it is zero or not at ?? = 0.05
ts = (-1.1416)/0.2148 #test statistic = coefficient estimate / standard error
pt(abs(ts), 42, lower.tail=FALSE)*2 #p-value (can be found from summary itself)

#obtain an estimate w/ new data on model1
age_new =c(77)
severe_new=c(68)
anxiety_new=c(3)
new_data = data.frame(age=age_new,severe=severe_new,anxiety=anxiety_new)
#predict Y and quantify uncertainty surrounding this estimate
predict(model1,newdata=new_data,interval='confidence',level=0.95)

sum(model1$residual^2)/(46-(3+1)) #estimate for ??^2 (46 = observations, 3 = predictors)

contrasts(Carseats$ShelveLoc) #Interpret qualitative predictor regression coefficients

x = data.frame(CompPrice = mean(Carseats$CompPrice),Income=median(Carseats$Income), 
               Advertising = 15, Population = 500, Price = 50, ShelveLoc = "Good", 
               Age = 30, Education = 10, Urban = "Yes", US="Yes")
#prediction for Y given these predictors (reducible error)
predict(modelCar,newdata=x,interval='confidence',level=0.99) 
#estimate for f(X) given these predictors (reducible + irreducible error)
predict(modelCar,newdata=x,interval='prediction',level=0.99)

####################
#### Homework 4 ####
####################
insurance = read.csv("/Users/neham/Desktop/DS301/insurance.csv")
insurance$gender <- factor(insurance$gender)
insurance$smoker <- as.factor(insurance$smoker)
insurance$region <- as.factor(insurance$region)
fit=lm(charges~age+bmi+gender,data=insurance) #SHOULD CREATE DUMMY VARIABLE FOR GENDER
summary(fit)

#fit a model for only those observations that are males and only those observations 
#that are female (NO DUMMY VARIABLES)
males=insurance[insurance$gender=="male",]
fit_males = lm(charges~bmi+age, data=males)
females=insurance[insurance$gender=="female",]
fit_females = lm(charges~bmi+age, data=females)

#generate your predictors with multicollinearity
n=100
beta_0 = 3
beta_1 = 2
beta_2 = 4
set.seed(42)
x1 = runif(100)
x2 = 0.8*x1 + rnorm(100,0,0.1)
error = rnorm(n,0,2)
Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
cor(x1,x2) #Check the correlation between x1 and x2

#Split your data into a training set and test set
data = data.frame(Y,x1,x2)
train_index = sample(1:n, n/2, rep=FALSE)
train = data[train_index,]
test = data[-train_index,]
model_train = lm(Y~x1+x2, data=train)
predicted_values = predict(model_train,test)
MSE_test = mean((test$Y - predicted_values)^2)
MSE_test

#Repeat this process 2,500 times
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

#generate predictors without multicollinearity
set.seed(24)
x1 = runif(100)
x2 = rnorm(100,0,1)
error = rnorm(100,0,2)
Y = beta_0 + beta_1*x1 + beta_2*x2 + error 
cor(x1,x2)

# run 2,500 simulations to get test MSE of model when predictors are not correlated
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

#MLR w/ mpg as the response and all other variables except name as the predictors
library(ISLR2)
head(Auto)
plot(Auto)
model = lm(mpg ~ . - name, data = Auto)
summary(model)

#Is multicollinearity an issue in our model?
par(mfrow=c(2,2))
plot(model)
library(car)
vif(model) #any predictor with a VIF score greater than 10 indicates a problem

#Propose + implement transformations on the variables, check if they improve model.
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

