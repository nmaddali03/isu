#Neha Maddali Midterm 1
#110122037
#DS303
#9/22/23

######### Problem 2 ###########
set.seed(1)
n=100
x = runif(n, min=0, max=2)
error=rnorm(n,0,1)
y = 4 + x + x^2 + x^3 + error
train_set = data.frame(x,y)

M1 = lm(y~x, data = train_set)
M2 = lm(y~poly(x,degree=2), data = train_set)
M3 = lm(y~poly(x,degree=3), data = train_set)
M4 = lm(y~poly(x,degree=5), data = train_set)
M5 = lm(y~poly(x,degree=11), data = train_set)


######### Problem 2.1 ###########
num_simulations = 1000
n = 100
x_pred = 0.9
predicted_values = matrix(NA, nrow=num_simulations, ncol=5)

for(i in 1: num_simulations){
  x = runif(n, min=0, max=2)
  error = rnorm(n, 0, 1)
  y = 4 + x + x^2 + x^3 + error
  train_set = data.frame(x, y)
  
  M1 = lm(y~x, data = train_set)
  M2 = lm(y~poly(x,degree=2), data = train_set)
  M3 = lm(y~poly(x,degree=3), data = train_set)
  M4 = lm(y~poly(x,degree=5), data = train_set)
  M5 = lm(y~poly(x,degree=11), data = train_set)
  
  predicted_values[i, 1] = predict(M1, newdata = data.frame(x = x_pred))
  predicted_values[i, 2] = predict(M2, newdata = data.frame(x = x_pred))
  predicted_values[i, 3] = predict(M3, newdata = data.frame(x = x_pred))
  predicted_values[i, 4] = predict(M4, newdata = data.frame(x = x_pred))
  predicted_values[i, 5] = predict(M5, newdata = data.frame(x = x_pred))
}

head(predicted_values)

######### Problem 2.2 ###########
bias_squared_values = numeric(5)
complexities = c(1, 2, 3, 5, 11)  # Corresponding to M1 to M5
x_pred = 0.9

for (i in 1:5) {
  current_model = lm(y ~ poly(x, degree = complexities[i]), data = train_set)
  predicted_value = predict(current_model, newdata = data.frame(x = x_pred))
  bias_squared = (predicted_value - (4 + x_pred + x_pred^2 + x_pred^3))^2  # True population value
  bias_squared_values[i] = bias_squared
}
plot(complexities, bias_squared_values, type = "b", 
     xlab = "Model Complexity (Degree)", ylab = "Bias-Squared",
     main = "Bias-Squared vs. Model Complexity at x = 0.9",
     xlim = c(1, 11), ylim = c(0, max(bias_squared_values) + 0.1))

######### Problem 2.3 ###########
variance_values = numeric(5)
complexities = c(1, 2, 3, 5, 11)  # Corresponding to M1 to M5
x_pred = 0.9

for (i in 1:5) {
  current_model = lm(y ~ poly(x, degree = complexities[i]), data = train_set)
  num_simulations = 1000  # Number of simulations
  predicted_values = numeric(num_simulations)
  
  for (j in 1:num_simulations) {
    x_sim = runif(n, min = 0, max = 2)
    error_sim = rnorm(n, 0, 1)
    y_sim = 4 + x_sim + x_sim^2 + x_sim^3 + error_sim
    train_set_sim = data.frame(x_sim, y_sim)
    
    predicted_value = predict(current_model, newdata = data.frame(x = x_pred))
    predicted_values[j] = predicted_value
  }
  variance_value = var(predicted_values)
  variance_values[i] = variance_value
}
plot(complexities, variance_values, type = "b", 
     xlab = "Model Complexity (Degree)", ylab = "Variance",
     main = "Variance vs. Model Complexity at x = 0.9",
     xlim = c(1, 11), ylim = c(0, max(variance_values) + 0.1))


######### Problem 2.5 ###########
set.seed(1)
n_test = 100
x_test = runif(n_test, min = 0, max = 2)
expected_test_mse = numeric(5)

# Loop through each model complexity
for (i in 1:5) {
  test_mse_values = numeric(1000)  # Number of simulations
  
  for (j in 1:1000) {
    error_test = rnorm(n_test, 0, 1)
    y_test = 4 + x_test + x_test^2 + x_test^3 + error_test
    current_model = lm(y ~ poly(x, degree = i), data = train_set)
    predicted_values = predict(current_model, newdata = data.frame(x = x_test))
    test_mse = mean((y_test - predicted_values)^2)
    test_mse_values[j] = test_mse
  }
  expected_test_mse[i] = mean(test_mse_values)
}
expected_test_mse

######### Problem 2.7 ###########
irreducible_error_estimates = numeric(5)

for (i in 1:5) {
  current_model = lm(y ~ poly(x, degree = i), data = train_set)
  residuals = residuals(current_model)
  irreducible_error_estimate = var(residuals) #caculate variance
  
  # Store the irreducible error estimate for the current model
  irreducible_error_estimates[i] = irreducible_error_estimate
}
irreducible_error_estimates



