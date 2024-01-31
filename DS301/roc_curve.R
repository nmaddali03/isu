library(ISLR2)
head(Default)
dim(Default)

set.seed(7)
train = sample(1:nrow(Default),nrow(Default)/2, replace=FALSE)
test = (-train)

glm.fit = glm(default~student+balance, data=Default,subset=train,family='binomial') 
# use subset argument
summary(glm.fit)

glm.prob = predict(glm.fit,Default[test,],type='response') #
head(glm.prob)

## These just output for you the predicted probability. 

glm.pred = rep('No',length(test))
glm.pred[glm.prob >0.139] ='Yes'
table(glm.pred,Default[test,]$default) #rows are predicted, # columns are true 
# This matrix is called our confusion matrix

# what is our misclassification rate? 
1-mean(glm.pred == Default[test,]$default)

# plots trade off between true positive rate (power or sensitivity) and false positive (type 1 error or 1 - specificity)
#install.packages('ROCR')
library(ROCR)

ROCRpred <- prediction(glm.prob,Default[test,]$default)
plot(performance(ROCRpred,'tpr','fpr'))

plot(performance(ROCRpred,'tpr','fpr'),colorize=TRUE,
     print.cutoffs.at=seq(0,1,by=0.05), text.adj=c(-0.2,1.7))

plot(performance(ROCRpred,'tnr','fnr'),colorize=TRUE,
     print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

perf = performance(ROCRpred,'tpr','fpr')
thresholds = data.frame(threshold = perf@alpha.values[[1]],fpr = perf@x.values[[1]], tpr = perf@y.values[[1]])

fpr0.05 = subset(thresholds,fpr<0.01)

## obtain area under the curve, evaluates overall performance of a classifier
## this can be useful if you are comparing multiple classifiers

auc_ROCR <- performance(ROCRpred, measure = "auc")
auc_ROCR@y.values[[1]] 

# we expect a classifier that performs no better than chance to have an AUC of 0.5
