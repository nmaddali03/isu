library(classdata)
library(ggplot2)
library(tidyverse)
data(ames)
?ames

#----------------Question 1
#Explore and explain what is the relationship between the sale price (y) and living area 
#size (x). In your visualization, add a straight line with intercept at 20000 and slope 
#equal to 100. Look at ?geom_abline, and in particular the examples. Remark on any patterns 
#you find and the straight line.
p <- ggplot(ames, aes(x=GrLivArea, y=SalePrice))+geom_point()
p + geom_abline(intercept=20000, slope=100)

#My analysis: As the living area size increases, the sale price increases. As seen from the
#scatter plot, there is a heavy concentration of data points where the living area is 1000 to
#2500l where the Sale Price is around 2e+5. The abline line shows that as living area
#size increases, so does the sale price.

#-----------------Question 2
#Describe at least two types of anomalies in the previous plot. What do they mean?
#My analysis: The really apparenent outliers of the previous graph are the two 
#points below the regression line, closer to a 5000 living area size with around a 
#2e+5 Sale Price. The majority of the data points indicate that as living area increases, so 
#does sale price. These two data points do not follow that trend. 

#-----------------Question 3
#Visualize the number of sales by the overall condition. Make sure the conditions are 
#ordered from the best to the worst. What do you find?
ggplot(ames, aes(x=OverallCond)) + geom_histogram(bins=10) 

#My analysis: With counting how many sales there are for each overall condition, it 
#looks like there are the most sales with an overall condition of 5. 

#-----------------Question 4
#Introduce a variable houseAge into the data set which stands for the age of the house 
#at the time when it was sold. How does the age of the house affect the sale price?
houseAge <- ames$YrSold - ames$YearBuilt
houseAge
p <- ggplot(ames, aes(x=houseAge, y=SalePrice))+geom_point()
p

#My analysis: With first finding the houseAge using the YrSold and YearBuilt values of the
#dataset, I then conducted a ggplot scatter plot. The results show that as the house age
#increases, the sale price of the house decreases. As the house age was below 20, the sale
#price of the house was really high. 

#-----------------Question 5
#Were there more sales of nice houses or poor houses? Make sure to state your criterion 
#for a house to be "nice" or otherwise "poor". Choose an appropriate graph type.
#ggplot(ames, aes(x=SalePrice)) + geom_histogram(bins=30) + facet_wrap(~OverallQual)

poor <- ames[ames$OverallQual, c(1,2,3,4)]
nice <- ames[ames$OVerallQual, c(5,6,7,8,9)]

building <- ames[ames$BldgType %in% c('1Fam','2fmCon','Duplex','Twnhs','TwnhsE')]
quality <- building[building$OVerallQual %in% c("nice","poor"), ]
ggplot(quality, aes(x=log10(ames$OverallQual), weight=Id, fill=ames$BldgType))+geom_bar()

#My analysis: My criterion for this problem is 1-4 is poor quality, 5-9 is nice quality.From creating histograms, it looks like there are the most 
#sales for houses with an overall quality of 5 which are nice quality. There are a few sales
#for poor quality houses. And there are a handful of sales for superb quality of 8-10 houses.

#-----------------Question 6
#How do the neighborhood and the slope of property affect the relationship between 
#sale price and year built? Focus on the neighborhoods of Brookside, Clear Creek, 
#College Creek, and Somerset only. Find a visualization that incorporates all four variables.
#Interpret the result.
dat <- ames[ames$Neighborhood == 'BrkSide',
            ames$Neighborhood == 'ClearCr',
            ames$Neighborhood == 'CollgCr',
            ames$Neighborhood == 'Somerst']
ggplot(ames, aes(x=YearBuilt, y=LandSlope, color=SalePrice)) + geom_point() + 
  facet_wrap(~Neighborhood)

#My analysis: It looks like in most neighborhoods, the most house sales occured around 1980
#and later. There were only a few houses that wer bought for a high sale price of 6e+05.
#For example, it looks like there was a sale price of around 6e+5 in the StoneBr Neighborhood.
#Additionally, most houses seem to have been bought from the Glt landslope. The neighborhood,
#slope of property and year it was built affect the sale price. Most houses that are worth
#more than the 2e+5 were in Glt and in newer neighborhoods like StoneBr, No Ridge, Somerst.
#Whereas if we look at the OldTown graph, the majority of houses were bought for 2e+5 and 
#were bought before 1980.

#-----------------Question 7
#Create a side-by-side histogram showing the sales price for the different types of 
#buildings. Comment on the result.
s <- ames[ames$BldgType %in% c('1Fam','2fmCon','Duplex','Twnhs','TwnhsE'), ]
ggplot(s,aes(x=log10(SalePrice),fill=BldgType))+ geom_histogram(position="dodge",bins=30)

#My analysis: With creating side-by-side histograms, it looks like 1Fam building type has 
#the most sales for sale prices mostly around 2e+5. 2fmCon building type seems to have
#the least sale count of the five types of buildings.


