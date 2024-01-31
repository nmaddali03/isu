#Neha Maddali HW6
#DS301
#3/23/22

################## 3a. ####################
library(ISLR2)
library(leaps)
head(College)

regfit.fwd = regsubsets(Apps~.,data=College,nvmax=17, method="forward")
regfit.bwd = regsubsets(Apps~.,data=College,nvmax=17, method="backward")

################## 3b. ####################
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

################## 3c. ####################
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

################## 3d. ####################
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

################## 3e. ####################
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
