#### BOOTSTRAP ###
library(ISLR2)
head(Auto)

### regression
summary(lm(mpg~horsepower,data=Auto))
n = dim(Auto)[1]

## bootstrap standard errors
B = 2000
beta_0 = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample = Auto[index,]
  fit = lm(mpg~horsepower,data=bootsample)
  beta_0[b] = coef(fit)[1]
}

sqrt(sum((beta_0-mean(beta_0))^2)/(B-1))

# compare with analytical formulas
summary(lm(mpg~horsepower,data=Auto))

##bootstrap confidence intervals
beta0_star = summary(lm(mpg~horsepower,data=Auto))$coef[1,1]
se_b0_star = summary(lm(mpg~horsepower,data=Auto))$coef[1,2]

B = 500
m = 100
Fstar = rep(0,B)
beta0_m = rep(0,m)

for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample=Auto[index,]
  fit = lm(mpg~horsepower,data=bootsample)
  beta0 =  coef(fit)[1]
  for(i in 1:m){
    index2 = sample(index,n,replace=TRUE)
    bootsample2 = Auto[index2,]
    fit2 = lm(mpg~horsepower,data=bootsample2)
    beta0_m[i] = coef(fit2)[1]
  }
  se_b0 = sqrt(sum((beta0_m-mean(beta0_m))^2)/(m-1))

  Fstar[b] = (beta0 - beta0_star)/se_b0
  #print(Fstar[b])
}


#95% confidence interval
quantile(Fstar,c(0.025,0.975))
beta0_star + quantile(Fstar,0.025)*se_b0_star
beta0_star + quantile(Fstar,0.975)*se_b0_star

# compare with analytical formulas
confint(lm(mpg~horsepower,data=Auto))

########################
## In-class Activity  ##
########################

## Let's practice bootstrap on the Boston dataset (part of library(ISLR2))
## (1) Based on this data set, provide an estimate for the population mean of medv. Call this muhat.
## (2) Estimate the standard error of muhat using bootstrap.
## (3) Compare this to the standard error of muhat using the analytical formula (the one you've seen in intro stats). 
## How do they compare? 
library(ISLR2)
head(Boston)
n = dim(Boston)[1]
muhat = mean(Boston$medv)
muhat

set.seed(1)

B = 2000
muhat_boot = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  muhat_boot[b] = mean(bootstrap$medv)
}

sqrt(sum((muhat_boot-mean(muhat_boot))^2)/(B-1))

#analytical formula
sd(Boston$medv)/sqrt(n)







## Work in groups to come up with a solution. 
## Copy and paste your relevant code on Ed Discussion. 
## Please be sure to list all your group members names. Only one group member needs to post on Ed Discussion. 
## link: https://edstem.org/us/courses/42400/discussion/
