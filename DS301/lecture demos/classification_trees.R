library(ISLR2)
library(tree)

head(Carseats)
# response is Sales 
# We will convert it to a binary variable

Carseats$High <- factor(ifelse(Carseats$Sales <=8, "No", "Yes"))
head(Carseats)

set.seed(2)
train <- sample(1:nrow(Carseats), 200)
Carseats.test <- Carseats[-train, ]

tree.carseats = tree(High~.-Sales, split=c("gini"), data=Carseats, subset=train)

tree.carseats = tree(High~.-Sales, split=c("deviance"), data=Carseats, subset=train)

summary(tree.carseats)

# training error = 12%
# deviance (is like a goodness of fit): small deviance indicates a tree is a good fit to the (training) data. Closely related to entropy. 

plot(tree.carseats)
text(tree.carseats,pretty=0)

## trees work on qualitative predictors (without having to create dummy variables)

## The second split is on Shelving Location: 
## good locations (right branch)
## bad/medium locations (left branch)

tree.carseats
# this output gives details on each split :
# split: split criterion: 
# n: the number of observations
# deviance: goodness of fit
# yval: overall prediction for the branch
# yprob: fraction of observations in that branch that are 'Yes' or 'No'

## branches that lead to terminal nodes are indicated using asterisks

tree.pred = predict(tree.carseats, Carseats.test, type='class')
table(tree.pred,Carseats.test$High)

## pruning tree

set.seed(7)
cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass) ## FUN = prune.misclass indicates that we want to the classification error rate to guide cross-validation and pruning process (default is deviance)
cv.carseats

## despite its name, dev corresponds to the cross-validation errors
## k corresponds to alpha
plot(cv.carseats$size, cv.carseats$dev, type = "b")

which.min(cv.carseats$dev)
cv.carseats$size[4]

## obtain pruned tree with 9 terminal nodes
prune.carseats <- prune.misclass(tree.carseats, best=9)
plot(prune.carseats)
text(prune.carseats,pretty=0)

tree.pred2 = predict(prune.carseats,Carseats.test, type='class')
table(tree.pred2,Carseats.test$High)
