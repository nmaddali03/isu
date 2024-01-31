########################
## In-class Activity  ##
########################

## Adapt the code from shrinkage_methods to implement elastic net on the Hitters dataset. 
## You now have two tuning parameters (alpha and lambda) to tune. 
## (1) Report your optimal alpha and lambda from the training set. 
## (2) Report your test MSE for elastic net. 


Hitters = na.omit(Hitters)
x = model.matrix(Salary~.,data=Hitters)[,-1] 
#the [,-1] removes the intercept term. 
Y = Hitters$Salary


set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]

grid = 10^seq(10,-2,length=100)

## Work in groups to come up with a solution. 
## Copy and paste your relevant code on Ed Discussion. 
## Please be sure to list all your group members names. Only one group member needs to post on Ed Discussion. 
## link: https://edstem.org/us/courses/42400/discussion/


