##Module 2 - Section 5
##Measures of Association

##Required Libraries
  library(vcdExtra)

##Required Functions
  r.phi<- function(table){
    chisqstat<- chisq.test(table, correct = F)$statistic
    n<- sum(table)
    sgn<- sign(table[1,1]*table[2,2]-table[1,2]*table[2,1])
    sgn*sqrt(chisqstat/n)
  }

  phi.c<- function(table){
    chisqstat<- chisq.test(table, correct = F)$statistic
    min.dim<- min(dim(table))
    numobs<- sum(table)
    sqrt((chisqstat/numobs)/(min.dim - 1))
  }

##Read in the data from the smokingc.csv file
  smokingc.data<- read.csv(file.choose(), header = T)

##Set the levels for the Student smoking variable
  smokingc.data$Student<- factor(smokingc.data$Student,
                                 levels = c("Non-Smoker", "Smoker"))
  
##Set the levels for the Parent smoking variable
  smokingc.data$Parent<- factor(smokingc.data$Parent,
                                 levels = c("Neither", "One or Both"))

##Obtain the contingency table for the two variables
  smokingc.table<- table(smokingc.data$Parent,
                         smokingc.data$Student)

##Calculate the estimate of the phi correlation   
  r.phi(smokingc.table)

##Read in the data from the smoking.csv file  
  smoking.data<- read.csv(file.choose(), header = T)

##Set the levels for the Student smoking variable
  smoking.data$Student<- factor(smoking.data$Student,
                                levels = c("Non-Smoker", "Smoker"))

##Set the levels for the Parent smoking variable
  smoking.data$Parent<- factor(smoking.data$Parent,
                               levels = c("Neither", "One", "Both"))

##Obtain the contingency table for the two variables
  smoking.table<- table(smoking.data$Parent,
                        smoking.data$Student)
  
##Calculate the estimate of Cramer's V
  phi.c(smoking.table)

##Read in the data from the jobdata.csv file  
  jobs.data<- read.csv(file.choose(), header = T)

##Set the levels for the Physically variable
  jobs.data$Physically<- factor(jobs.data$Physically,
                                levels = c("Seldom", "Sometimes", "Usually"))

##Set the levels for the Psychologically variable
  jobs.data$Psychologically<- factor(jobs.data$Psychologically,
                                     levels = c("Seldom", "Sometimes", "Usually"))

##Obtain the contingency table for the two variables
  jobs.table<- table(jobs.data$Physically, 
                     jobs.data$Psychologically)

##Calculate the gamma statistic  
  GKgamma(jobs.table)
