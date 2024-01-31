#Neha Maddali Midterm 2 Review
#DS301

####################
#### Homework 5 #### 
####################
#### SIMULATION FOR BIAS-VARIANCE TRADE-OFF ####
#generate a predictor X1 of length n = 100
x1 <- rnorm(n=100)
#generate the random error term of length n = 100 with mean 0 and ?? = 2.
error <- rnorm(n=100, mean=0, sd=2)
#generate response for model
b0 <- 1
b1 <- 2
b2 <- 3
b3 <- 4
y <- b0 + b1*x1 + b2*x1^2 + b3*x1^3 + error
#create data frame and 50/50 training and test
df <- data.frame(y=y, x1=x1)
head(df)
n=100
train_index = sample(1:n, n/2, replace=FALSE)
df_train <- df[train_index,]
df_test <- df[-train_index,]
#fit 10 different models on training set
MSE_train <- rep(NA, 10)
MSE_test <- rep(NA, 10)
for(i in 1:10){
  lm_train <- lm(y~poly(x1, i), data = df_train)
  MSE_train[i] <- mean(lm_train$residuals^2)
  MSE_test[i] <- mean((predict(lm_train, df_test)-df_test$y)^2)
}
data.frame(order=c(1:10), MSE_train=MSE_train, MSE_test=MSE_test)
#plot training MSE
plot(x=c(1:10), y=MSE_train, xlab='Order', ylab='MSE for training', type='b')
#plot test MSE
plot(x=c(1:10), y=MSE_test, xlab='Order', ylab='MSE for testing', type='b')
#lowest test MSE
test_order <- c(1:10)[which(MSE_test == min(MSE_test))]
test_order
#generate new model
b4 <- 4
b5 <- 5
b6 <- 6
b7 <- 7
y_new <- y + b4*x1^4 + b5*x1^5 + b6*x1^6 + b7*x1^7
df_new <- data.frame(y_new, x1=x1)
n=100
train_index <- sample(1:n, n/2, replace=FALSE)
df_train_new <- df_new[train_index,]
df_test_new <- df_new[-train_index,]
MSE_train_new <- rep(NA, 10)
MSE_test_new <- rep(NA, 10)
for(i in 1:10){
  lm_train <- lm(y_new~poly(x1, i), data=df_train_new)
  MSE_train_new[i] <- mean(lm_train$residuals^2)
  MSE_test_new[i] <- mean((predict(lm_train, df_test_new)-df_test_new$y_new)^2)
}
plot(x=c(1:10), y=MSE_train_new, xlab='Order', ylab='MSE for new training', type='b')
plot(x=c(1:10), y=MSE_test_new, xlab='Order', ylab='MSE for new testing', type='b')
order_df <- data.frame(train=c(1:10)[which(MSE_train_new == min(MSE_train_new))], 
                       test=c(1:10)[which(MSE_test_new == min(MSE_test_new))])
order_df

#### BEST SUBSET SELECTION ####
#Approach 1: best subset selection on the entire data set with lpsa as the response
prostate = read.table("/Users/neham/Desktop/DS301/prostate.data",header=TRUE)
library(leaps)
dim(prostate)
is.na(prostate$lpsa)
sum(is.na(prostate$lpsa))

regfit = regsubsets(lpsa~.,data=prostate,nbest=1,nvmax=9)
regfit.sum = summary(regfit)
n = dim(prostate)[1]
p = rowSums(regfit.sum$which)
adjr2 = regfit.sum$adjr2
cp = regfit.sum$cp
rss = regfit.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,adjr2,cp,AIC,BIC)
which.min(BIC)
which.min(AIC)
which.min(cp)
which.max(adjr2)
coef(regfit,5)
#Approach 2: best model given training and test split sets
train = subset(prostate,train==TRUE)[,1:9]
test = subset(prostate,train==FALSE)[,1:9]
best.train = regsubsets(lpsa~.,data=train,nbest=1,nvmax=8)
val.errors = rep(NA,8)
for(i in 1:8){
  test.mat = model.matrix(lpsa~.,data=test)
  coef.m = coef(best.train,id=i)
  pred = test.mat[,names(coef.m)]%*%coef.m
  val.errors[i] = mean((test$lpsa-pred)^2)
}
data.frame(num_predictors = c(1:8), test_error=val.errors)
which.min(val.errors)
model1=lm(lpsa~lcavol+lweight+svi, data=prostate)
summary(model1)
#Approach 3: select optimal size, not which predictors for model. Split into k folds
k=5
folds=sample(1:k, nrow(prostate), replace=TRUE)
cv.errors = matrix(0,k,8)
for(j in 1:k){
  train=prostate[folds!=j,]
  test = prostate[folds==j,]
  test.mat=model.matrix(lpsa~., data=test)
  best.fit=regsubsets(lpsa~., data=train, nbest=1, nvmax=8)
  for(i in 1:8){
    coefi = coef(best.fit, id=i)
    pred = test.mat[,names(coefi)]%*%coefi
    cv.errors[j,i]=mean((test$lpsa-pred)^2)
  }
}
mean.cv.errors = apply(cv.errors, 2, mean)
which.min(mean.cv.errors)
#best subset selection on the full data set again
regfit = regsubsets(lpsa~., data=prostate, nbest=1, nvmax=8)
coef(regfit, 3)

