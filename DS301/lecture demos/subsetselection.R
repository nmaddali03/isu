############################
##### Subset Selection #####
############################

#install.packages('leaps')
library(leaps)
library(ISLR2)

head(Hitters)

dim(Hitters)
is.na(Hitters$Salary)
sum(is.na(Hitters$Salary))

Hitters = na.omit(Hitters)
dim(Hitters)
sum(is.na(Hitters$Salary))

regfit = regsubsets(Salary~.,data=Hitters,nbest=1,nvmax=19)
regfit.sum = summary(regfit)
regfit.sum
names(regfit.sum)

n = dim(Hitters)[1]
p = rowSums(regfit.sum$which)
adjr2 = regfit.sum$adjr2
cp = regfit.sum$cp
rss = regfit.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,rss,adjr2,cp,AIC,BIC)
plot(p,BIC)
plot(p,AIC)

which.min(BIC)
which.min(AIC)
which.min(cp)
which.max(adjr2)

coef(regfit,10)
