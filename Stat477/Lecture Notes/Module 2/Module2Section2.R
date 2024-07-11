##Module 2 - Section 2
##Comparing Two or More Population Proportions

##Required Libraries
  library(ggplot2)
  library(ggmosaic)

##Required Functions
  n2prop.test<- function(p1, p2, alternative, alpha, power) {
      
    ztwo<- qnorm(1 - alpha/2)
    zone<- qnorm(1 - alpha)
    zpower<- qnorm(power)
      
    p0<- (p1 + p2)/2
    R<- sqrt((2*p0*(1-p0))/((p1*(1-p1) + p2*(1-p2))))
      
    switch(alternative, two.sided = ceiling((zpower + R*ztwo)^2  *(p1*(1-p1)+p2*(1-p2))/(p1-p2)^2), greater = ceiling((zpower + R*zone)^2*(p1*(1-p1)+p2*(1-p2))/(p1-p2)^2), less = ceiling((zpower + R*zone)^2*(p1*(1-p1)+p2*(1-p2))/(p1-p2)^2))
  }
    
    
  n2prop.ci<- function(p1, p2, m, conf.level) {
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    ceiling((z/m)^2*(p1*(1-p1)+p2*(1-p2)))
  }

##Read in the data from the doctorsurvey.csv file
  survey.data<- read.csv(file.choose(), header = T)

##Set the order of the group variable as Yes, No
  survey.data$Receive.Letter<- factor(survey.data$Receive.Letter, 
                                      levels = c("Yes", "No"))
  
##Set the category of interest for the Return.Survey variable as Yes
  survey.data$Return.Survey<- factor(survey.data$Return.Survey, 
                                      levels = c("Yes", "No"))
  
##Obtain and view the contingency table of the two variables
  survey.table<- table(survey.data$Receive.Letter, 
                       survey.data$Return.Survey)
  survey.table

##Plot the mosaic plot of the conditional distribution of the Response 
##variable = Return.Survey given the grouping variable Receive.Letter
  ggplot(data = survey.data)+
    geom_mosaic(aes(x = product(Return.Survey, Receive.Letter), 
                    fill = Return.Survey), 
                na.rm = TRUE, divider =  mosaic("h"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.6)),
          axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          strip.text.y = element_text(size = rel(1.2)))+
    labs(x = "Did they Receive the Letter?", 
         y = "Did they Return the Survey?", 
         fill = "Did they Return the Survey?", 
         title = "Mosaic Plot of Doctor Survey Data")

##Determine the size of the Receive Letter groups. This is the marginal 
##distribution of this variable.
  letter<- margin.table(survey.table, 1)

##Obtain the hypothesis test statistic and p-value for the test from the notes
  prop.test(survey.table[,1], letter, alternative = "two.sided", correct = F)

##Read in the data from the cancersurgery.csv file
  surgery.data<- read.csv(file.choose(), header = T)

##Set the category of interest of the Response Variable = Died as Yes
  surgery.data$Died<- factor(surgery.data$Died, 
                             levels = c("Yes", "No"))

##Set the order of the surgery groups as Yes, No
  surgery.data$Surgery<- factor(surgery.data$Surgery, 
                                levels = c("Yes", "No"))

##Obtain and view the contingency table for the two variables
  surgery.table<- table(surgery.data$Surgery, 
                        surgery.data$Died)
  surgery.table

##Plot the mosaic plot of the conditional distribution of the Response 
##variable = Died given the grouping variable Surgery
  ggplot(data = surgery.data)+
    geom_mosaic(aes(x = product(Died, Surgery), fill = Died), 
                na.rm = TRUE, divider =  mosaic("h"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.6)),
          axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          strip.text.y = element_text(size = rel(1.2)))+
    labs(x = "Surgery for Prostate Cancer",
         y = "Died from Prostate Cancer",
         fill = "Died from Prostate Cancer",
         title = "Mosaic Plot of Cancer Surgery Data")

