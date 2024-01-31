#An Olympic diving athelete's scores given by 6 referees were 
#9.3, 8.7, 9.5, 10, 9, and 8.9. The final score for that dive is the 
#average of the scores after crossing out the highest and lowest scores. 
#Find the final score for that dive. Store the answer in a variable named 
#ave and print.

scores <- c(9.3,8.7,9.5,10,9,8.9)
maxScore <- max(scores)
scores <- scores[scores != maxScore]
scores
minScore <- min(scores)
scores <- scores[scores != minScore]
ave <- mean(scores)
ave

#Create a vector of numbers (with length 21) to show whether the years of 
#2000, 2001, ., 2020 has Olympic Games. An entry of the vector should be 1 
#if the corresponding year has Olympic Games, and 0 otherwise. Note that 
#Olympic Games take place every two years (there are both summer and winter 
#Olympic Games), and that 2020 does not have Olympic Games. Store the answer 
#in a variable named olympic and print.

olympic <- c(rep(c(1,0,0),7))
olympic

#Calculate the BMI of Chris and Mary, who are siblings. Chris is 1.8 
#meters tall and 70 kilograms in weight; Mary is 1.65 meters tall and 49 
#kilograms in weight. The formula for BMI is BMI = weight (in kg) / height^2 
#(in meter). Store the answers in a vector of length 2 named bmi and print.

height <- c(1.8, 1.65)
weight <- c(70,49)
bmi <- weight / height^2
bmi

#Cars and mileage
library(ggplot2)
mpg
str(mpg)

#What are the 5 least fuel-efficient models in terms of highway mileage? 
#Storage the data frame containing all information of these five models in a 
#variable named worst5 and print. (Hint: Here are a few things you are free 
#to define. E.g., which variable to use to characterize "fuel economy", and 
#what is a "model". Please state your definitions.)

#we are looking at fuel efficiency through the hwy data
hwy <- mpg$hwy
sort(hwy)
sort(hwy, decreasing = FALSE)[1:5]
worst5 <- mpg[order(mpg$hwy, decreasing=FALSE),][1:5]
names(worst5)
str(worst5)

#How many different midsize models are included in this dataset? Storage 
#the answer in a variable named nummidsize and print.

models <- mpg$model[mpg$class == "midsize"]
nummidsize <- length(unique(models))
nummidsize

#Create a scatterplot of hwy and cty and describe the relationship. Why 
#are there so few points visible? Explain your findings.

#answer: there are very few points visible because they are overlapping. To
#better illustrate what is happening it might be easier to see the density
#functions for highway and city MPG
plot(mpg$cty, mpg$hwy, main = "City vs Highway MPG", xlab = "City MPG", 
     ylab = "Highway MPG")


#Which manufacturer produces cars with higher fuel efficiency, Dodge or 
#Toyota? Use graphs and summary statistics to answer this question. Explain 
#your findings.

#larger mpg = more fuel efficient

dodge <- mpg[mpg$manufacturer == 'dodge', ]
toyota <- mpg[mpg$manufacturer == 'toyota', ]
boxplot(dodge$hwy, toyota$hwy)

plot(density(mpg$hwy[mpg$manufacturer == "dodge"]), col = "red", main="Highway MPG")
lines(density(mpg$hwy[mpg$manufacturer == "toyota"]), col="blue")
legend("right", legend=c("Dodge","Toyota"),col=c("red","blue"), lty=c(1,1))

plot(density(mpg$cty[mpg$manufacturer == "dodge"]), col = "red", main="City MPG")
lines(density(mpg$cty[mpg$manufacturer == "toyota"]), col = "blue")
legend("right", legend=c("Dodge", "Toyota"), col=c("red", "blue"), lty=c(1,1))

city_data_Dodge = mpg$cty[mpg$manufacturer == "dodge"]
summary(city_data_Dodge)
city_data_Toyota = mpg$cty[mpg$manufacturer == "toyota"]
summary(city_data_Toyota)

hwy_data_Dodge = mpg$hwy[mpg$manufacturer == "dodge"]
summary(hwy_data_Dodge)
hwy_data_Toyota = mpg$hwy[mpg$manufacturer == "toyota"]
summary(hwy_data_Toyota)

#answer: Toyota produces cars with higher fuel efficiency rather than Dodge. 
#The city data shows that Toyota has a higher median and mean. Both being higher
#indicates the higher efficiency in Toyota produced cars. The same applies 
#when looking at the analysis from the highway data.


