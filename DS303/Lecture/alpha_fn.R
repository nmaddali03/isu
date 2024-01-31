############## 2.1 #################
library(glmnet)
n=100
X1 = seq(0,10,length.out =100) #generates 100 equally spaced values from 0 to 10.
X2 = runif(100) #generates 100 uniform values.
beta_0 = 2
beta_1 = 3
beta_2 = 5

x = cbind(X1,X2)
B=100
beta0=beta1=beta2=rep(NA,B)
for (b in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error
  ridge_model = glmnet(x,Y,alpha=0,lambda=2)
  beta0[b] = coef(ridge_model)[1]
  beta1[b] = coef(ridge_model)[2]
  beta2[b] = coef(ridge_model)[3]
}
mean(beta0)-beta_0
mean(beta1)-beta_1
mean(beta2)-beta_2

############## 2.2 #################
alpha.fn <- function(data, index) {
  X <- data$X[index]
  Y <- data$Y[index]
  (var(Y) - cov(X, Y)) / (var(X) + var(Y) - 2 * cov(X, Y))}

## run this on Portfolio data
library(ISLR2)
alpha.fn(Portfolio,1:100)

n=100
B=1000
alpha_boot = rep(NA,B)
for(i in 1:B){
  bootsample = sample(1:n, n, replace=TRUE)
  alpha_boot[i] = alpha.fn(Portfolio[bootsample,],1:100)
}
sqrt(sum((alpha_boot-mean(alpha_boot))^2)/(B-1))