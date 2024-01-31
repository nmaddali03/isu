x = matrix(NA,1000,150)

for(i in 1:150){
  x[,i] = rnorm(1000)
}

y = rnorm(1000)

data = as.data.frame(cbind(y,x))
head(data)

fit = lm(y~.,data=data)
summary(fit)

p_values = summary(fit)$coefficients[,4]  
length(which(p_values<0.05))

