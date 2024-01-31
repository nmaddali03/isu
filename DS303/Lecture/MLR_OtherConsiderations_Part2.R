library(ISLR2)
head(Auto)

m1 = lm(mpg~horsepower,data=Auto)
summary(m1)
par(mfrow=c(2,2))
plot(m1)


## non-constant variance
library(MASS)

bc = boxcox(m1)
names(bc)

lambda = bc$x[which.max(bc$y)]
lambda

# y^lambda
# lambda = 0, that means log(y)

m2 = lm(mpg^lambda~horsepower,data=Auto)

# extract only the scale-location residual plot 
par(mfrow=c(1,2))
plot(m1,which=3)
plot(m2, which=3)

# more of an art than a science
m3 = lm(log(mpg)~horsepower,data=Auto)
plot(m3, which=3)



##################################
##### Polynomial Regression ######
##################################
# scatterplot
library(ISLR2)
head(Auto)
plot(Auto$mpg, Auto$horsepower)

plot(m1)

#wrapper 
m_new = lm(mpg~poly(horsepower,2),data=Auto) 
summary(m_new)
par(mfrow=c(2,2))
plot(m_new)

summary(m_new)

#poly() function orthogonalizes the predictors (reduces correlation between predictors)
# orthogonalizing the predictors will not affect your predictions but it does affect
# your ability to directly interpret the coefficients.

###### Wage data set #########
head(Wage)
plot(Wage$age,Wage$wage)

fit = lm(wage ~ poly(age, 4), data = Wage)
summary(fit)

fit2 = lm(wage ~ poly(age, 4, raw=TRUE), data = Wage)
summary(fit2)

# create a grid of age values for which we want to obtain predictions from
agelims = range(Wage$age)
age.grid = seq(from = agelims[1], to = agelims[2])
preds = predict(fit, newdata = list(age = age.grid), interval='confidence', se = TRUE)

plot(Wage$age, Wage$wage, xlim = agelims, cex = .5, col = "darkgrey") 
title("Degree-4 Polynomial", outer = T)
lines(age.grid, preds$fit[,1], lwd = 5, col = "blue", lty = 5)

## how to decide on polynomial degree
## Option 1: use hypothesis tests

fit.1 = lm(wage ~ age, data = Wage)
fit.2 = lm(wage ~ poly(age,2), data = Wage)
fit.3 = lm(wage ~ poly(age,3), data = Wage)
fit.4 = lm(wage ~ poly(age,4), data = Wage)
fit.5 = lm(wage ~ poly(age,5), data = Wage)

anova(fit.1, fit.2, fit.3, fit.4, fit.5)

# Ether a cubic or a quadratic polynomial appear to provide a reasonable fit to the data, but lower- or higher-order models are not justified.

### Option 2: compare training and test MSE 
set.seed(10)
n = dim(Wage)[1]
train_index = sample(1:n,n/2,rep=FALSE)

train_wage = Wage[train_index,]
test_wage = Wage[-train_index,]

fit.1 = lm(wage ~ age, data = train_wage)
fit.2 = lm(wage ~ poly(age,2), data = train_wage)
fit.3 = lm(wage ~ poly(age,3), data = train_wage)
fit.4 = lm(wage ~ poly(age,4), data = train_wage)
fit.5 = lm(wage ~ poly(age,5), data = train_wage)

MSE_train1 = mean((train_wage$wage - fit.1$fitted.values)^2) 
MSE_train2 = mean((train_wage$wage - fit.2$fitted.values)^2) 
MSE_train3 = mean((train_wage$wage - fit.3$fitted.values)^2) 
MSE_train4 = mean((train_wage$wage - fit.4$fitted.values)^2) 
MSE_train5 = mean((train_wage$wage - fit.5$fitted.values)^2) 

plot(c(1:5),c(MSE_train1,MSE_train2,MSE_train3,MSE_train4,MSE_train5),type='b')


## test MSE
test_MSE = rep(NA,11)
for(i in 1:11){
  fit = lm(wage ~ poly(age,i), data = train_wage)
  predicted_values = predict(fit,newdata=test_wage)
  test_MSE[i] = mean((test_wage$wage-predicted_values)^2)
}
