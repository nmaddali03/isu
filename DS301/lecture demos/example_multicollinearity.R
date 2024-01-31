set.seed(6)
n=100;

Covmat = matrix(0.88,3,3);
diag(Covmat)=1;
betas=c(1,2,3);
X=matrix(0,n,3);
y=numeric(n);
for(i in 1:n){
  X[i,]<- mvrnorm(1,rep(0,3),Covmat);
  y[i]<-sum(X[i,]*betas)+8*rnorm(1);
}


X1 = X[,1]
X2 = X[,2]
X3 = X[,3]

lm1 = lm(y~X1+X2+X3)

summary(lm1)

# small changes to the first 5 observations of X1
# everything else stays the same
set.seed(12)
X1[1:5] = X1[1:5] + rnorm(5)
summary(lm(y~X1+X2+X3))

#########################
### multicollinearity ###
#########################

library(ISLR2)

plot(Rating~Limit,Credit)

fit1 = lm(Balance~Limit,data=Credit)
summary(fit1)
fit2 = lm(Balance~Rating+Limit,data=Credit)
summary(fit2)

# check for multicollinearity
#install.packages("car")
library(car)
vif(fit2)

# simple solutions for multicollinearity? 

