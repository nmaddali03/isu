#Neha Maddali HW1
#DS303
#8/22/23

#Question 3: Multiple linear regression
install.packages("ISLR2") #you only need to do this one time.
library(ISLR2) #you will need to do this every time you open a new R session
head(Boston)
?Boston

####################3a.####################
str(Boston)

####################3b.####################
df<-as.numeric(Boston$crim)
mean(df)
summary(Boston) #another way to find the average per capita crime rate across all suburbs

####################3c.####################
average_crime_near_charles <- mean(Boston$crim[Boston$chas == 1], na.rm = TRUE)
average_crime_away_from_charles <- mean(Boston$crim[Boston$chas == 0], na.rm = TRUE)
cat("Average crime rate for suburbs near Charles River:", average_crime_near_charles)
cat("Average crime rate for suburbs away from Charles River:", average_crime_away_from_charles)

####################3d.####################
high_crime_threshold <- quantile(Boston$crim, 0.75)
high_crime_suburbs <- Boston[Boston$crim > high_crime_threshold, ]
summary_statistics <- summary(Boston$crim)
print(summary_statistics)

library(ggplot2)
ggplot(data = Boston, aes(x = crim)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  geom_vline(xintercept = high_crime_threshold, linetype = "dashed", color = "red") +
  geom_text(data = data.frame(x = high_crime_threshold, label = "High Crime Threshold"),
            aes(x, label = label, y = 40), color = "red", vjust = -1) +
  labs(x = "Crime rate", y = "Number of Suburbs") +
  theme_minimal()

####################3e.####################
correlation_matrix <- cor(Boston)
correlations_with_crim <- correlation_matrix[, "crim"]
sorted_correlations <- sort(correlations_with_crim, decreasing = TRUE)

correlation_df <- data.frame(
  Predictor = colnames(correlation_matrix),
  Correlation_with_Crime = correlations_with_crim
)

correlation_df <- correlation_df[order(-correlation_df$Correlation_with_Crime), ]
print(correlation_df)

####################3f.####################
model <- lm(crim ~ lstat, data = Boston)
summary_model <- summary(model)
print(summary_model)
coefficients_simple <- model$coefficients

####################3h.####################
predictors <- colnames(Boston)[-1] # All predictors but crim
results_table <- data.frame(Predictor = character(0),
                            Intercept = numeric(0),
                            Coefficient = numeric(0),
                            Pvalue = numeric(0),
                            Significant = character(0)
)

for (predictor in predictors){
  model <- lm(crim ~ ., data = Boston[, c("crim", predictor)])
  summary_data <- summary(model)
  p_value <- summary_data$coefficients[2,4]
  significant <- ifelse(p_value < 0.05, "Yes", "No")
  
  results_table <- rbind(results_table,
                         data.frame(Predictor = predictor,
                                    Intercept = coef(model)[1],  # Add Intercept value
                                    Coefficient = coef(model)[2],
                                    Pvalue = p_value,
                                    Significant = significant))
  
  plot(Boston[, predictor], Boston$crim,
       main = paste("Crime Rate vs.", predictor),
       xlab = predictor,
       ylab = "Crime Rate")
  abline(model, col = "blue")
}
print(results_table)

####################3i.####################
full_model <- lm(crim ~ ., data = Boston)
summary_full_model <- summary(full_model)
coefficients_multiple <- summary_full_model$coefficients
results_table <- data.frame(
  Predictor = rownames(coefficients_multiple),
  Coefficient = coefficients_multiple[, 1],
  Std_Error = coefficients_multiple[, 2],
  p_value = coefficients_multiple[, 4],
  significance = ifelse(coefficients_multiple[, 4] < 0.05, "*", ""),
  stringsAsFactors = FALSE
)
print(results_table)

####################3j.####################
simple_reg_coefficients <- c(-0.07, 0.50, -1.89, 31.24, -2.68, 0.10, -1.55, 0.61, 0.29, 1.15, 0.54, -0.36)
multiple_reg_coefficients <- c(0.045, -0.058, -0.82, -9.95, 0.62, -0.0008, -1.01, 0.61, -0.003, -0.30, 0.13, -0.22)
predictors <- colnames(Boston)[-1] # All predictors but crim
barplot(rbind(simple_reg_coefficients, multiple_reg_coefficients),
        beside = TRUE, col = c("blue", "red"),
        names.arg = predictors,
        ylim = c(-15, 35),
        xlab = "Predictor",
        ylab = "Coefficient",
        main = "Comparison of Coefficients")
legend("topright", legend = c("Simple Regression", "Multiple Regression"),
       fill = c("blue", "red"), bty = "n")

####################3k.####################
set.seed(1) 
n = nrow(Boston)
train_index = sample(1:n,n/2,rep=FALSE)
train_Boston = Boston[train_index,]
test_Boston = Boston[-train_index,]

model_train = lm(crim~.,data=train_Boston)
MSE_train = mean((train_Boston$crim - model_train$fitted.values)^2) 
MSE_train

predicted_values = predict(model_train,test_Boston)
MSE_test = mean((test_Boston$crim - predicted_values)^2)
MSE_test

####################3l.####################
model_train=lm(crim~zn+indus+nox+dis+rad+ptratio+medv, data=train_Boston)
MSE_train = mean((train_Boston$crim - model_train$fitted.values)^2)
MSE_train

predicted_values = predict(model_train, test_Boston)
MSE_test = mean((test_Boston$crim - predicted_values)^2)
MSE_test
