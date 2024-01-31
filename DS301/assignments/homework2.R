#Neha Maddali HW2
#DS301
#2/9/22

##################1a.####################
library(ISLR2) #you will need to do this every time you open a new R session.
head(Boston)
str(Boston)
?Boston

##################1b.####################
model = lm(crim~lstat, data=Boston)
summary(model)
model$coefficients

##################1c.####################
model.zn <- lm(crim ~ zn, data=Boston)
summary(model.zn)

model.indus <- lm(crim ~ indus, data=Boston)
summary(model.indus)

chas <- as.factor(Boston$chas)
model.chas <- lm(crim ~ chas, data=Boston)
summary(model.chas)

model.nox <- lm(crim~nox, data=Boston)
summary(model.nox)

model.rm <- lm(crim ~ rm, data=Boston)
summary(model.rm)

model.age <- lm(crim ~ age, data=Boston)
summary(model.age)

model.dis <- lm(crim ~ dis, data=Boston)
summary(model.dis)

model.rad <- lm(crim ~rad, data=Boston)
summary(model.rad)

model.tax <- lm(crim ~tax, data=Boston)
summary(model.tax)

model.ptratio <- lm(crim ~ptratio, data=Boston)
summary(model.ptratio)

model.medv <- lm(crim ~medv, data=Boston)
summary(model.medv)

plot(Boston$crim~Boston$chas, xlab = "chas", ylab="crim")
abline(reg=lm(Boston$crim ~ Boston$chas),col="red")

plot(Boston$crim~Boston$zn, xlab = "zn", ylab="crim")
abline(reg=lm(Boston$crim ~ Boston$zn),col="red")

##################1d.####################
model.all <- lm(crim~.,data=Boston)
summary(model.all)

##################1e.####################
simple <- vector("numeric",0)
simple <- c(simple, model.zn$coefficient[2])
simple <- c(simple, model.indus$coefficient[2])
simple <- c(simple, model.chas$coefficient[2])
simple <- c(simple, model.nox$coefficient[2])
simple <- c(simple, model.rm$coefficient[2])
simple <- c(simple, model.age$coefficient[2])
simple <- c(simple, model.dis$coefficient[2])
simple <- c(simple, model.rad$coefficient[2])
simple <- c(simple, model.tax$coefficient[2])
simple <- c(simple, model.ptratio$coefficient[2])
simple <- c(simple, model$coefficient[2])
simple <- c(simple, model.medv$coefficient[2])

multiple <- vector("numeric", 0)
multiple <- c(model.all$coefficients)
multiple <- multiple[-1]

data.frame(simple, multiple)

##################1f.####################
set.seed(1) 
n = nrow(Boston)
train_index = sample(1:n,n/2,rep=FALSE)

train_Boston = Boston[train_index,]
test_Boston = Boston[-train_index,]

model_train = lm(crim~.,data=train_Boston)
MSE_train = mean((train_Boston$crim - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_Boston)
MSE_test = mean((test_Boston$crim - predicted_values)^2)
MSE_test

##################1g.####################
model_train=lm(crim~zn+indus+nox+dis+rad+ptratio+medv, data=train_Boston)
MSE_train = mean((train_Boston$crim - model_train$fitted.values)^2)
MSE_train

predicted_values = predict(model_train, test_Boston)
MSE_test = mean((test_Boston$crim - predicted_values)^2)
MSE_test

##################1h.####################
summary(lm(medv~.,data=Boston))

##################1i.####################
summary(lm(medv~.,data=Boston))
ts = (2.839993-5)/0.870007
pt(abs(ts),495,lower.tail=FALSE) * 2

##################3.####################
set.seed(2)
x = matrix(NA,1000,200)
n=1000
beta_0 = 0
beta_1 = 1
beta_2 = 2
beta_3 = 3
beta_4 = 4
beta_5 = 5
error = rnorm(n,0,1)

for(i in 1:200){
  x[,i] = rnorm(1000)
}
Y = beta_0 + beta_1*x[,1] + beta_2*x[,2] + beta_3*x[,3] + beta_4*x[,4] + beta_5*x[,5] + error
data = as.data.frame(cbind(Y,x))

fit = lm(Y~.,data=data)
summary(fit)
p_values = summary(fit)$coefficients[,4]  
length(which(p_values<0.05))

#which(p_values<0.05)
