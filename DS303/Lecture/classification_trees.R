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

########################
## In-class Activity  ##
########################
## 1. Build a classification tree for this new variables (High vs. Low Sales). 
## use gini index as your criteria. Obtain the training and test misclassification error. 
## 2. How does the tree handle qualitative predictors? Does it create dummy variables? Explain. 
## 3. Prune the tree. Plot the 10-fold CV error as a function of tree size. What is the optimal tree size?
## Note: you'll need to specify: cv.tree(...., FUN = prune.misclass)
## 4. Report the test misclassification error for the pruned tree. Does it benefit from pruning? 
## 5. As a group, discuss why single trees (even after pruning) might still be 
## subject to poor performance on the test set. As we'll see ensembling (or aggregating trees) will lead to superior
## performance. As a group, propose a natural way to aggregate trees and explain why this might help. 


## Work in groups to come up with a solution. 
## Copy and paste your relevant code on Ed Discussion. 
## Please be sure to list all your group members names. Only one group member needs to post on Ed Discussion. 
## link: https://edstem.org/us/courses/42400/discussion/


