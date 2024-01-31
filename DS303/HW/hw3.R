#Neha Maddali HW3
#DS303
#9/11/23

#Question 1: Statistical Inference
library(ISLR2)
head(Carseats)
?Carseats

####################1a.####################
model = lm(Sales ~ . - ShelveLoc, data = Carseats)
summary(model)

####################1b.####################
residual_variance = summary(model)$sigma^2

####################1d.####################
full_model <- lm(Sales ~ . - ShelveLoc, data = Carseats)
reduced_model <- lm(Sales ~ 1, data = Carseats)

RSS_full_model <- sum(resid(full_model)^2)
RSS_reduced_model <- sum(resid(reduced_model)^2)
RSS_full_model
RSS_reduced_model

####################1f.####################
model <- lm(Sales ~ CompPrice + Income + Advertising + Population + Price + Age + Education + Urban + US, data = Carseats)

# Create a data frame for prediction
Xh <- data.frame(
  CompPrice = mean(Carseats$CompPrice),
  Income = median(Carseats$Income),
  Advertising = 15,
  Population = 500,
  Price = 50,
  Age = 30,
  Education = 10,
  Urban = factor("Yes", levels = levels(Carseats$Urban)),
  US = factor("Yes", levels = levels(Carseats$US))
)

predict(model,newdata=Xh)
predict(model,newdata=Xh,interval='confidence',level=0.95)

####################1g.####################
predict(model,newdata=Xh,interval='prediction',level=0.95)

####################1h.####################
Xh <- data.frame(
  CompPrice = mean(Carseats$CompPrice),
  Income = median(Carseats$Income),
  Advertising = 15,
  Population = 500,
  Price = 450,
  Age = 30,
  Education = 10,
  Urban = factor("Yes", levels = levels(Carseats$Urban)),
  US = factor("Yes", levels = levels(Carseats$US))
)

predict(model,newdata=Xh)
predict(model,newdata=Xh,interval='confidence',level=0.95)


#Question 2: The Challenge of Multiple Testing
####################2e.####################
x = matrix(NA, 1000, 200)
for (i in 1:200) {
  x[, i] = rnorm(1000)
}
beta0 = 1
beta1 = 2
beta2 = 3
beta3 = 4
beta4 = 5
beta5 = 6
y = beta0 + beta1 * x[, 1] + beta2 * x[, 2] + beta3 * x[, 3] + beta4 * x[, 4] + beta5 * x[, 5] + rnorm(1000)
data = as.data.frame(cbind(y, x))

fit = lm(y ~ ., data = data)
p_values = summary(fit)$coefficients[, 4]

alpha = 0.05
m = ncol(x)

# Calculate the significance cutoff using alpha/m
cutoff = alpha / m
num_significant = length(which(p_values < cutoff))
num_significant


#Question 3: Diagnostics for MLR
####################3e.####################
m1 = lm(mpg~horsepower,data=Auto)
summary(m1)
par(mfrow=c(2,2))
plot(m1)

# Fit a quadratic polynomial regression model (m2)
m2 = lm(mpg ~ horsepower + I(horsepower^2), data = Auto)
summary(m2)
par(mfrow = c(2, 2))
plot(m2)