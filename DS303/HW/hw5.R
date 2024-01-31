#Neha Maddali HW5
#DS303
#10/2/23

#############################################
### Problem 1: Multiple Linear Regression ###
#############################################
library(ISLR2)
library(car)
library(ggplot2)
library(gridExtra)

head(Boston)
plot(Boston)
full_model = lm(medv ~ ., data=Boston)
summary(full_model)
par(mfrow=c(2,2))
plot(full_model)
vif(full_model)

model1 = lm(medv~.-tax-rad, data=Boston)
vif(model1)
par(mfrow=c(2,2))
plot(model1)

#split the data into 80 train, 20 test
set.seed(12)
index = sample(nrow(Boston), nrow(Boston) * 0.80)
train_data = Boston[index, ]
test_data = Boston[-index, ]

#build a multiple linear regression model
model1.on.train = lm(medv ~ .-tax-rad, data = train_data)
model1.on.train.sum = summary(model1)
model1.on.train.sum
par(mfrow = c(2,2))
plot(model1.on.train)

#Looking at model summary, we see that variables indus and age are insignificant
#Building model without variables tax,rad,indus,age
model2 = lm(medv ~ . -tax-rad-indus -age, data = train_data)
model2.sum = summary(model2)
model2.sum
par(mfrow = c(2,2))
plot(model2)

#best subset selection
model.subset = regsubsets(medv ~ ., data = train_data, nbest = 1, nvmax = 13)
model.subset.sum = summary(model.subset)
model.subset.sum
names(model.subset.sum)

n = dim(Boston)[1]
p = rowSums(model.subset.sum$which)
adjr2 = model.subset.sum$adjr2
cp = model.subset.sum$cp
rss = model.subset.sum$rss
AIC = n*log(rss/n) + 2*(p)
BIC = n*log(rss/n) + (p)*log(n)

cbind(p,rss,adjr2,cp,AIC,BIC)
plot(p,BIC)
plot(p,AIC)
which.min(AIC)
coef(model.subset,11)

model3 = lm(medv ~ crim+zn+chas+nox+rm+dis+rad+tax+ptratio+black+lstat, data=train_data)
model3.sum = summary(model3)
model3.sum
par(mfrow=c(2,2))
plot(model3)

# This is to check if there are any non-linear relationships 
# between medv and the remaining predictors we've selected.
subset_data = Boston[c("crim", "zn", "chas", "nox", "rm", "dis", "ptratio", "lstat", "black", "medv")]
ggplots = lapply(names(subset_data)[-10], function(var) {
  ggplot(subset_data, aes(x = get(var), y = medv)) +
    geom_point() +
    geom_smooth(method = "lm", se = TRUE, col = "blue") +
    labs(x = var)
})
grid.arrange(grobs = ggplots, ncol = 3)

model4 = lm(medv ~ crim+zn+chas+nox+rm+dis+ptratio+
              poly(lstat,2)+black, data = train_data)
model4.sum = summary(model4)
model4.sum
par(mfrow = c(2,2))
plot(model4)

final.model = lm(medv ~ crim+chas+nox+rm+dis+ptratio+
                   poly(lstat,2)+black, data = train_data)
final.model.sum = summary(final.model)
final.model.sum
par(mfrow = c(2,2))
plot(final.model)

#evaluate model 4 and final model on test set
M4_medv = predict(model4, newdata=test_data)
mean((test_data$medv - M4_medv)^2)
Mfinal_medv = predict(final.model, newdata=test_data)
mean((test_data$medv - Mfinal_medv)^2)

################################################################
# LOOCV for Model 4
n = nrow(train_data)  # Number of observations
MSE_Model4 = numeric(n)  # Initialize vector to store mean squared errors

for (i in 1:n) {
  # Leave one observation out
  test_obs = train_data[i, ]
  train_obs = train_data[-i, ]
  model4_loocv = lm(medv ~ crim + zn + chas + nox + rm + dis + ptratio +
                       poly(lstat, 2) + black, data = train_obs)
  prediction = predict(model4_loocv, newdata = test_obs)
  MSE_Model4[i] = (test_obs$medv - prediction)^2
}
LOOCV_MSE_Model4 = mean(MSE_Model4)
LOOCV_MSE_Model4

