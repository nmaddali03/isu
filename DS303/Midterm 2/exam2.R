#Neha Maddali Midterm 2
#110122037
#DS303
#10/27/23

###############################
######### Problem 2 ###########
###############################
heart = read.table('https://hastie.su.domains/ElemStatLearn/datasets/SAheart.data', sep=",",head=T,row.names=1)

######### Part 1 ###########
glm.fit = glm(chd ~ age, data=heart, family="binomial")
# Create a data frame with age=50
x = data.frame(age=50)
predicted_probability = predict(glm.fit, newdata=x, type='response')
predicted_probability

######### Part 2 ###########
B = 2000
n = dim(heart)[1]
beta_0 = rep(0,2000)
for(b in 1:B){
  index = sample(1:n,n,replace=TRUE)
  bootsample = heart[index,]
  glm.fit = glm(chd ~ age, data=bootsample, family="binomial")
  x = data.frame(age=50)
  beta_0[b] = predict(glm.fit, newdata=x, type='response')
}
sqrt(sum((beta_0-mean(beta_0))^2)/(B-1))

######### Part 3 ###########
prob = predicted_probability
original_se = 0.026
B=100
m=100
Fstar = rep(0,B)
prob_m = rep(0,m)
for(b in 1:B){
  index = sample(1:n, n, replace=TRUE)
  bootsample = heart[index,]
  glm.fit = glm(chd~age, data=bootsample, family="binomial")
  x=data.frame(age=50)
  probability = predict(glm.fit, newdata=x, type='response')
  for(i in 1:m){
    index2 = sample(index,n,replace=TRUE)
    bootsample2 = heart[index2,]
    glm.fit2 = glm(chd~age, data=bootsample2, family='binomial')
    x=data.frame(age=50)
    prob_m[i] = predict(glm.fit2, newdata=x, type='response')
  }
  se_prob = sqrt(sum((prob_m-mean(prob_m))^2)/(m-1))
  Fstar[b] = (probability - prob)/se_prob
}
quantile(Fstar,c(0.025,0.975))
prob + quantile(Fstar,0.025)*original_se
prob + quantile(Fstar,0.975)*original_se
hist(Fstar)

######### Part 4 ###########
library(ggplot2)
library(gridExtra)
heart$famhist <- ifelse(heart$famhist == "Present", 1, 0)
plot(heart)

glm.fit = glm(chd ~ age  + famhist, data=heart,family='binomial')
summary(glm.fit)
glm.fit2 = glm(chd ~ age+famhist+tobacco, data=heart, family='binomial')
summary(glm.fit2)

# Create a contingency table of famhist and tobacco
contingency_table <- table(heart$famhist, heart$tobacco)
# Perform the chi-square test
chi_square_test <- chisq.test(contingency_table)
print(chi_square_test)

glm.fit.interact = glm(chd ~ age + tobacco + famhist + tobacco*famhist ,data=heart,family='binomial') 
summary(glm.fit.interact)
BIC(glm.fit)
BIC(glm.fit2)
BIC(glm.fit.interact)


