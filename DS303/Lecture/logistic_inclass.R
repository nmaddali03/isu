x = c(-2, 5, -1, 10, 6)
y = c(0,1,0,1,1)
data = data.frame(x,y)
head(data)

summary(glm(y~x, data=data, family="binomial"))

library(ggplot2)
ggplot(data,aes(x=x, y=y, color=y)) + geom_point(size=2)

beta0 = 0
beta1 = 1
exp(beta0+beta1*5)/(1+exp(beta0+beta1*5))