#### CROSS-VALIDATION ####
#perform cross-validation on a simulated data set
set.seed(1)
x = rnorm(100)
error = rnorm(100,0,1)
y = x - 2 * x^2 + error
#n compute the LOOCV errors that result from fitting 4 models using least squares
set.seed(1)
Data <- data.frame(x, y)
PRESS <- function(model,n) {
  i <- residuals(model)/(1 - lm.influence(model)$hat)
  sum(i^2)/n
}
m1 = lm(y~x,data=Data)
PRESS(m1,100)
m2 = lm(y~poly(x,2),data=Data)
PRESS(m2,100)
m3 = lm(y~poly(x,3),data=Data)
PRESS(m3,100)
m4 = lm(y~poly(x,4),data=Data)
PRESS(m4,100)


####################
#### Homework 6 #### MODEL SELECTION 
####################
library(ISLR2)
library(leaps)
head(College)
#forward selection
regfit.fwd = regsubsets(Apps~.,data=College,nvmax=17, method="forward")
#backward selection
regfit.bwd = regsubsets(Apps~.,data=College,nvmax=17, method="backward")
#best AIC and BIC for forward selection
regfitFWD.sum = summary(regfit.fwd)
names(regfitFWD.sum)
n = dim(College)[1]
p = rowSums(regfitFWD.sum$which)
adjr2 = regfitFWD.sum$adjr2
cp = regfitFWD.sum$cp
rss = regfitFWD.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,adjr2,cp,AIC,BIC)
which.min(BIC)
coef(regfit.fwd,10)
which.min(AIC)
coef(regfit.fwd,12)
#best AIC and BIC for backward selection
regfitBWD.sum = summary(regfit.bwd)
names(regfitBWD.sum)
n = dim(College)[1]
p = rowSums(regfitBWD.sum$which)
adjr2 = regfitBWD.sum$adjr2
cp = regfitBWD.sum$cp
rss = regfitBWD.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,adjr2,cp,AIC,BIC)
which.min(BIC)
coef(regfit.fwd,10)
which.min(AIC)
coef(regfit.fwd,12)
#implement BEST SUBSET SELECTION
regfit = regsubsets(Apps~.,data=College,nbest=1,nvmax=17)
regfit.sum = summary(regfit)
names(regfit.sum)
n = dim(College)[1]
p = rowSums(regfit.sum$which)
adjr2 = regfit.sum$adjr2
cp = regfit.sum$cp
rss = regfit.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,adjr2,cp,AIC,BIC)
which.min(BIC)
which.min(AIC)
#forward selection and report the model with the smallest test MSE using training set
train_index = sort(sample(nrow(College),nrow(College)*0.90))
train = College[train_index,]
test = College[-train_index,]
regfit.fwd.train = regsubsets(Apps~., data = train, nvmax=17, method="forward")
val.errors = rep(NA, 17)
for(i in 1:17){
  test.mat = model.matrix(Apps~., data=test)
  coef.m = coef(regfit.fwd.train,id=i)
  pred = test.mat[,names(coef.m)]%*%coef.m
  val.errors[i] = mean((test$App-pred)^2)
}
which.min(val.errors)
coef(regfit.fwd.train,5)
#forward selection and report smallest test MSE model using 60/40 split
train_index = sort(sample(nrow(College),nrow(College)*0.60))
train = College[train_index,]
test = College[-train_index,]
regfit.fwd.train = regsubsets(Apps~., data = train, nvmax=17, method="forward")
val.errors = rep(NA, 17)
for(i in 1:17){
  test.mat = model.matrix(Apps~., data=test)
  coef.m = coef(regfit.fwd.train,id=i)
  pred = test.mat[,names(coef.m)]%*%coef.m
  val.errors[i] = mean((test$App-pred)^2)
}
which.min(val.errors)
coef(regfit.fwd.train,3)


####################
#### Homework 7 #### 
####################
#### SIMULATION STUDIES ####
#generate predictor X of length n = 100, and error vector of length n=100, variance 1
set.seed(8)
n=100
x <-  rnorm(n)
error <-  rnorm(100,0,1)
#generate response Y
Y <- 1 + 2*x + 3*x^2 + 4*x^3 + error
#best subset selection
X = cbind(x,x^2,x^3,x^4,x^5,x^6,x^7,x^8,x^9,x^10)
data = data.frame(Y,X)
colnames(data) = c('Y','X1','X2','X3','X4','X5','X6','X7','X8','X9','X10')
model1 = lm(Y~.-X1, data=data) #repeat for all predictors (until X10)
rss = sum(model1$residuals^2)
p=9+1
AIC = n*log(rss/n)+2*p
BIC = n*log(rss/n)+p*log(n)
#fit a lasso model to the simulated data
library(glmnet)
matrix = model.matrix(y ~ poly(x, 10, raw=TRUE), data = df)[,-1]
cv_results = cv.glmnet(matrix, df$y, alpha = 1)
plot(cv_results)
min_lambda = cv_results$lambda.min
lasso_model = glmnet(matrix, df$y, alpha = 1, lambda = min_lambda)
coef(lasso_model)
#best subset selection and lasso on new model
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

