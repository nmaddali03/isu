library(ISLR2)
head(Smarket) # consists of percentage returns for the S&P 500 stock index over 1250 days from 2001 - 2005

# For each date, recorded the percentage returns for each of the previous trading days (Lag1 - Lag5)

# Volume (number of shares traded)
# Today (percentage return on the date in question)
# Direction (whether the market was up or down on this date)


train = (Smarket$Year<2005)
Smarket.2005 = Smarket[!train,]
dim(Smarket.2005)


###########
### lda ###
###########
#install.packages("MASS")
library(MASS)

lda.fit = lda(Direction~Lag1+Lag2,data=Smarket, subset=train)

lda.fit

lda.pred = predict(lda.fit,Smarket.2005)
names(lda.pred)


head(lda.pred$class) # automatically assigns Y to the class with largest probability 
head(lda.pred$posterior)
#P(Y=0|X)
#P(Y=1|X)

table(lda.pred$class,Smarket.2005$Direction)
mean(lda.pred$class!=Smarket.2005$Direction) #misclassification rate (on test set)
mean(lda.pred$class==Smarket.2005$Direction) # correct classification rate (on the test set)

#if you want to adjust the threshold, look at the posterior probabilities 
lda.pred$posterior[1:10,]
lda.pred$class[1:10]

# We can use a posterior probability threshold other than 0.5
sum(lda.pred$posterior[,2]>0.5) 

lda.class = rep('Down',252)
lda.class[lda.pred$posterior[,2]>0.5] = 'Up'
table(lda.class,Smarket.2005$Direction)
mean(lda.class!=Smarket.2005$Direction) #mis-classification rate 

###########
### qda ###
###########

qda.fit = qda(Direction~Lag1+Lag2,data=Smarket, subset=train)
qda.pred = predict(qda.fit,Smarket.2005)

table(qda.pred$class,Smarket.2005$Direction)

mean(qda.pred$class==Smarket.2005$Direction)

# QDA predictions accurate almost 60% of the time.
