heart = read.csv("/Users/neham/Desktop/DS301/heart_2020_cleaned.csv",header=TRUE)
library(leaps)
head(heart)
dim(heart)

na.omit(heart)


model1=lm(HeartDisease~PhysicalHealth+MentalHealth, data=heart)


#What set of criteria will almost certainly guarantee you to have heart disease?
#

library(ISLR)
str()