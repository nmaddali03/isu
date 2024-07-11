##Module 1 - Section 3
##Sampling Distribution for the Sample Proportion

##Required Libraries
  library(ggplot2)
  
##Code to create the exact sampling distribution for p-hat
##based on the Binomial distribution - change the values of n and p
##to get a different distribution
  n<- 250
  p<- 0.1

  pphat<- c(0:n)/n
  probpphat<- dbinom(0:n, n, p)
  sdpphat<- as.data.frame(cbind(pphat, probpphat))

  ggplot(sdpphat, aes(x = pphat, y = probpphat))+ 
    geom_bar(stat="identity", fill = "blue", colour = "black")+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.6)),
          axis.text.y = element_text(size = rel(1.6)),
          plot.title = element_text(hjust=0.5, size = rel(2)))+
    labs(x = "Sample Proportion",
         y = "Probability",
         title = "Distribution of Sample Proportion")

##Code to simulate sampling distribution for p-hat - change the values 
##of n and p to get a different distribution
  n<- 1000
  p<- 0.95

  y<- rbinom(100000, n, p)
  phat<- y/n
  sdphat<-as.data.frame(cbind(y, phat))

  ggplot(sdphat, aes(x=phat))+
    geom_histogram(binwidth=0.01, fill = "blue", colour = "black")+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.6)),
          axis.text.y = element_text(size = rel(1.6)),
          plot.title = element_text(hjust=0.5, size = rel(2)))+
    labs(x = "Sample Proportion (p-hat)",
         y = "Number of Samples",
         title = "Approx. Sampling Distribution of p-hat")

##Investigate summarizes of sample proportions p-hat
  mean(phat) #mean
  var(phat) #variance
  sd(phat) #standard deviation
  summary(phat) #five number summary (and mean)
  
##Probability Calculations for p-hat using Normal sampling distribution
  
  ##Probability of p-hat less than 0.08 when p = 0.1 and n = 250
  pnorm(0.08, 0.1, sqrt(0.1*0.9/250))
  
  ##Probability of p-hat more than 0.13 when p = 0.1 and n = 250
  1 - pnorm(0.13, 0.1, sqrt(0.1*0.9/250))
