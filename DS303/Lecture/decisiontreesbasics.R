## Fitting Regression Trees

library(MASS)
head(Boston)

set.seed(11)
train = sample(1:nrow(Boston),nrow(Boston)/2)

#install.packages('tree')
library(tree)
tree.boston = tree(medv~.,data=Boston, subset=train)

tree.boston
# this output gives details on each split :
# split: split criterion: 
# n: the number of observations
# deviance: goodness of fit (smaller is better)
# yval: overall prediction for the branch

summary(tree.boston)
# indicates that only four of the variables have been used in constructing the tree.
# deviance is simply the sum of squared errors for the tree

plot(tree.boston)
text(tree.boston,pretty=0)

# ?tree.control
# control = tree.control(nobs = length(train), mindev=0)
# 
# tree.boston2 = tree(medv~.,data=Boston, subset=train,control = control)
# plot(tree.boston2)
# text(tree.boston2,pretty=0)

test =  Boston[-train,]
tree.pred = predict(tree.boston, newdata=test)

Y.test = Boston[-train,"medv"]
mean((tree.pred - Y.test)^2)

## pruning ##
cv.boston = cv.tree(tree.boston) #performs CV in on order to the determine the optimal level of tree complexity. 

cv.boston 

#size: number of terminal nodes (leaves)
#dev: CV error
#k: corresponds to alpha in our notation (tuning parameter)

plot(cv.boston$size,cv.boston$dev,type='b') # plot CV error as a function of size of tree 

prune.boston= prune.tree(tree.boston,best=7) #best represents the size of a specific subtree in the cost-complexity sequence to be returned

plot(prune.boston)
text(prune.boston,pretty=0)

tree.prune = predict(prune.boston,newdata=test)
mean((tree.prune - Y.test)^2)

