#Neha Maddali HW7
#DS303
#10/16/23

##############################################
## Problem 2: Regularized Regression Models ##
##############################################
################## 2a. ####################
library(ISLR2)
library(glmnet)
Hitters = na.omit(Hitters)
n = nrow(Hitters) #there are 263 observations
x = model.matrix(Salary ~.,data=Hitters)[,-1] #19 predictors
Y = Hitters$Salary
set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]

################## 2b. ####################
grid = 10^seq(10, -2, length=100)
ridge.train = glmnet(x[train,], Y[train], alpha=0, lambda=grid)
set.seed(1)
cv.out = cv.glmnet(x[train,], Y[train], alpha=0, lambda=grid)
plot(cv.out)
ridgeMin = cv.out$lambda.min
ridgeMin

################## 2c. ####################
ridgelse = cv.out$lambda.1se
ridgelse

################## 2d. ####################
lasso.train = glmnet(x[train,],Y[train],alpha=1, lambda = grid)
set.seed(1)
cv.out.lasso = cv.glmnet(x[train,],Y[train],alpha = 1, lambda = grid) 
plot(cv.out.lasso)
lassoMin = cv.out.lasso$lambda.min
lassoMin

################## 2e. ####################
lassolse = cv.out.lasso$lambda.1se
lassolse

################## 2f. ####################
ridge.min = predict(ridge.train, s=ridgeMin, newx = x[test,])
mean((ridge.min-Y.test)^2)
ridge.lse = predict(ridge.train, s=ridgelse, newx=x[test,])
mean((ridge.lse-Y.test)^2)

lasso.min = predict(lasso.train, s=lassoMin, newx = x[test,])
mean((lasso.min-Y.test)^2)
lasso.lse = predict(lasso.train, s=lassolse, newx = x[test,])
mean((lasso.lse-Y.test)^2)

################## 2g. ####################
coef(glmnet(x,Y,alpha=0, lambda = ridgeMin))
coef(glmnet(x,Y, alpha=0, lambda = ridgelse))
coef(glmnet(x,Y,alpha=1,lambda=lassoMin))
coef(glmnet(x,Y,alpha=1, lambda=lassolse))

################## 2h. ####################
alpha = seq(0.01, 0.99, by=0.01)
cv_error = rep(NA,length(alpha))

for (i in 1:length(alpha)){
  set.seed(1)
  cv_elastic = cv.glmnet(x[train,], Y[train], alpha = alpha[i], lambda=grid)
  cv_error[i] = min(cv_elastic$cvm)
}

best_alpha = alpha[which.min(cv_error)]
best_alpha

## find the optimal lambda with best_alpha
set.seed(1)
elastic_cv = cv.glmnet(x[train,], Y[train], alpha = best_alpha,lambda=grid)
elastic_cv$lambda.min

################## 2i. ####################
enet.train = glmnet(x[train,],Y[train],alpha=best_alpha,lambda=grid)
enet.pred = predict(enet.train,s=elastic_cv$lambda.min,newx=x[test,])
mean((enet.pred-Y.test)^2)

coef(glmnet(x,Y,alpha=best_alpha, lambda = elastic_cv$lambda.min))


##########################
## Problem 3: Bootstrap ##
##########################
############### 3a. ##################
library(ISLR2)
head(Boston)
n=dim(Boston)[1]
muhat = mean(Boston$medv)
muhat

############### 3b. ##################
sd(Boston$medv)/sqrt(n)

############### 3c. ##################
B = 2000
muhat_boot = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  muhat_boot[b] = mean(bootstrap$medv)
}
sqrt(sum((muhat_boot-mean(muhat_boot))^2)/(B-1))

############### 3d. ##################
umed_star = mean(Boston$medv, na.rm=TRUE)
se_umed_star = sqrt(sum((muhat_boot-mean(muhat_boot))^2)/(B-1))
B = 500
m = 100
Fstar = rep(0,B)
umed_m = rep(0,m)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample=Boston[index,]
  mean = mean(bootsample$medv)
  for(i in 1:m){
    index2 = sample(index,n,replace=TRUE)
    bootsample2 = Boston[index2,]
    umed_m[i] = mean(bootsample2$medv)
  }
  se_umed = sqrt(sum((umed_m-mean(umed_m))^2)/(m-1))
  Fstar[b] = (mean - umed_star)/se_umed
}
quantile(Fstar,c(0.025,0.975))
umed_star + quantile(Fstar,0.025)*se_umed_star
umed_star + quantile(Fstar,0.975)*se_umed_star
hist(Fstar)

t.test(Boston$medv)

############### 3e. ##################
muhat_med = median(Boston$medv)
muhat_med

############### 3f. ##################
B = 2000
muhat_med_boot = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  muhat_med_boot[b] = median(bootstrap$medv)
}
sqrt(sum((muhat_med_boot-mean(muhat_med_boot))^2)/(B-1))

############### 3g. ##################
quantile(Boston$medv,0.1)

############### 3h. ##################
B = 2000
ten_medv = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  ten_medv[b] = quantile(bootstrap$medv,0.1)
}
hist(ten_medv)
sqrt(sum((ten_medv-mean(ten_medv))^2)/(B-1))


########################################
## Problem 4: Properties of Bootstrap ##
########################################
############### 4g. ##################
n = 1:100000
plot(n, 1 - (1 - 1/n)^n)

############### 4h. ##################
results <- rep(NA, 10000)
for(i in 1:10000){
  results[i] <- sum(sample(1:100, rep=TRUE) == 5) > 0
}
mean(results)


