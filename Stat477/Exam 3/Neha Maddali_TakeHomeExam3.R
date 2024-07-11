library(ggplot2)
library(pROC)
library(ResourceSelection)

data<- read.csv(file.choose(), header=T)

# Convert categorical variables to factors
data$IVHX <- factor(data$IVHX)
data$RACE <- factor(data$RACE)
data$DUR <- factor(data$DUR)
data$PROG <- factor(data$PROG)

# Start with a full model including all explanatory variables
full_model <- glm(DFREE ~ AGE + BECK + IVHX + NDTX + RACE, data = data, family = binomial)

# Use AIC to select the best model
best_model <- step(full_model, direction = "both", trace = FALSE)
summary(best_model)

# Extract the explanatory variables in the final model
explanatory_variables <- names(coef(best_model))[-1]  # Exclude intercept
explanatory_variables

# Perform likelihood ratio test
lr_test <- anova(best_model, test = "Chisq")

# Extract test statistic and p-value
test_statistic <- lr_test$Deviance[2]  # Test statistic
p_value <- lr_test$"Pr(>Chi)"[2]      # p-value

# Report the results
cat("Likelihood Ratio Test:\n")
cat("Test Statistic:", test_statistic, "\n")
cat("P-value:", p_value, "\n")

confusion.glm <- function(model, cutoff = 0.5) {
  predicted <- ifelse(predict(model, type='response') > cutoff, 
                      1, 0)
  observed <- model$y
  confusion <- table(observed, predicted)
  agreement <- sum(diag(confusion)) / sum(confusion)
  sensitivity <- confusion[2, 2] / sum(confusion[2, ])
  specificity <- confusion[1, 1] / sum(confusion[1, ])
  positive_predictive_value <- confusion[2, 2] / sum(confusion[, 2])
  negative_predictive_value <- confusion[1, 1] / sum(confusion[, 1])
  list("Confusion Table" = confusion, 
       "Agreement" = agreement, 
       "Sensitivity" = sensitivity,
       "Specificity" = specificity,
       "Positive Predictive Value" = positive_predictive_value,
       "Negative Predictive Value" = negative_predictive_value)
}

confusion_stats <- confusion.glm(best_model)


# Predicted probabilities from the best logistic regression model
predicted_probabilities <- predict(best_model, type = "response")

# Create a ROC curve
roc_curve <- roc(data$DFREE, predicted_probabilities)
plot(roc_curve, main = "ROC Curve for Drug-Free Prediction Model",
     xlab = "False Positive Rate", ylab = "True Positive Rate")

auc_value <- auc(roc_curve)
auc_value
