#Neha Maddali HW1
#DS301
#2/2/22

#Question 1 not included because no code required.

##############################################2a. 
install.packages("ISLR2")
library(ISLR2) 
head(College)
#summary(College)
str(College)

#################################################2b. 
?College
  #Statistics for a large number of US Colleges from the 1995 issue of US News and World Report.

##################################################2c. 
College[278,]
View(College[278,])

#################################################2d. 
df<-as.numeric(College$Grad.Rate)
mean(df)
#summary(College)  #you could also find the mean through this

##################################################2e. 
model2 = lm(Grad.Rate~S.F.Ratio, data=College)
summary(model2)
names(model2)
model2$coefficients

#################################################2f. 
plot(College$Grad.Rate ~ College$S.F.Ratio, xlab = "student-to-faculty-ratio", ylab="graduation rate")
abline(reg=lm(College$Grad.Rate ~ College$S.F.Ratio))

#################################################2g. 
head(model2$residuals)
head(model2$fitted.values)

###############################################2h. 
x <- data.frame(S.F.Ratio=10)
predict(model2,newdata=x)

##############################################2i. 
set.seed(100)
#n = dim(College)[1]
n = nrow(College)
train_index = sample(1:n,n/2,rep=FALSE)

train_College = College[train_index,]
test_College = College[-train_index,]

model_train = lm(College$Grad.Rate ~ College$S.F.Ratio,data=train_College)
MSE_train = mean((train_College$Grad.Rate - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_College)
MSE_test = mean((test_College$Grad.Rate - predicted_values)^2)
MSE_test


#############################################3a. 
  #??0 = 2, ??1 = 3, ??2 = 5
  #This can be obtained by the equation given

##############################################3b. 
X1 = seq(0,10,length.out =100) #generates 100 equally spaced values from 0 to 10.
X2 = runif(100) #generates 100 uniform values.
n = 100
beta_0 = 2
beta_1 = 3
beta_2 = 5

error = rnorm(n,0,1)
Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
Y

###############################################3c. 
plot(X1, Y)
plot(X2, Y)

################################################3d. 
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
Yhat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
  fit = lm(Y~X1 + log(X2))
  beta1hat[i] = fit$coefficients[[2]]
}
beta1hat[i]

#################################################3e. 
hist(beta1hat)
abline(v=beta_1, col="blue")

##################################################3f. 
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
Yhat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
  fit = lm(Y~X1 + log(X2))
  beta2hat[i] = fit$coefficients[[3]]
}
beta2hat[i]

#################################################3g. 
hist(beta2hat)
abline(v=beta_2, col="blue")

