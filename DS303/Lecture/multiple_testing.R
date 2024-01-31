x = matrix(NA,1000,150)

for(i in 1:150){
  x[,i] = rnorm(1000)
}

y = rnorm(1000)

data = as.data.frame(cbind(y,x))
head(data)

fit = lm(y~.,data=data)
summary(fit)

p_values = summary(fit)$coefficients[,4]  
length(which(p_values<0.05))

########################
## In-class Activity  ##
########################

## Design and implement a simulation study to illustrate the multiple testing problem. 
## Generate 1000 observations for 200 predictors (X1, X2, . . . , X200). 
## Then generate 1000 Y observations such that Y has a relationship with only 5 of the 200 predictors.
## Decide on the values of the parameters and report them 
## You can assume errors ~ N(0,1). 

## Fit a multiple linear regression model on all 200 predictors and report the number of individual t-tests 
## that are significant at α = 0.05. 
## Use this example to explain (in plain language, no statistics terminology), 
## why this is problematic. 
x = matrix(NA,1000,200)

for(i in 1:200){
  x[,i] = rnorm(1000)
}

beta0 = 1
beta1 = 2
beta2 = 3
beta3 = 4
beta4 = 5
beta5 = 6

y = beta0 + beta1*x[,1] + beta2*x[,2] + beta3*x[,3] + beta4*x[,4] + beta5*x[,4] + rnorm(1000)

data = as.data.frame(cbind(y,x))
head(data)

fit = lm(y~.,data=data)
summary(fit)

p_values = summary(fit)$coefficients[,4]  
length(which(p_values<0.05))



## Work in groups to come up with a solution. 
## Copy and paste any relevant code on Ed Discussion. 
## Please be sure to list all your group members names. Only one group member needs to post on Ed Discussion. 
## link: https://edstem.org/us/courses/42400/discussion/
