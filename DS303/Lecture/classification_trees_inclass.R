library(ISLR2)
library(tree)

head(Carseats)
# response is Sales 
# We will convert it to a binary variable

Carseats$High <- factor(ifelse(Carseats$Sales <=8, "No", "Yes"))
head(Carseats)

set.seed(6)
train <- sample(1:nrow(Carseats), 200)
Carseats.test <- Carseats[-train, ]

#tree.carseats0 = tree(High~.-Sales, split=c("deviance"), data=Carseats, subset=train)
tree.carseats = tree(High~.-Sales, split=c("gini"), data=Carseats, subset=train)

## deviance (is like a goodness of fit): small deviance indicates 
## a tree is a good fit to the (training) data. Closely related to entropy. 

summary(tree.carseats)

# training misclassification error is reported

plot(tree.carseats)
text(tree.carseats,pretty=0)

## How does the tree handle qualitivative predictors? 
## The second split is on Shelving Location: 
## good locations (right branch)
## bad/medium locations (left branch)

tree.carseats
# this output gives details on each split :
# split: split criterion: 
# n: the number of observations
# deviance: goodness of fit
# yval: overall prediction for the branch
# yprob: fraction of observations in that branch that are 'No' or 'Yes'
## branches that lead to terminal nodes are indicated using asterisks

## training error
tree.train.pred = predict(tree.carseats, Carseats[train,], type='class')
mean(tree.train.pred!=Carseats$High[train])
table(tree.train.pred,Carseats$High[train])

## test error
tree.pred = predict(tree.carseats, Carseats.test, type='class')
table(tree.pred,Carseats.test$High)

## test misclassifcation error 
mean(tree.pred!=Carseats.test$High)

## pruning tree
set.seed(7)
cv.carseats = cv.tree(tree.carseats, FUN = prune.misclass) ## FUN = prune.misclass indicates that we want to the classification error rate to guide cross-validation and pruning process (default is deviance)
cv.carseats

## despite its name, dev corresponds to the cross-validation errors
## k corresponds to alpha
plot(cv.carseats$size, cv.carseats$dev, type = "b")

which.min(cv.carseats$dev)
cv.carseats$size[5]

## obtain pruned tree with 5 terminal nodes
prune.carseats <- prune.misclass(tree.carseats, best=5)
plot(prune.carseats)
text(prune.carseats,pretty=0)

tree.pred2 = predict(prune.carseats,Carseats.test, type='class')
table(tree.pred2,Carseats.test$High)
mean(tree.pred2==Carseats.test$High)
mean(tree.pred2!=Carseats.test$High)