# LOOCV for Final Model
n = nrow(train_data)  # Number of observations
MSE_FinalModel = numeric(n)  # Initialize vector to store mean squared errors

for (i in 1:n) {
  # Leave one observation out
  test_obs = train_data[i, ]
  train_obs = train_data[-i, ]
  finalmodel_loocv = lm(medv ~ crim + chas + nox + rm + dis + ptratio +
                       poly(lstat, 2) + black, data = train_obs)
  prediction = predict(finalmodel_loocv, newdata = test_obs)
  MSE_FinalModel[i] = (test_obs$medv - prediction)^2
}
LOOCV_MSE_FinalModel = mean(MSE_FinalModel)
LOOCV_MSE_FinalModel


#############################################
## Problem 2: Forward + Backward Selection ##
#############################################
library(ISLR2)
library(leaps)
str(College)
################## 2c. ####################
set.seed(12)

#split the data into training 90% and test 10%
n = nrow(College)
train_indices = sample(1:n, 0.9*n)
train_data = College[train_indices, ]
test_data = College[-train_indices, ]

#perform forward selection on training set
regfit.fwd = regsubsets(Apps~., data=train_data, nvmax=17, method="forward")
regfitFWD.sum = summary(regfit.fwd)
n = dim(College)[1]
p = rowSums(regfitFWD.sum$which)
rss = regfitFWD.sum$rss
AIC = n*log(rss/n) + 2*(p)
cbind(p,AIC)
which.min(AIC)
coef(regfit.fwd,12)

#perform backward selection on training set
regfit.bwd = regsubsets(Apps~., data=train_data, nvmax=17, method="backward")
regfitBWD.sum = summary(regfit.bwd)
n = dim(College)[1]
p = rowSums(regfitBWD.sum$which)
rss = regfitBWD.sum$rss
AIC = n*log(rss/n) + 2*(p)
cbind(p,AIC)
which.min(AIC)
coef(regfit.bwd,12)

# Fit the forward and backward selected model on the training data
final_model_fwd = lm(Apps ~ Private + Accept + Enroll + 
                       Top10perc + Top25perc + P.Undergrad + 
                       Outstate + Room.Board + PhD + S.F.Ratio + 
                       Expend + Grad.Rate, data = train_data)
final_model_bwd = lm(Apps ~ Private + Accept + Enroll + 
                       Top10perc + Top25perc + P.Undergrad + 
                       Outstate + Room.Board + PhD + S.F.Ratio + 
                       Expend + Grad.Rate, data = train_data)

# Predict using both models on the test set
predictions_fwd = predict(final_model_fwd, newdata = test_data)
predictions_bwd = predict(final_model_bwd, newdata = test_data)

# Calculate residuals for the forward and backward model
residuals_fwd = test_data$Apps - predictions_fwd
residuals_bwd = test_data$Apps - predictions_bwd

# Calculate MSE for the forward and backward model
mse_fwd = mean(residuals_fwd^2)
mse_bwd = mean(residuals_bwd^2)


###########################################
###### Problem 4: Interaction Terms #######
###########################################
library(ISLR2)
library(leaps)
head(Credit)
################## 4a. ####################
str(Credit)

################## 4b. ####################
fit = lm(Balance~Income+Student,data=Credit)
summary(fit)

################## 4e. ####################
plot(Credit$Income, Credit$Balance, xlab = "Income", ylab = "Balance", pch = 20, col = Credit$Student)
abline(lm(Balance ~ Income, data = Credit[Credit$Student == "Yes", ]), col = "blue")
abline(lm(Balance ~ Income, data = Credit[Credit$Student == "No", ]), col = "red")
legend("topright", legend = c("Student", "Non-Student"), col = c("blue", "red"), lty = 1)

################## 4f. ####################
fit_interaction = lm(Balance ~ Income + Student + Income:Student, data=Credit)
summary(fit_interaction)