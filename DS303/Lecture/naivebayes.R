library(ISLR2)
head(Smarket) # consists of percentage returns for the S&P 500 stock index over 1250 days from 2001 - 2005

# For each date, recorded the percentage returns for each of the previous trading days (Lag1 - Lag5)

# Volume (number of shares traded)
# Today (percentage return on the date in question)
# Direction (whether the market was up or down on this date)

train = (Smarket$Year<2005)
Smarket.2005 = Smarket[!train,]
dim(Smarket.2005)

library(e1071)
nb.fit = naiveBayes(Direction~ Lag1 + Lag2, data=Smarket, subset = train)

nb.fit

## default implementation assumes each quantitative predictors follows a normal distribution
#mean(Smarket$Lag1[train][Smarket$Direction[train]=='Down'])
#sd(Smarket$Lag1[train][Smarket$Direction[train]=='Down'])

nb.class = predict(nb.fit, Smarket.2005)
table(nb.class, Smarket.2005$Direction)
mean(nb.class == Smarket.2005$Direction)
 
# see the posterior probabilities
nb.prob = predict(nb.fit, Smarket.2005, type = 'raw')

################################################################
##### implement Naive Bayes with kernel density estimation ####

library(klaR)
# core code is based on package 1071 but extended for kernel estimating densities 
# users can also specify 'prior' information 

nb.fit2 = NaiveBayes(Direction ~ Lag1 + Lag2, data=Smarket, subset=train, usekernel = TRUE)

nb2.class = predict(nb.fit2, Smarket.2005)$class
nb2.prob = predict(nb.fit2, Smarket.2005)$posterior

table(nb2.class, Smarket.2005$Direction)
mean(nb2.class == Smarket.2005$Direction)