##Determine the sizes for the two Surgery groups. This is the marginal distribution
##of the Surgery variable
  groups<- margin.table(surgery.table, 1)

##Calculate the confidence interval for the difference of the two population 
##proportions
  prop.test(surgery.table[,1], groups, alternative = "two.sided",
            conf.level = 0.95, correct = F)

##Determine the sample size necessary to detect a difference of 0.05 with power 0.9
##for the doctor survey study 
  n2prop.test(p1 = 0.55, p2 = 0.5, alternative = "two.sided",
              alpha = 0.05, power = 0.9)
  
##Determine the sample size necessary to obtain a margin of error of around 0.03 for 
##a 95% confidence interval. Since the two sample proportions in previous study
##were small, we are estimating their values for this calculation instead of using
##0.5 for both.
  n2prop.ci(p1 = 0.05, p2 = 0.09, m = 0.03, conf.level = 0.95)

##Read in the data from the diodedata.csv file
  diode.data<- read.csv(file.choose(), header = T)

##Set the category of interest for the Response Variable = Status as Non-Conforming
  diode.data$Status<- factor(diode.data$Status, 
                             levels = c("Non-Conforming", "Conforming"))

##Set up the grouping variable Lot as a categorical variable (the values are numbers)
  diode.data$Lot<- as.factor(diode.data$Lot)

##Obtain and view the contingency table for the two variables
  diode.table<- table(diode.data$Lot, diode.data$Status)
  diode.table

##Plot the mosaic plot of the conditional distribution of the Response 
##variable = Status given the grouping variable Lot
  ggplot(data = diode.data)+
    geom_mosaic(aes(x = product(Status, Lot), fill = Status), 
                na.rm = TRUE, divider =  mosaic("h"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.6)),
          axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          strip.text.y = element_text(size = rel(1.4)))+
    labs(x = "Lot Number",
         y = "Status",
         fill = "Status",
         title = "Mosaic Plot of Diode Data")

##Determine the size of each lot. This is the marginal distribution of 
##the Lot variable
  lotsize<- margin.table(diode.table, 1)

##Obtain the test statistic and p-value for the test of equality for the five
##proportions of non-conforming diodes from each lot.
  prop.test(diode.table[,1], lotsize)

##Determine which lots have different proportions of non-conforming diodes
  pairwise.prop.test(diode.table[,1], lotsize, p.adjust.method = "BH")

##Read in the data from the smokingsex.csv file
  smokes.data<- read.csv(file.choose(), header = T)
  
##Order the categories for the Response Variable = Smoke variable
  smokes.data$Smoke<- factor(smokes.data$Smoke, 
                           levels = c("Nonsmoker", "Pastsmoker", "Currentsmoker"))

##Obtain and view the contingency table between the two variables
  smokes.table<- table(smokes.data$Sex, smokes.data$Smoke)
  smokes.table

##Plot the mosaic plot of the conditional distribution of the Response 
##variable = Smoke given the grouping variable Sex  
  ggplot(data = smokes.data)+
    geom_mosaic(aes(x = product(Smoke, Sex), fill = Smoke), 
                na.rm = TRUE, divider =  mosaic("h"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(2)),
          axis.title.y = element_text(size = rel(1.8)),
          axis.title.x = element_text(size = rel(1.8)),
          axis.text.x = element_text(size = rel(1.8)),
          axis.text.y = element_text(size = rel(1.8)),
          strip.text.y = element_text(size = rel(1.8)))+
    labs(x = "Sex",
         y = "Smoking Status",
         fill = "Sex",
         title = "Mosaic Plot of Smoking Survey Data")

##Obtain the test statistic and p-value for testing whether the 
##conditional distributions of the Response Variable = Smoke is the same 
##for each Sex
  smokes.test<- chisq.test(smokes.table)
  smokes.test
  
##View expected values for contingency table
  smokes.test$expected
##View contribution to test statistic from each cell
  (smokes.test$residual)^2

