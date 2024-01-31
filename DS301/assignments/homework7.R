#Neha Maddali HW7
#DS301
#3/30/22

################## 2a. ####################
set.seed(1)
X <-  rnorm(100)
error <-  rnorm(100)

################## 2b. ####################
Y <- 3 + 2*X + -3*X^2 + 0.3*X^3 + error

################## 2c. ####################
library(leaps)
df <-  data.frame("y" = Y, "x" = X)
mod.full <-  regsubsets(y ~ poly(x, 10, raw=TRUE), data = df, nvmax = 10)
mod.summary <-  summary(mod.full)
n = dim(df)[1]
p = rowSums(mod.summary$which)
adjr2 = mod.summary$adjr2
cp = mod.summary$cp
rss = mod.summary$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)
cbind(p,adjr2, AIC,BIC)

################## 2d. ####################
which.min(BIC)
which.min(AIC)
which.max(adjr2)

################## 2e. ####################
mod.fwd = regsubsets(y ~ poly(x, 10, raw=TRUE), data = df, nvmax = 10, method="forward")
fwd.summary <-  summary(mod.fwd)
which.min(fwd.summary$bic)
which.max(fwd.summary$adjr2)

mod.bwd = regsubsets(y ~ poly(x, 10, raw=TRUE), data = df, nvmax=10, method="backward")
bwd.summary <-  summary(mod.bwd)
which.min(bwd.summary$bic)
which.max(bwd.summary$adjr2)

################## 2f. ####################
library(glmnet)
matrix = model.matrix(y ~ poly(x, 10, raw=TRUE), data = df)[,-1]
cv_results = cv.glmnet(matrix, df$y, alpha = 1)
plot(cv_results)
min_lambda = cv_results$lambda.min
lasso_model = glmnet(matrix, df$y, alpha = 1, lambda = min_lambda)
coef(lasso_model)

################## 2g. ####################
newY <- 3 + 8*X^7 + error
df2 <-  data.frame("y" = newY, "x" = df[,-1])
fit <- regsubsets(y ~ poly(x, 10, raw=TRUE), data = df2, nvmax = 10)
fit_summary <- summary(fit)
which.min(fit_summary$bic)
which.max(fit_summary$adjr2)

matrix2 = model.matrix(y ~ poly(x, 10, raw=TRUE), data = df2)[,-1]
cv_results2 = cv.glmnet(matrix2, df2$y, alpha = 1)
plot(cv_results2)
min_lambda2 = cv_results2$lambda.min
lasso_model2 = glmnet(matrix2, df2$y, alpha = 1, lambda = min_lambda2)
coef(lasso_model2)

################## 3a. ####################
library(ISLR)
Hitters = na.omit(Hitters)
n = nrow(Hitters) #there are 263 observations
x = model.matrix(Salary ~.,data=Hitters)[,-1] #19 predictors
Y = Hitters$Salary
set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]

################## 3b. ####################
grid = 10^seq(10,-2,length=100)
ridge.train = glmnet(x[train,],Y[train],alpha=0,lambda=grid)
predict(ridge.train,s=0.013, type='coefficients')[1:20,]
pred = predict(ridge.train,s=0.013,type='coefficients')[1:20,][-1]

################## 3c. ####################
predict(ridge.train,s=10^10, type='coefficients')[1:20,]

################## 3e. ####################
sum(pred^2)

################## 3f. ####################
cv.out = cv.glmnet(x[train,],Y[train],alpha = 0, lambda = grid) 
plot(cv.out)
ridgeMin = cv.out$lambda.min
ridgeMin

################## 3g. ####################
ridgelse = cv.out$lambda.1se
ridgelse

################## 3h. ####################
lasso.train = glmnet(x[train,],Y[train],alpha=1, lambda = grid)
cv.out.lasso = cv.glmnet(x[train,],Y[train],alpha = 1, lambda = grid) 
plot(cv.out.lasso)
lassoMin = cv.out.lasso$lambda.min
lassoMin
lassolse = cv.out.lasso$lambda.1se
lassolse

################## 3i. ####################
ridge.min = predict(ridge.train, s=ridgeMin, newx = x[test,])
mean((ridge.min-Y.test)^2)
ridge.lse = predict(ridge.train, s=ridgelse, newx=x[test,])
mean((ridge.lse-Y.test)^2)

lasso.min = predict(lasso.train, s=lassoMin, newx = x[test,])
mean((lasso.min-Y.test)^2)
lasso.lse = predict(lasso.train, s=lassolse, newx = x[test,])
mean((lasso.lse-Y.test)^2)

################## 3j. ####################
coef(glmnet(x,Y,alpha=0, lambda = ridgeMin))
coef(glmnet(x,Y, alpha=0, lambda = ridgelse))
coef(glmnet(x,Y,alpha=1,lambda=lassoMin))
coef(glmnet(x,Y,alpha=1, lambda=lassolse))

################## 4a. ####################
data(College)
set.seed(1)
n=nrow(College)
train_index = sample(1:n,n/2,rep=FALSE)
train = College[train_index,]
test = College[-train_index,]

################## 4b. ####################
regfit = regsubsets(Apps~., data = train, nbest=1, nvmax=17)
val.errors = rep(NA,17)
for(i in 1:17){
  test.mat = model.matrix(Apps~., data = test)
  coef.m = coef(regfit, id=i)
  pred = test.mat[,names(coef.m)]%*%coef.m
  val.errors[i] = mean((test$Apps-pred)^2)
}
which.min(val.errors)
val.errors[which.min(val.errors)]
coef(regfit,11)

################## 4c. ####################
x = model.matrix(Apps~.,data = College)[,-1]
Y = College$Apps
grid = 10^seq(10,-2,length=100)
test = (-train_index)
Y.test = Y[test]
ridge.train = glmnet(x[train_index,],Y[train_index],alpha=0,lambda = grid)

################## 4d. ####################
cv.out = cv.glmnet(x[train_index,],Y[train_index],alpha=0,lambda=grid)
plot(cv.out)
bestlambda = cv.out$lambda.min
bestlambda

################## 4e. ####################
ridge.pred = predict(ridge.train, s=bestlambda, newx=x[test,])
mean((ridge.pred-Y.test)^2)

################## 4f. ####################
lasso.train = glmnet(x[train_index,],Y[train_index], alpha=1, lambda = grid)
cv.out.lasso = cv.glmnet(x[train_index,],Y[train_index], alpha=1, lambda = grid)
plot(cv.out.lasso)
bestlambda2 = cv.out.lasso$lambda.min
bestlambda2
lasso.pred = predict(lasso.train, s=bestlambda2, newx=x[test,])
mean((lasso.pred-Y.test)^2)
final.lasso=glmnet(x,Y,alpha=1,lambda = bestlambda2)
coef(final.lasso)
sum(coef(lasso.train)[, 1] != 0)