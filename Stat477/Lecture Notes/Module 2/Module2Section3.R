##Module 2 - Section 3
##Relative Risks and Odds Ratios

##Required Libraries
  library(ggplot2)
  library(ggmosaic)

##Required Functions
  rr.ci<- function(y, n, conf.level){
    y1<- y[1]
    y2<- y[2]
    n1<- n[1]
    n2<- n[2]
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    
    phat1<- y1/n1
    phat2<- y2/n2
    rr<- phat1/phat2
      
    selogrr<- sqrt((1-phat1)/(n1*phat1) + (1-phat2)/(n2*phat2))
      
    logrr.lower<- log(rr) - z*selogrr
    logrr.upper<- log(rr) + z*selogrr
      
    rr.lower<- exp(logrr.lower)
    rr.upper<- exp(logrr.upper)
      
    cat("Estimated Relative Risk = ", rr, "\n")
    cat("Confidence Interval for Population Relative Risk = ", rr.lower, rr.upper, "\n")
  }
    
  or.ci<- function(y, n, conf.level){
    y1<- y[1]
    y2<- y[2]
    n1<- n[1]
    n2<- n[2]
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
      
    phat1<- y1/n1
    phat2<- y2/n2
      
    or<- (phat1/(1-phat1))/(phat2/(1-phat2))
      
    selogor<- sqrt(1/(n1*phat1) + 1/(n1*(1-phat1)) + 1/(n2*phat2) + 1/(n2*(1-phat2)))
      
    logor.lower<- log(or) - z*selogor
    logor.upper<- log(or) + z*selogor
      
    or.lower<- exp(logor.lower)
    or.upper<- exp(logor.upper)
      
    cat("Estimated Odds Ratio = ", or, "\n")
    cat("Confidence Interval for Population Odds Ratio = ", or.lower, or.upper, "\n")
  }

##Read in the data from the cancersurgery.csv file
  surgery.data<- read.csv(file.choose(), header = T)

##Set the levels for the Surgery variable
  surgery.data$Surgery<- factor(surgery.data$Surgery, 
                                levels = c("Yes", "No"))
  
##Set the levels for the Died variable
  surgery.data$Died<- factor(surgery.data$Died, 
                             levels = c("Yes", "No"))

##Obtain the contingency table for the two variables
  surgery.table<- table(surgery.data$Surgery, surgery.data$Died)
  
##Obtain the size of each group for the Surgery variable
  groups<- margin.table(surgery.table, 1)

##Calculate the relative risk estimate and confidence
  rr.ci(surgery.table[,1], groups, conf.level = 0.95)

##Read in the data from the doctorsurvey.csv file
  survey.data<- read.csv(file.choose(), header = T)

##Set the levels for the Receive.Letter variable
  survey.data$Receive.Letter<- factor(survey.data$Receive.Letter, 
                                      levels = c("Yes", "No"))
  
##Set the levels for the Return.Survey variable
  survey.data$Return.Survey<- factor(survey.data$Return.Survey, 
                                     levels = c("Yes", "No"))

##Obtain the contingency table for the two variables
  survey.table<- table(survey.data$Receive.Letter, 
                       survey.data$Return.Survey)
  
##Obtain the size of each group for the Receive.Letter variable
  groups<- margin.table(survey.table, 1)

##Calculate the odds ratio estimate and confidence interval
  or.ci(survey.table[,1], groups, conf.level = 0.95)

