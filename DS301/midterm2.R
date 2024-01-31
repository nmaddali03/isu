#Neha Maddali Midterm 2
#DS301
#4/11/2022

#1a)
n=10000
p=4
AIC1 = n*log(13650.32/n) + 2*(p)
AIC2 = n*log(13691.11/n) + 2*(p)
AIC3 = n*log(13755.97/n) + 2*(p)
AIC4 = n*log(13712.95/n) + 2*(p)

AIC1 = n*log(13549.8/n) + 2*(p)
AIC2 = n*log(13516.38/n) + 2*(p)
AIC3 = n*log(13514.86/n) + 2*(p)
AIC4 = n*log(13554.16/n) + 2*(p)
AIC5 = n*log(13490.86/n) + 2*(p)
AIC6 = n*log(13598.66/n) + 2*(p)

BIC1 = n*log(13411.79/n)+p*log(n)
BIC2 = n*log(13490.59/n)+p*log(n)
BIC3 = n*log(13476.56/n)+p*log(n)
BIC4 = n*log(13474.19/n)+p*log(n)

AIC1 = n*log(13410.86/n) + 2*(p)

#2a)
heart = read.table('https://hastie.su.domains/ElemStatLearn/datasets/SAheart.data', 
                   sep=",",head=T,row.names=1)
glm.fit = glm(chd~age, data=heart,family='binomial')
beta0 = -3.521710
beta1 = 0.064108
exp(beta0+beta1*462)/(1+exp(beta0+beta1*462))

#2b)
newdata = data.frame(chd = 1, age=50)
predict(glm.fit, newdata, type='response')

#2C)
#heart$chd = as.numeric(heart$chd)
B = 2000
n=462
medhat = rep(NA,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootstrap = heart[index,]
  medhat[b] = median(bootstrap$chd, na.rm=TRUE)
}
sqrt(sum((medhat-mean(medhat))^2)/(B-1))

#2d)
newdata = data.frame(chd = 1, age=55)
predict(glm.fit, newdata, type='response')

#3a)
set.seed(1)
#train_index = sort(sample(nrow(heart),nrow(heart)*0.21))
train = heart[101:462,]
test = heart[1:100,]

glm.fit = glm(chd~sbp+tobacco+ldl+adiposity+typea+obesity+alcohol+age, data=train, family='binomial')
glm.prob = predict(glm.fit,train,type='response') 
head(glm.prob,10)

#3b)
glm.fit = glm(chd~sbp+tobacco+ldl+adiposity+typea+obesity+alcohol+age, data=test, family='binomial')
#heart$chd = as.factor(heart$chd)
#contrasts(heart$chd)
glm.prob = predict(glm.fit,test,type='response')
head(glm.prob,10)
glm.pred = rep('No',length(heart))
glm.pred[glm.prob > 0.4]='Yes'
table(glm.pred,test$chd)
1-mean(glm.pred == test$chd) #misclassification rate = 0.31818181

#3c)
glm.fit = glm(chd~sbp+tobacco+ldl+adiposity+typea+obesity+alcohol+age, data=test, family='binomial')
glm.prob = predict(glm.fit,test,type='response')
head(glm.prob,10)
glm.pred = rep('No',length(heart))
glm.pred[glm.prob > 0.5]='Yes'
table(glm.pred,test$chd)
1-mean(glm.pred == test$chd) #misclassification rate = 0.3421



