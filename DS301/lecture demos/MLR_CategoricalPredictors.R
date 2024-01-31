##############################
### Qualitative predictors ###
##############################
# R can handle qualitative predictors as long as they are stored as factors()

library(ISLR2)
head(Credit)
str(Credit)

summary(lm(Balance~Limit+Region,data=Credit))


# What are the fitted regression lines for each category of region? 


# If your qualitative predictor has more than 2 levels, 
# you can check the 'reference' or 'baseline' category in R
contrasts(Credit$Region)

## Can change baseline:
Credit$Region <- relevel(Credit$Region, ref = "South")

summary(lm(Balance~Limit+Region,data=Credit))

## prediction with categorical variables 
m1 = lm(Balance~Limit+Region,data=Credit)