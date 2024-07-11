##Module 2 - Section 7
##Measures of Agreement

##Required Libraries
  library(irr)

##Read in the data from the StudentTeacher.csv file
  teacher<- read.csv(file.choose(), header = T)

##Set the order of the levels for the two variables
  teacher$Judge.1<- factor(teacher$Judge.1, 
                           levels = c("Authoritarian", "Democratic", "Permissive"))
  teacher$Judge.2<- factor(teacher$Judge.2, 
                           levels = c("Authoritarian", "Democratic", "Permissive"))

##Calculate estimate of Cohen's kappa
  kappa2(teacher)

##Calculate estimate of weighted Cohen's kappa
  kappa2(teacher, weight = c("squared"))

