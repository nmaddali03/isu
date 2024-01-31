library(ISLR2)
fit = lm(medv~lstat+ crim, data=Boston)
summary(fit)
names(fit)

## hypothesis test: 
#H0: beta1 = 1 vs. H1: beta1 not equal 1. 
#ts = (-0.91139-1)/0.04339
#null distribution = t distribution with 506 - 2 +1 = 503 df 
#p-value: 
pt(abs(ts),503,lower.tail=FALSE)*2 # two-sided
pt(abs(ts),df,lower.tail=FALSE) # one-sided 

# What is the difference between fit$fitted.values and predict(fit)?
head(fit$fitted.values)
head(predict(fit))

# How do we use predict(fit)?

# Confidence intervals for beta0, beta1, beta2
confint(fit,level=0.99)

# Confidence intervals for E(Y) = f(x)
predict(fit,data.frame(lstat=c(5,10,15),crim=c(0.5,1,1.5)),interval='confidence')

# estimate of sigma^2 (do not confuse this with standard error, 
# sigma^2 represents the variance of Y )
sum(fit$residual^2)/(n-(p+1))