#### REGULARIZED REGRESSION MODELS ####
#split in training and test set
library(ISLR)
Hitters = na.omit(Hitters)
n = nrow(Hitters) #there are 263 observations
x = model.matrix(Salary ~.,data=Hitters)[,-1] #19 predictors
Y = Hitters$Salary
set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]
#fit a ridge regression model on a grid of values. regression coef when ?? = 0.013?
grid = 10^seq(10,-2,length=100)
ridge.train = glmnet(x[train,],Y[train],alpha=0,lambda=grid)
predict(ridge.train,s=0.013, type='coefficients')[1:20,]
pred = predict(ridge.train,s=0.013,type='coefficients')[1:20,][-1]
#Report the l2 norm when ?? = 0.013
sum(pred^2)
#10-fold CV to obtain the optimal ??
cv.out = cv.glmnet(x[train,],Y[train],alpha = 0, lambda = grid) 
plot(cv.out)
ridgeMin = cv.out$lambda.min
#?? ridge lse
ridgelse = cv.out$lambda.1se
#fit lasso regression model and obtain ?? lasso min and ?? lasso lse
lasso.train = glmnet(x[train,],Y[train],alpha=1, lambda = grid)
cv.out.lasso = cv.glmnet(x[train,],Y[train],alpha = 1, lambda = grid) 
plot(cv.out.lasso)
lassoMin = cv.out.lasso$lambda.min
lassolse = cv.out.lasso$lambda.1se
#evaluate ridge and lasso models using the values for the tuning parameters
ridge.min = predict(ridge.train, s=ridgeMin, newx = x[test,])
mean((ridge.min-Y.test)^2)
ridge.lse = predict(ridge.train, s=ridgelse, newx=x[test,])
mean((ridge.lse-Y.test)^2)
lasso.min = predict(lasso.train, s=lassoMin, newx = x[test,])
mean((lasso.min-Y.test)^2)
lasso.lse = predict(lasso.train, s=lassolse, newx = x[test,])
mean((lasso.lse-Y.test)^2)
#report coefficient estimates for the models
coef(glmnet(x,Y,alpha=0, lambda = ridgeMin))
coef(glmnet(x,Y, alpha=0, lambda = ridgelse))
coef(glmnet(x,Y,alpha=1,lambda=lassoMin))
coef(glmnet(x,Y,alpha=1, lambda=lassolse))

#### COMPARING PREDICTIVE MODELS ####
#split into training and test
data(College)
set.seed(1)
n=nrow(College)
train_index = sample(1:n,n/2,rep=FALSE)
train = College[train_index,]
test = College[-train_index,]
#model selection -- chose best subset selection
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
#ridge regression model on the training set
x = model.matrix(Apps~.,data = College)[,-1]
Y = College$Apps
grid = 10^seq(10,-2,length=100)
test = (-train_index)
Y.test = Y[test]
ridge.train = glmnet(x[train_index,],Y[train_index],alpha=0,lambda = grid)
#Find optimal ?? for ridge regression model on training set using 10-fold CV
cv.out = cv.glmnet(x[train_index,],Y[train_index],alpha=0,lambda=grid)
plot(cv.out)
bestlambda = cv.out$lambda.min
#Using that optimal ??, evaluate your trained ridge regression model on the test set.
ridge.pred = predict(ridge.train, s=bestlambda, newx=x[test,])
mean((ridge.pred-Y.test)^2)
#find optimal ?? for lasso regression model on training set using 10-fold CV
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


####################
#### Homework 8 #### 
####################






###########################
#### MIDTERM 2 SCRATCH #### 
###########################
heart$chd = as.character(heart$chd)
heart$chd[heart$chd == "Yes"] <- 1      # Replace "Yes" by 1
heart$chd[heart$chd == "No"] <- 0 
heart$chd = as.numeric(heart$chd)

glm.fit = glm(chd~age, data=heart,family='binomial')
head(glm.fit$fitted.values)
head(heart,10)
glm.prob = predict(glm.fit,heart,type='response')
head(glm.prob,10)
glm.pred = rep('No',length(heart))
glm.pred[glm.prob > 0.4]='Yes'
table(glm.pred,heart$chd)

heart$chd <- factor(heart$chd)

train = (heart$age=50)
heart.test = heart[!train,]
train.logit = glm(chd~age, data=heart, subset=train, family='binomial')
glm.prob = predict(train.logit, heart.test, type='response')
glm.pred = rep('No',dim(heart.test)[1])
glm.pred[glm.prob>0.5]='Yes'
table(glm.pred,heart.test$chd)
