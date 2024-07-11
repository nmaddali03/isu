##Module 2 - Section 6
##Matched Pair Designs

##Required Libraries
  library(irr)

##Required Functions
  mcnemar.ci<- function(table, conf.level = 0.95){
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
  
    n<- sum(table)
    y1.<- margin.table(table, 1)[1]
    y.1<- margin.table(table, 2)[1]
    diff12<- table[1,2]-table[2,1]
    add12<- table[1,2]+table[2,1]
    se<- sqrt(add12 - diff12^2/n)/n
    lowerci<- y1./n - y.1/n - z*se
    upperci<- y1./n - y.1/n + z*se
    cat("Confidence Interval = ", lowerci, upperci, "\n")
  }

##Read in the data from the histogramq.csv file
  hist.data<- read.csv(file.choose(), header = T)

##Obtain the contingency table for the two questions
  hist.table<- table(hist.data$Question1, hist.data$Question2)

##Determine test statistic and p-value for McNemar's test
  mcnemar.test(hist.table, correct = F)

##Determine confidence interval for difference in two marginal proportions
  mcnemar.ci(hist.table, conf.level = 0.95)

##Read in the data from the babyhat.csv file
  baby.data<- read.csv(file.choose(), header = T)
  
##Obtain the contingency table for the two questions
  baby.table<- table(baby.data$Question1, baby.data$Question2)

##Determine test statistic and p-value for extension of McNemar's test
  stuart.maxwell.mh(baby.table)
