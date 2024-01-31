#Neha Maddali and Jillian Egland
#Midterm 1 Part 2
#110122037
#DS303
#9/25/23

set.seed(1) # so we all get the same x values. 
n = 100
x = runif(n, min = 0, max = 2) 
error = rnorm(n,0,1)
y = 4 + x + x^2 + x^3 + error
train_set = data.frame(x,y)

M1 = lm(y~x,data=train_set)
M2 = lm(y~poly(x,degree=2),data=train_set)
M3 = lm(y~poly(x,degree=3),data=train_set)
M4 = lm(y~poly(x,degree=5),data=train_set)
M5 = lm(y~poly(x,degree=11),data=train_set)

######### Problem 2.1 ###########
set.seed(1)
#new_data=data.frame(x=.9)
pred1 = pred2 = pred3 = pred4 = pred5 = rep(NA,1000)

for (i in 1:1000){
  error=rnorm(n,0,1) 
  y=4+x+x^2+x^3 + error
  train_set = data.frame(x,y)
  
  M1 = lm(y~x,data=train_set)
  M2 = lm(y~poly(x,degree=2),data=train_set)
  M3 = lm(y~poly(x,degree=3),data=train_set)
  M4 = lm(y~poly(x,degree=5),data=train_set)
  M5 = lm(y~poly(x,degree=11),data=train_set)
  
  pred1[i] = predict(M1,newdata=data.frame(x=.9))
  pred2[i] = predict(M2,newdata=data.frame(x=.9))
  pred3[i] = predict(M3,newdata=data.frame(x=.9))
  pred4[i] = predict(M4,newdata=data.frame(x=.9))
  pred5[i] = predict(M5,newdata=data.frame(x=.9))
}
pred1[1:5]
pred2[1:5]
pred3[1:5]
pred4[1:5]
pred5[1:5]

######### Problem 2.2 ###########
x0=.9
true_y = 4+(x0)+(x0)^2+(x0)^3
# for mod1 
bias1 = (mean(pred1)-true_y)^2
bias2 = (mean(pred2)-true_y)^2
bias3 = (mean(pred3)-true_y)^2
bias4 = (mean(pred4)-true_y)^2
bias5 = (mean(pred5)-true_y)^2
biases = c(bias1, bias2, bias3, bias4, bias5)

plot(biases)

######### Problem 2.3 ###########
x0=.9
true_y = 4+(x0)+(x0)^2+(x0)^3
# for mod1 
var1 = mean((pred1-mean(pred1))^2)
var2 = mean((pred2-mean(pred2))^2)
var3 = mean((pred3-mean(pred3))^2)
var4 = mean((pred4-mean(pred4))^2)
var5 = mean((pred5-mean(pred5))^2)
vars = c(var1, var2, var3, var4, var5)

plot(vars)

######### Problem 2.5 ###########
(bias1) + var1 + 0
(bias2) + var2 + 0
(bias3) + var3 + 0
(bias4) + var4 + 0
(bias5) + var5 + 0

######### Problem 2.7 ###########
(1/(100-1+1))*sum((true_y-pred1)^2)
(1/(100-1+1))*sum((true_y-pred2)^2)
(1/(100-1+1))*sum((true_y-pred3)^2)
(1/(100-1+1))*sum((true_y-pred4)^2)
(1/(100-1+1))*sum((true_y-pred5)^2)




