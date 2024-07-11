##Module 2 - Section 4
##Test of Independence
  
##Required Libraries
  library(ggplot2)
  library(ggmosaic)

##Read in the data from the smoking.csv file
  smoking.data<- read.csv(file.choose(), header = T)

##Set the levels of the Student variable
  smoking.data$Student<- factor(smoking.data$Student, 
                                levels = c("Non-Smoker", "Smoker"))
  
##Set the levels of the Parent variable
  smoking.data$Parent<- factor(smoking.data$Parent, 
                               levels = c("Neither", "One", "Both"))

##Obtain the contingency table of the two variables  
  smoking.table<- table(smoking.data$Parent, smoking.data$Student)

##Graph a mosaic plot of the two variables
  ggplot(data = smoking.data)+
    geom_mosaic(aes(x = product(Student, Parent), fill = Student), 
                na.rm = TRUE, divider =  mosaic("h"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(2)),
          axis.title.y = element_text(size = rel(1.8)),
          axis.title.x = element_text(size = rel(1.8)),
          axis.text.x = element_text(size = rel(1.8)),
          axis.text.y = element_text(size = rel(1.8)),
          strip.text.y = element_text(size = rel(1.8)))+
    labs(x = "Parent Smoking Status",
         y = "Student Smoking Status",
         fill = "Student Smoking Status",
         title = "Mosaic Plot of Smoking Data")

##Run the chi-square test of independence  
  smoking.test<- chisq.test(smoking.table)

##View the output of the chi-square test of independence
  smoking.test

##View the expected cell counts
  smoking.test$expected

##View cell contributions to chi-square test statistic
  (smoking.test$residuals)^2
