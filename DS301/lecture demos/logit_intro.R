library(ISLR2)
head(Default)
dim(Default)

set.seed(7)
train = sample(1:nrow(Default),nrow(Default)/2, replace=FALSE)
test = (-train)

glm.fit = glm(default~student+balance, data=Default,subset=train,family='binomial')

# use summary argument
summary(glm.fit)
head(glm.fit$fitted.values) #P(Y=1|X) 
head(Default[train,])

glm.prob = predict(glm.fit,Default[test,],type='response') 
head(glm.prob) #P(Y=1|X)
head(Default[test,])
## These just output your the predicted probability. 

#We know that these values correspond to the probability of the market going up, rather than down, because the contrasts() function indicates that R has created a dummy variable with a 1 for Yes
contrasts(Default$default)

# How do we actually want to classify our test set? 
glm.pred = rep('No',length(test))
glm.pred[glm.prob >0.5] ='Yes'
table(glm.pred,Default[test,]$default) #rows are predicted, # columns are true 
# This matrix is called our confusion matrix

# what is our misclassification rate? 
1-mean(glm.pred == Default[test,]$default)

# Is this misclassification any good? What if I used a simple (but useless classifier) 
# that always classifies people as 'No' for Default?
# What would my misclassification rate be? 

# Looking at misclassifcation rate is not always the most meaningful thing, 
# especially if your categories are highly unbalanced. 
# In this context, what kind of error is more expensive for the bank? 

# Among individuals that actually defaulted, what is my misclassification rate? 

## using 0.5 as your threshold, will give you the lowest overall misclassification rate. 

## you may care about specific misclassification rates more, and then you should adjust thresholding accordingly. 

