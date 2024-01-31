#Neha Maddali HW9
#DS301
#4/20/22

################## 2a. ####################
set.seed(1)
x1 = rnorm(1000,0,0.9) # create 3 predictors
x2 = rnorm(1000,1,1)
x3 = rnorm(1000,0,2)
B0 = 1
B1 = 2
B2 = 3
B3 = 2
pr = (exp(B0+B1*x1+B2*x2+B3*x3))/(1+exp(B0+B1*x1+B2*x2+B3*x3))
y = rbinom(1000,1,pr)
df = data.frame(y=y,x1=x1,x2=x2, x3=x3)

################## 2b. ####################
set.seed(1)
train = sample(1:nrow(df),nrow(df)/2, replace=FALSE)
test = (-train)
glm.fit = glm(y~x1+x2+x3, data=df,subset=train,family='binomial')
summary(glm.fit)
glm.prob = predict(glm.fit,df[test,],type='response') 
glm.pred = rep(0,length(test))
glm.pred[glm.prob >0.5] =1
table(glm.pred,df[test,]$y) #rows are predicted, # columns are true 
1-mean(glm.pred == df[test,]$y)

################## 2c. ####################
library(MASS)
lda.fit = lda(y~x1+x2+x3, data=df, subset=train)
summary(lda.fit)
lda.pred = predict(lda.fit,df[test,])
table(lda.pred$class,df[test,]$y)
mean(lda.pred$class!=df[test,]$y)

################## 2d. ####################
library(caret)
library(class)
var(df[,1])
var(df[,2])
standardized.X = scale(df[,-1])
var(standardized.X[,1])
var(standardized.X[,2])

train.X = standardized.X[-test,]
test.X = standardized.X[test,]
train.Y = df$y[-test]
test.Y = df$y[test]
flds <- createFolds(train.Y, k=5, list=TRUE, returnTrain=FALSE)
K = c(1,3,5)
cv_error = matrix(NA,5,3)
for(j in 1:3){
  k=K[j]
  for(i in 1:5){
    test_index = flds[[i]]
    testX = train.X[test_index,]
    trainX = train.X[-test_index,]
    trainY = train.Y[-test_index]
    trainX = train.Y[test_index]
    knn.pred = knn(testX, trainX, trainY, k=k)
    cv_error[i,j] = mean(testY!=knn.pred)
  }
}
apply(cv_error, 2, mean)
knn.pred = knn(train.X, test.X, train.Y, k=5)
table(knn.pred, test.Y)
mean(test.Y!=knn.pred)

################## 3a. ####################
library(ISLR)
library(class)
library(MASS)
summary(Weekly)
training.data = Weekly[Weekly$Year<2009,]
test.data = Weekly[Weekly$Year>2008,]
lda.fit = lda(Direction~Lag2, data=training.data)
lda.fit

################## 3b. ####################
lda.pred = predict(lda.fit,training.data)
head(lda.pred$class) # automatically assigns Y to the class with largest probability 
head(lda.pred$posterior)

################## 3c. ####################
lda.pred = predict(lda.fit,test.data)
head(lda.pred$class) # automatically assigns Y to the class with largest probability 
head(lda.pred$posterior)

################## 3d. ####################
table(lda.pred$class,test.data$Direction)
mean(lda.pred$class==test.data$Direction)

################## 3e. ####################
plot(lda.fit)
library("car")
Up = Weekly[Weekly$Direction=='Up',]
Down = Weekly[Weekly$Direction=='Down',]
qqPlot(Up$Lag2)
qqPlot(Down$Lag2)
var(Up$Lag2)
var(Down$Lag2)
qqPlot(Up$Lag2)
qqPlot(Down$Lag2)

################## 3f. ####################
qda.fit = qda(Direction~Lag2, data=training.data)
qda.fit
qda.pred = predict(qda.fit,test.data)
head(qda.pred$class) # automatically assigns Y to the class with largest probability 
head(qda.pred$posterior)
table(qda.pred$class,test.data$Direction)
mean(qda.pred$class==test.data$Direction)

################## 3g. ####################
set.seed(1)
train.X = cbind(training.data$Lag2)
test.X = cbind(test.data$Lag2)
train.Y = cbind(training.data$Direction)
knn.pred = knn(train.X, test.X, train.Y, k=3)
table(knn.pred, test.data$Direction)
