##HW 2 Template
  ##Necessary Libraries
  library(plyr)
  library(ggplot2)
  
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
  

##Problem 1
  p <- 0.16  # Proportion of Green milk chocolate M&Ms
  n <- 100   # Sample size
  
  ##Part b
  1 - pnorm(0.20, p, sqrt(p * (1 - p) / n))

  ##Part c
  pnorm(0.10, p, sqrt(p * (1 - p) / n))
  

##Problem 2

  ##Part a
  dogs_data <- read.csv("Dogs.csv", header = TRUE)
  dogs_counts <- count(dogs_data, var = 'Paw')
  dogs_table <- mutate(dogs_counts, prop = freq / sum(dogs_counts$freq))
  dogs_table <- rbind(dogs_table, data.frame(Paw = 'Total', t(colSums(dogs_table[, -1]))))
  print(dogs_table)
  
  ggplot(dogs_data, aes(x = Paw)) + 
    geom_bar(fill = "blue", colour = "black") +
    labs(x = "Paw", y = "Number of Occurrences", title = "Summary of Dog's Paw Preference") + 
    theme_bw() +
    theme(
      axis.title.y = element_text(size = rel(1.4)),
      axis.title.x = element_text(size = rel(1.4)),
      axis.text.x = element_text(size = rel(1.2)),
      axis.text.y = element_text(size = rel(1.2)),
      plot.title = element_text(hjust = 0.5, size = rel(1.6))
    )
  
  ##Part b
  binom.test(10,15,0.5, alternative="greater")
  
  ##Part c
  sum(dbinom(11:15, 15, 0.5))  
  sum(dbinom(12:15, 15, 0.5))  
  
  ##Part d
  sum (dbinom(12:15, 15, 0.5))
  
  ##Part e
  sum(dbinom(12:15, 15, 0.6)) 
  sum(dbinom(12:15, 15, 0.75))
  sum(dbinom(12:15, 15, 0.9)) 


##Problem 3

  ##Part a
  antacid_data <- read.csv("Antacid.csv", header = TRUE)
  antacid_counts <- count(antacid_data, var = 'Relief')
  antacid_table <- mutate(antacid_counts, prop = freq / sum(antacid_counts$freq))
  antacid_table <- rbind(antacid_table, data.frame(Relief = 'Total', t(colSums(antacid_table[, -1]))))
  print("Summary Table:")
  print(antacid_table)
  
  ## Bar graph
  ggplot(antacid_data, aes(x = Relief)) + 
    geom_bar(fill = "blue", colour = "black") +
    labs(x = "Relief", y = "Number of Occurrences", title = "Summary of Antacid Relief") + 
    theme_bw() +
    theme(
      axis.title.y = element_text(size = rel(1.4)),
      axis.title.x = element_text(size = rel(1.4)),
      axis.text.x = element_text(size = rel(1.2)),
      axis.text.y = element_text(size = rel(1.2)),
      plot.title = element_text(hjust = 0.5, size = rel(1.6))
    )

  ##Part c
  prop.test(312, 400, p=0.75, alternative = "greater", correct = F)
  
  ##Part d
  powerprop.test(n=400, p0 = 0.75, pa=0.8, alternative='greater', alpha=0.1)
  powerprop.test(n=400, p0 = 0.75, pa=0.85, alternative='greater', alpha=0.1)
  powerprop.test(n=400, p0 = 0.75, pa=0.9, alternative='greater', alpha=0.1)
  
  powerprop.test(n=400, p0 = 0.75, pa=0.8, alternative='greater', alpha=0.05)
  powerprop.test(n=400, p0 = 0.75, pa=0.85, alternative='greater', alpha=0.05)
  powerprop.test(n=400, p0 = 0.75, pa=0.9, alternative='greater', alpha=0.05)
  
  powerprop.test(n=400, p0 = 0.75, pa=0.8, alternative='greater', alpha=0.01)
  powerprop.test(n=400, p0 = 0.75, pa=0.85, alternative='greater', alpha=0.01)
  powerprop.test(n=400, p0 = 0.75, pa=0.9, alternative='greater', alpha=0.01)
  
  ##Part e
  # explanation given in word document
  
  ##Part f
  npowerprop.test(p0=0.8, pa=0.85, alternative='greater', alpha=0.05, power=0.9)
