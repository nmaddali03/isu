##Module 1 - Section 4
##Hypothesis Tests for the Population Proportion

##Required Libraries
  library(ggplot2)
  library(plyr)

##Required Functions
  powerprop.test<- function(n, p0, pa, alternative, alpha){
    diff<- p0-pa
    adiff<- abs(diff)
    sep0<- sqrt(p0*(1-p0)/n)
    sepa<- sqrt(pa*(1-pa)/n)
    probone<- 1 - alpha
    probtwo<- 1 - alpha/2
  
    switch(alternative,
          two.sided = 
            2*(1 - pnorm((adiff + qnorm(probtwo)*sep0)/sepa)),
          greater = 1 - pnorm((diff + qnorm(probone)*sep0)/sepa),
          less = pnorm((diff - qnorm(probone)*sep0)/sepa))
  }

  npowerprop.test<- function(p0, pa, alternative, alpha, power){
  
    diff<- p0-pa
    sep0<- sqrt(p0*(1-p0))
    sepa<- sqrt(pa*(1-pa))
    probone<- 1 - alpha
    probtwo<- 1 - alpha/2
    powerone<- power
    powertwo<- power/2
  
    switch(alternative,
           two.sided = ceiling((qnorm(powertwo)*sepa 
                              + qnorm(probtwo)*sep0)^2/diff^2),
           greater = ceiling((qnorm(powerone)*sepa 
                            + qnorm(probone)*sep0)^2/diff^2),
           less = ceiling((qnorm(powerone)*sepa 
                         + qnorm(probone)*sep0)^2/diff^2))
  }

##Read in the data on ESP test from the file esp.csv
  espdata <- read.csv(file.choose(), header = T)
  
##Read in the data on the ingots from the file ingots.csv
  ingotsdata <- read.csv(file.choose(), header = T)

##Obtain the summary table for the ESP data 
  esp.counts<- count(espdata, var = 'Response')
  esp.table<- mutate(esp.counts, 
                   prop = freq/sum(esp.counts[2]))
  esp.table<- rbind(esp.table, data.frame(Response='Total', 
                                          t(colSums(esp.table[, -1]))))
  esp.table

##Obtain the bar graph for the ESP data
  ggplot(espdata, aes(x=Response))+ 
    geom_bar(fill = "blue", colour = "black")+
    labs(x = "Response",
         y = "Number of Attempts",
         title = "Summary of ESP Test")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Obtain the summary table for the ingots data
  ingots.counts<- count(ingotsdata, var = 'Status')
  ingots.table<- mutate(ingots.counts, 
                        prop = freq/sum(ingots.counts[2]))
  ingots.table<- rbind(ingots.table, data.frame(Status='Total', 
                                              t(colSums(ingots.table[, -1]))))
  ingots.table

##Obtain the bar graph for the ingots data  
  ggplot(ingotsdata, aes(x=Status))+ 
    geom_bar(fill = "blue", colour = "black")+
    labs(x = "Status",
         y = "Number of Ingots",
         title = "Summary of Ingots Status")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Obtain the binomial test for the ESP data
  binom.test(15, 20, 0.5, alternative = "greater")
  
##Obtain the binomial test for the dice data example
  binom.test(6, 60, 1/6, alternative = "two.sided")
  
##Obtain the score test for the ingots data
  prop.test(64, 400, p=0.2, alternative = "less", correct = F)
  
##Calculate the power of the binomial test for the ESP data
##for different values of p_a
  sum(dbinom(15:20, 20, 0.6))
  sum(dbinom(15:20, 20, 0.75))
  sum(dbinom(15:20, 20, 0.9))

##Plot the power curve for the binomial test for the ESP data
  pa<- c(50:100)/100
  powers<- rep(99, length(pa))
  for (i in 1:length(pa)) powers[i]<- sum(dbinom(15:20, 20, pa[i]))

  powerplot<- as.data.frame(cbind(pa, powers))

  ggplot(powerplot, aes(x = pa, y = powers))+
    geom_line()+
    labs(x = "True Population Proportion",
         y = "Probability of Rejecting the Null Hypothesis",
         title = "Power Curve for ESP Test")+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)), 
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Calculate the power of the score test for the ingots data for p_a = 0.14
  powerprop.test(400, 0.2, 0.14, alternative = "less", 0.05)

##Plot the power curve for the ingots data
  pa<- c(0:20)/100
  powers<- rep(99, length(pa))
  for (i in 1:length(pa)) 
    powers[i]<- powerprop.test(400, 0.2, pa[i], alternative = "less", 0.05)
                             
  powerplot2<- as.data.frame(cbind(pa, powers))
  ggplot(powerplot2, aes(x = pa, y = powers))+
    geom_line()+
    ylim(0,1)+
    labs(x = "True Population Proportion",
         y = "Probability of Rejecting the Null Hypothesis",
         title = "Power Curve for Ingots Test")+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Determine the necessary sample size needed to meet a particular power for 
##a specific p_a value for the ingots data
  npowerprop.test(0.2, 0.17, alternative = "less", 0.05, 0.95)
