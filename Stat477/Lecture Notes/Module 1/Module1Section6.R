##Module 1 - Section 6
##Goodness of Fit Test for a Single Categorical Variable

##Required Libraries
  library(plyr)
  library(ggplot2)

##Read in the data from the mmscolor.csv file
  mmdata<- read.csv(file.choose(), header = T)
  
##Set the category order for the variable Color
  mmdata$Color<- factor(mmdata$Color, 
                        levels = c("Blue", "Orange", "Yellow", 
                                   "Red", "Green", "Brown"))

##Obtain Summary Table for variable Color
  mm.counts<- count(mmdata, var = 'Color')
  mm.table<- mutate(mm.counts, 
                    prop = freq/sum(mm.counts[2]))
  mm.table<- rbind(mm.table, data.frame(Color='Total', 
                                      t(colSums(mm.table[, -1]))))
  mm.table

##Make Bar Graph for variable Color
  ggplot(mmdata, aes(x=Color))+ 
    geom_bar(fill = "blue", colour = "black")+
    labs(x = "Color", 
         y = "Number of M&Ms",
         title = "Bar Graph of M&M Colors")+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Set up variable modelp with the probabilities from the null hypothesis
  modelp<- c(0.24, 0.20, 0.14, 0.13, 0.16, 0.13)
  
##Run the Goodness of Fit Test using the counts from the Color variable 
##mm.counts[2]
  mm.goodtest<- chisq.test(mm.counts[2], p = modelp)
  
##View information about Goodness of Fit Test 
  mm.goodtest
  
##View expected values for each category if the null hypothesis is true
  mm.goodtest$expected

##View contribution to the test statistic from each category
  (mm.goodtest$residuals)^2
