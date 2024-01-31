#### Multiple Linear Regression ####

# read in data using table read.table()
# make sure you specify the pathway where you saved the data set
patient = read.table("/Users/lchu/GoogleDrive/DS301/Lectures/2-MultipleLinearRegression/patient.txt",header=FALSE)

head(patient) #look at the first few rows of the data, make sure it's been loaded into R correctly

# give each column its variable name
names(patient) = c("satisf","age","severe","anxiety")

head(patient)
str(patient)

pairs(patient) #pairwise scatterplot

# linear regression model
# use the lm function
model=lm(satisf~age+severe+anxiety,data=patient)

#shortcut: 
lm(satisf~.,data=patient)

summary(model)
names(model)
model$coefficients
model$residuals
model$fitted.values

#use this model to predict values of Y
x = data.frame(age=40,severe=40,anxiety=1.5)

predict(model,newdata=x)

#########################################################
## MSE? ################################################
## divide our data into a training set and a test set
set.seed(100)
train_index = sample(1:n,n/2,rep=FALSE)

train_patients = patient[train_index,]
test_patients = patient[-train_index,]

model_train = lm(satisf~age+severe+anxiety,data=train_patients)
MSE_train = mean((train_patients$satisf - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_patients)
MSE_test = mean((test_patients$satisf - predicted_values)^2)
MSE_test

#########################################################
####### Properties of our linear regression model #######
#########################################################

## let's simulate data where we know the true population regresssion line

# simple linear regression 
## suppose we have 1 single predictor (X1)
n = 100
beta_0 = 8
beta_1 = 11
X1 = seq(0,10, length.out=n)

## Generate Y based on true population regression line
## True relationship between X and Y will never change. It represents the population and is the 'truth'.

## Generate a sample of Y based on the the true population regression line.
error = rnorm(n,0,1)
Y = beta_0 + beta_1*X1 + error 

# So if we were to take a different sample, we would get a different least square line
# and different estimates for beta0 and beta1. 
lm(Y~X1)

# We hope that over many many many samples, the average of all the estimates 
# would exactly equal the truth. This is the idea of an unbiased estimator. 
B = 5000
beta0hat = beta1hat = rep(NA,B)
#Yhat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + error 
  fit = lm(Y~X1)
  #Yhat[i] = predict(fit, data.frame(X1=1))
  beta0hat[i] = fit$coefficients[[1]]
  beta1hat[i] = fit$coefficients[[2]]
}
mean(beta0hat)
mean(beta1hat)









