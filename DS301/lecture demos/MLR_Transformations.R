
###########################
##### Transforming Y ######
###########################

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
plot(m2, which=3)

# more of an art than a science
m3 = lm(log(mpg)~horsepower,data=Auto)
plot(m3, which=3)


##################################
##### Polynomial Regression ######
##################################
# scatterplot
plot(Auto$mpg, Auto$horsepower)

plot(m1)

#wrapper function I()
m_new = lm(mpg~horsepower + I(horsepower^2), data=Auto)
summary(m_new)
par(mfrow=c(2,2))
plot(m_new)


## Use the poly function for higher order terms

m_new2 = lm(mpg~poly(horsepower,2),data=Auto) 

m_new2 = lm(mpg~poly(horsepower,5),data=Auto) 
summary(m_new2)

#poly() function orthogonalizes the predictors (reduces correlation between predictors)
# orthogonalizing the predictors will not affect your predictions but it does affect
# your ability to directly interpret the coefficients.
