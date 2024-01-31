#Neha Maddali HW2
#DS303
#9/5/23

#Question 1: Properties of Least Square Estimators via Simulations
####################1b.####################
X1 = seq(0,10,length.out =100) #generates 100 equally spaced values from 0 to 10.
X2 = runif(100) #generates 100 uniform values.
n = 100
beta_0 = 2
beta_1 = 3
beta_2 = 5

error = rnorm(n,0,1)
Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
Y

####################1c.####################
plot(X1, Y)
plot(X2, Y)

####################1d.####################
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
  fit = lm(Y~X1 + log(X2))
  beta1hat[i] = fit$coefficients[[2]]
}
mean(beta1hat)

####################1e.####################
hist(beta1hat)
abline(v=beta_1, col="blue")

####################1f.####################
B = 5000
beta0hat = beta1hat = beta2hat = rep(NA,B)
for(i in 1:B){
  error = rnorm(n,0,1)
  Y = beta_0 + beta_1*X1 + beta_2*log(X2) + error 
  fit = lm(Y~X1 + log(X2))
  beta2hat[i] = fit$coefficients[[3]]
}
mean(beta2hat)

####################1g.####################
hist(beta2hat)
abline(v=beta_2, col="blue")


#Question 3: Expected test MSE
####################3a.####################
set.seed(1)
n = 100
beta0 = 1
beta1 = 1
beta2 = 1
X1 = seq(0, 5, length.out = n)
error = rnorm(n, 0, 1)
Y = beta0 + beta1 * X1 + beta2 * X1^2 + error
Y
plot(X1, Y, main = "Scatterplot of Y against X1", xlab = "X1", ylab = "Y")

####################3b.####################
set.seed(2)
num_train_sets = 1000
n = 100
num_models = 5
predicted_values = matrix(NA, nrow = num_train_sets, ncol = num_models)

for (i in 1:num_train_sets) {
  e = rnorm(n, 0, 1)
  Y_train = beta0 + beta1 * X1 + beta2 * X1^2 + e
  
  # Train models of increasing complexity
  for (j in 1:num_models) {
    # Fit polynomial regression models of increasing order
    model = lm(Y_train ~ poly(X1, j))
    
    # Predict Y when X1 = 1 and store the predicted value
    predicted_values[i, j] = predict(model, newdata = data.frame(X1 = 1))
  }
}
for (j in 1:num_models) {
  cat(paste("Predicted values for Model M", j, ":\n"))
  cat(predicted_values[1:5, j], "\n\n")
}

####################3c.####################
num_test_obs = 1000
x0 = rep(1, num_test_obs)
error = rnorm(num_test_obs, 0, 1)
y0 = beta0 + beta1 * x0 + beta2 * x0^2 + error
head(data.frame(x0, y0), 5)

####################3d.####################
expected_test_mses = numeric(num_models)
for (j in 1:num_models) {
  # Calculate the squared differences between predicted and true values
  squared_diff = (predicted_values[, j] - y0)^2
  # Calculate the mean squared difference to get the MSE
  expected_test_mses[j] = mean(squared_diff)
}
expected_test_mses

####################3e.####################
model_complexity = 1:num_models
plot(model_complexity, expected_test_mses, type = "b", 
     xlab = "Model Complexity", ylab = "Expected Test MSE",
     main = "Expected Test MSE vs. Model Complexity",
     pch = 19, col = "blue")
