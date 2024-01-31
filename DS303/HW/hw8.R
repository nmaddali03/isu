#Neha Maddali HW8
#DS303
#10/23/23


###############################
## Problem 1: Concept Review ##
###############################
################## 1g. ####################
set.seed(1)
X1 = sample(16)
X2 = sample(16)
Y = rep(1,16)
Y[X1 < 8] = 0
data = data.frame(X1,X2,Y)
summary(glm(Y~X1+X2,data,family='binomial'))

################## 1h. ####################
library(MASS)
lda_model = lda(Y ~ X1 + X2, data = data)
qda_model = qda(Y ~ X1 + X2, data = data)

lda_pred = predict(lda_model)
qda_pred = predict(qda_model)

mean(lda_pred$class != data$Y)
mean(qda_pred$class != data$Y)


###########################
## Problem 2: Email Spam ##
###########################
################## 2a. ####################
spam = read.csv('/Users/neham/Desktop/DS303/HW/spambase.data',header=FALSE)
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
logit_model = glm(V58~., data=test, family=binomial)
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


################################
## Problem 3: Weekly Data Set ##
################################
library(ISLR)
library(MASS)
library(class)
summary(Weekly)
################## 3a. ####################
logit_model = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly, family=binomial)
summary(logit_model)

################## 3b. ####################
probs = predict(logit_model, type="response")
preds = rep("Down", 1089)
preds[probs > 0.5] = "Up"
table(preds, Weekly$Direction)

################## 3c. ####################
train = (Weekly$Year<2009)
Weekly.train = Weekly[!train,]
Weekly.fit = glm(Direction~Lag2, data=Weekly,family=binomial, subset=train)
logWeekly.prob= predict(Weekly.fit, Weekly.train, type = "response")
logWeekly.pred = rep("Down", length(logWeekly.prob))
logWeekly.pred[logWeekly.prob > 0.5] = "Up"
Direction.train = Weekly$Direction[!train]
table(logWeekly.pred, Direction.train)

################## 3d. ####################
training.data = Weekly[Weekly$Year<2009,]
test.data = Weekly[Weekly$Year>2008,]
lda.fit = lda(Direction~Lag2, data=training.data)
lda.pred = predict(lda.fit,training.data)
lda.pred = predict(lda.fit,test.data)
table(lda.pred$class,test.data$Direction)
mean(lda.pred$class==test.data$Direction)

################## 3e. ####################
qda.fit = qda(Direction~Lag2, data=training.data)
qda.pred = predict(qda.fit,test.data)
table(qda.pred$class,test.data$Direction)
mean(qda.pred$class==test.data$Direction)

################## 3f. ####################
library(e1071)
nb.fit = naiveBayes(Direction ~ Lag2, data = training.data)
nb.class = predict(nb.fit, test.data)
table(nb.class, test.data$Direction)
mean(nb.class == test.data$Direction)
