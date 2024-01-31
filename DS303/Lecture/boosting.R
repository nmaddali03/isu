### Boosting

#install.packages("gbm")
library(gbm)
library(ISLR2)
set.seed(1)
train = sample(1:nrow(Boston),nrow(Boston)/2)

# distribution = "gaussian" for regression problem. 
# distribution = "bernoulli" for classification problem.

set.seed(1)
boost.boston = gbm(medv~.,data=Boston[train,], distribution = "gaussian", n.trees=5000, interaction.depth = 4, shrinkage = c(0.01)) #default for shrinkage is 0.001
summary(boost.boston)
# provides a relative influence plot and outputs relative influence statistics 

# partial dependence plots
# illustrate marginal effect of the selected variables on the response after 
# integrating out the other variables
plot(boost.boston, i = 'rm')
plot(boost.boston, i = 'lstat')

yhat.boost = predict(boost.boston, newdata=Boston[-train,], n.trees=5000)
boston.test = Boston[-train,"medv"]

mean((yhat.boost-boston.test)^2)

########### grid search #############
library(caret)

formula <- medv~.

mygrid <- expand.grid(interaction.depth = seq(1, 5, by = 1),
                        n.trees = c(100,200,300),
                        n.minobsinnode = 5,
                        shrinkage = c(0.001,0.01,0.1))

set.seed(100)
gbm_model <- train(formula, 
                   data = Boston[train,],
                   method = "gbm",
                   tuneGrid = mygrid,
                   trControl = trainControl(method = "cv",number=10))
