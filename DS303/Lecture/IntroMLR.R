#### Multiple Linear Regression ####

# read in data using table read.table()
# make sure you specify the pathway where you saved the data set
patient = read.table("./patient.txt",header=FALSE)

head(patient) #look at the first few rows of the data, make sure it's been loaded into R correctly

# give each column its variable name
names(patient) = c("satisf","age","severe","anxiety")

head(patient)
str(patient)

pairs(patient) #pairwise scatterplot

# What is the response vector? 
Y = patient$satisf

# number of observations in the data set
n = dim(patient)[1]

# construct our design matrix 
# first column needs to be column of 1's

X = cbind(rep(1,n),patient$age, patient$severe, patient$anxiety) 

# least square estimators 
XtX = t(X)%*%X
b = solve(XtX)%*%t(X)%*%Y

# What is my predicted value for Y? 

Yhat = X%*%b

# use the lm function 
model=lm(satisf~age+severe+anxiety,data=patient)

#shortcut: 
lm(satisf~.,data=patient)

summary(model)
names(model)
model$coefficients
model$residuals
model$fitted.values

#########################################################
######### training and test MSE? ########################
#########################################################
## divide our data into a training set and a test set
set.seed(100)
train_index = sample(1:n,n/2,rep=FALSE)

train_patients = patient[train_index,]
test_patients = patient[-train_index,]

model_train = lm(satisf~age+severe+anxiety,data=train_patients)

MSE_train = mean((train_patients$satisf - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_patients) #first argument is the trained model, second argument is the test set. 
MSE_test = mean((test_patients$satisf - predicted_values)^2)
MSE_test

#########################################################
####### Properties of our linear regression model #######
#########################################################

## let's simulate data where we know the true population regresssion line

## Simple linear regression 
## suppose we have 1 single predictor (X1)
n = 100
beta_0 = 17
beta_1 = 2
X1 = seq(0,10, length.out=n)

## Generate (or sample) Y based on true population regression line
error = rnorm(n,0,1) ## generate 100 error values from normal distribution with mean 0 and sd 1.
Y = beta_0 + beta_1*X1 + error 

length(error)
length(Y)

## Then we use this sample to estimate the least square line. 
## If we were to take a different sample of Y, we would get a different least square line
## and different estimates for beta0 and beta1. Re-run lines 80 - 90 many times to see that the
## estimate coefficients would change. 
lm(Y~X1)

## We hope that over many many many samples, on average, our estimates 
## would exactly equal the truth. This is the idea of an unbiased estimator.
## How can we check this using simulations?  

########################
## In-class Activity  ##
########################

## 1. Design a simulation to check whether or not our least square estimates for beta_0 and beta_1 are unbiased. 
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


## 2. Define the following terms: expected test MSE, training MSE, bias, variance, and irreducible error. 
## Expected Test MSE is the true test MSE of an infinite number of training sets
## Training MSE 


## 3. After finishing HW 1, explain why using many simple linear regression models is not sufficient 
## compared to a multiple linear regression model. Note that fitting a simple linear regression model is computationally
## instantaneous since there are analytical solutions for our least square estimates. 

## Work in groups to come up with a solution. 
## Copy and paste any relevant code on Ed Discussion. 
## Please be sure to list all your group members names. Only one group member needs to post on Ed Discussion. 
## link: https://edstem.org/us/courses/42400/discussion/











