#Neha Maddali HW8
#DS301
#4/6/22

################## 1a. ####################
library(ISLR2)
head(Boston)
n = dim(Boston)[1]
beta1_star = summary(lm(medv~crim+age,data=Boston))$coef[1,1]
se_b1_star = summary(lm(medv~crim+age,data=Boston))$coef[1,2]
B = 500
m = 100
Fstar = rep(0,B)
beta1_m = rep(0,m)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample=Boston[index,]
  fit = lm(medv~crim+age,data=bootsample)
  beta1 =  coef(fit)[2]
  for(i in 1:m){
    index2 = sample(index,n,replace=TRUE)
    bootsample2 = Boston[index2,]
    fit2 = lm(medv~crim+age,data=bootsample2)
    beta1_m[i] = coef(fit2)[2]
  }
  se_b1 = sqrt(sum((beta1_m-mean(beta1_m))^2)/(m-1))
  Fstar[b] = (beta1 - beta1_star)/se_b1
}
quantile(Fstar,c(0.025,0.975))
beta1_star + quantile(Fstar,0.025)*se_b1_star
beta1_star + quantile(Fstar,0.975)*se_b1_star
hist(Fstar)

################## 1b. ####################
confint(lm(medv~crim+age,data=Boston))

################## 1c. ####################
umed <- median(Boston$medv)

################## 1d. ####################
B = 2000
median_boot = rep(NA,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  median_boot[b] = median(bootstrap$medv, na.rm=TRUE)
}
sqrt(sum((median_boot-mean(median_boot))^2)/(B-1))

################## 1e. ####################
umed_star = median(Boston$medv, na.rm=TRUE)
se_umed_star = sqrt(sum((median_boot-mean(median_boot))^2)/(B-1))
B = 500
m = 100
Fstar = rep(0,B)
umed_m = rep(0,m)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample=Boston[index,]
  median = median(bootsample$medv)
  for(i in 1:m){
    index2 = sample(index,n,replace=TRUE)
    bootsample2 = Boston[index2,]
    umed_m[i] = median(bootsample2$medv)
  }
  se_umed = sqrt(sum((umed_m-mean(umed_m))^2)/(m-1))
  Fstar[b] = (median - umed_star)/se_umed
}
quantile(Fstar,c(0.025,0.975))
umed_star + quantile(Fstar,0.025)*se_umed_star
umed_star + quantile(Fstar,0.975)*se_umed_star
hist(Fstar)

################## 1f. ####################
quantile(Boston$medv,0.1)

################## 1g. ####################
B = 2000
ten_medv = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = Boston[index,]
  ten_medv[b] = quantile(bootstrap$medv,0.1)
}
hist(ten_medv)
sqrt(sum((ten_medv-mean(ten_medv))^2)/(B-1))

################## 2a. ####################
spam = read.csv('/Users/neham/Desktop/DS301/spambase.data',header=FALSE)
table(spam['V58'])

################## 2b. ####################
set.seed(1)
train_spam = sample(1:nrow(spam),nrow(spam)/2)
train = spam[train_spam,]
test = spam[-train_spam,]
table(train['V58'])
table(test['V58'])

################## 2c. ####################
library(caret)
logit_model <- glm(V58~., data=test, family=binomial)
summary(logit_model)
probs = predict(logit_model, type="response")
head(probs,10)

################## 2d. ####################
preds = rep(0, nrow(test))
preds[probs > .5] = 1
table(preds, test$V58)
1-mean(preds == test$V58)
fp = 89 / (89+1351)
fn = 64 / (64+797)

################## 3a. ####################
library(ISLR)
library(MASS)
library(class)
summary(Weekly)
pairs(Weekly)
cor(subset(Weekly, select = -Direction))

################## 3b. ####################
logit_model <- glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly, family=binomial)
summary(logit_model)

################## 3c. ####################
probs = predict(logit_model, type="response")
preds = rep("Down", 1089)
preds[probs > 0.5] = "Up"
table(preds, Weekly$Direction)

################## 3d. ####################
train = (Weekly$Year<2009)
Weekly.train <-Weekly[!train,]
Weekly.fit<-glm(Direction~Lag2, data=Weekly,family=binomial, subset=train)
logWeekly.prob= predict(Weekly.fit, Weekly.train, type = "response")
logWeekly.pred = rep("Down", length(logWeekly.prob))
logWeekly.pred[logWeekly.prob > 0.5] = "Up"
Direction.train = Weekly$Direction[!train]
table(logWeekly.pred, Direction.train)

################## 4a. ####################
x = c(-2, 5, -1, 10, 5)
y = c('red', 'blue', 'red', 'blue', 'blue')
df = data.frame(x,y)
plot(x, col=y)

################## 4b. ####################
glm.fit = glm(y~x, data=df, family=binomial)

################## 4c. ####################
beta0 = 0
beta1=1
exp(beta0+beta1*5)/(1+exp(beta0+beta1*5))
