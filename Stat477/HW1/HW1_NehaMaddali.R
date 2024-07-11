##HW 1 Template
  ##Necessary Libraries
  library(plyr)
  library(ggplot2)

##Problem 1
  ##Read in the data set
  surveydata<- read.csv(file.choose(), header = T)
  
  ##Variable 1 - Hair Color
  # surveydata$HairColor
  surveydata$HairColor <- factor(surveydata$HairColor,
                                 levels = c("Brown", "Blond", "Red", 
                                            "Black", "Other"))
  haircolor.counts<- count(surveydata, var = 'HairColor')
  haircolor.table<- mutate(haircolor.counts, 
                          prop = freq/sum(haircolor.counts[2]))
  haircolor.table<- rbind(haircolor.table, data.frame(HairColor='Total', 
                                                    t(colSums(haircolor.table[, -1]))))
  haircolor.table
  
  ggplot(surveydata, aes(x=HairColor))+ 
    geom_bar(fill = "blue", colour = "black")+
    ylim(0, 800)+
    labs(x = "Hair Color",
         y = "Number of Students",
         title = "Hair Colors of STAT 101 Students")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))
  
  
  ##Variable 2 - Hair Length
  #surveydata$HairLength
  surveydata$HairLength <- factor(surveydata$HairLength,
                                 levels = c("Short", "Medium", "Long"))
  hairlength.counts<- count(surveydata, var = 'HairLength')
  hairlength.table<- mutate(hairlength.counts, 
                           prop = freq/sum(hairlength.counts[2]))
  hairlength.table<- rbind(hairlength.table, data.frame(HairLength='Total', 
                                                      t(colSums(hairlength.table[, -1]))))
  hairlength.table
  
  ggplot(surveydata, aes(x=HairLength))+ 
    geom_bar(fill = "blue", colour = "black")+
    ylim(0, 800)+
    labs(x = "Hair Length",
         y = "Number of Students",
         title = "Hair Lengths of STAT 101 Students")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

  ##Variable 3 - Eye Color
  # surveydata$EyeColor
  surveydata$EyeColor <- factor(surveydata$EyeColor,
                                  levels = c("Hazel/Green", "Brown", "Blue", "Other"))
  eyecolor.counts<- count(surveydata, var = 'EyeColor')
  eyecolor.table<- mutate(eyecolor.counts, 
                            prop = freq/sum(eyecolor.counts[2]))
  eyecolor.table<- rbind(eyecolor.table, data.frame(EyeColor='Total', 
                                                        t(colSums(eyecolor.table[, -1]))))
  eyecolor.table
  
  ggplot(surveydata, aes(x=EyeColor))+ 
    geom_bar(fill = "blue", colour = "black")+
    ylim(0, 800)+
    labs(x = "Eye Color",
         y = "Number of Students",
         title = "Eye Color of STAT 101 Students")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))
    

##Problem 2

  ##Part b
  # Parameters for the binomial distribution
  n <- 40
  p <- 0.05
  
  # Calculate the probability that at least 1 person has the genetic mutation
  prob_at_least_1 <- 1 - dbinom(0, n, p)
  print(prob_at_least_1)
  
  ##Part c
  # Calculate the probability that no more than 3 people have the genetic mutation
  prob_no_more_than_3 <- pbinom(3, n, p)
  print(prob_no_more_than_3)
  
  ##Part f
  # Function to plot the binomial distribution
  plot.binom <- function(n, p) {
    y <- c(0:n)
    proby <- dbinom(0:n, n, p)
    Bars <- as.data.frame(cbind(y, proby))
    
    ggplot(Bars, aes(x = y, y = proby)) + 
      geom_bar(stat="identity", width = 1, 
               fill = "blue", colour = "black") +
      theme_bw() +
      theme(axis.title.y = element_text(size = rel(1.4)),
            axis.title.x = element_text(size = rel(1.4)),
            axis.text.x = element_text(size = rel(1.2)),
            axis.text.y = element_text(size = rel(1.2)),
            plot.title = element_text(hjust=0.5, size = rel(1.6))) +
      labs(x = "y",
           y = "Probability",
           title = "Distribution of Binomial R.V.")
  }
  plot.binom(n, p)
  

##Problem 3

  ##Part b
  # Parameters for the binomial distribution
  n <- 40
  p <- 0.30
  
  # Calculate the probability that at least 13 dogs have anemia
  prob_at_least_13 <- 1 - pbinom(12, n, p)
  print(prob_at_least_13)
  
  ##Part c
  # Calculate the probability that no more than 8 dogs have anemia
  prob_no_more_than_8 <- pbinom(8, n, p)
  print(prob_no_more_than_8)

  ##Part f
  plot.binom <- function(n, p) {
    y <- c(0:n)
    proby <- dbinom(0:n, n, p)
    Bars <- as.data.frame(cbind(y, proby))
    
    ggplot(Bars, aes(x = y, y = proby)) + 
      geom_bar(stat="identity", width = 1, 
               fill = "blue", colour = "black") +
      theme_bw() +
      theme(axis.title.y = element_text(size = rel(1.4)),
            axis.title.x = element_text(size = rel(1.4)),
            axis.text.x = element_text(size = rel(1.2)),
            axis.text.y = element_text(size = rel(1.2)),
            plot.title = element_text(hjust=0.5, size = rel(1.6))) +
      labs(x = "y",
           y = "Probability",
           title = "Distribution of Binomial R.V.")
  }
  plot.binom(n, p)
  

##Problem 4

  ##Part a
  prob<- c(0.4, 0.35, 0.25)
  y<- c(7,2,3)
  dmultinom(y, 12, prob)
