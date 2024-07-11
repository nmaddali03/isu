##HW 3 Template
  ##Necessary Libraries
  library(plyr)
  library(ggplot2)
  
  ##Required Functions
  prop.ci<- function(y, n, type, conf.level){
    phat<- y/n
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    newy<- y + z^2/2
    newn<- n + z^2
    newphat<- newy/newn
    
    
    if (type=="normal") {
      lowerci<- phat - z*sqrt(phat*(1-phat)/n)
      upperci<- phat + z*sqrt(phat*(1-phat)/n)
    }
    
    else if (type=="score") {
      lowerci<- (phat + (1/(2*n))*z^2 - z*sqrt(phat*(1-phat)/n + z^2/(4*n^2)))/(1 + (1/n)*z^2)
      upperci<- (phat + (1/(2*n))*z^2 + z*sqrt(phat*(1-phat)/n + z^2/(4*n^2)))/(1 + (1/n)*z^2)
    }
    
    else {
      lowerci<- newphat - z*sqrt(newphat*(1-newphat)/newn)
      upperci<- newphat + z*sqrt(newphat*(1-newphat)/newn)
    }
    cat(lowerci, upperci, "\n")
  }
  
  nprop.ci<- function(p, m, conf.level) {
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    ceiling((z/m)^2*p*(1-p))
  }
  
##Problem 1
  
  ##Part a
  data <- read.csv("floor13.csv")
  summary_table <- table(data$Bothered)
  print(summary_table)
  
  bar_graph <- ggplot(data, aes(x = factor(Bothered))) +
    geom_bar(stat = "count", width = 0.7, fill = "skyblue") +
    labs(title = "Bothered by Thirteenth Floor",
         x = "Bothered",
         y = "Count") +
    theme_minimal()
  print(bar_graph)
  
  ##Part b
  prop.ci(sum(data$Bothered == "Yes"), length(data$Bothered), "normal", 0.95)

  ##Part d
  prop.ci(sum(data$Bothered == "Yes"), length(data$Bothered), "score", 0.95)
  
  ##Part e
  margin_of_error <- 0.02
  confidence_level <- 0.90
  required_sample_size <- nprop.ci(0.5, margin_of_error, confidence_level)
  required_sample_size
  

##Problem 2

  ##Part c
  sample_size <- 1019
  sample_proportion <- 662 / sample_size
  confidence_level <- 0.95
  wilson_interval <- prop.ci(662, 1019, "score", 0.95)
  
  ##Part e
  desired_margin_of_error <- 0.025  # 2.5%
  confidence_level <- 0.95
  required_sample_size <- nprop.ci(0.5, desired_margin_of_error, confidence_level)
  required_sample_size
  
  
  ##Problem 4
  
  ##Part a
  data <- read.csv("zodiac.csv")
  summary_table <- table(data$Sign)
  print(summary_table)
  
  bar_graph <- ggplot(data, aes(x = factor(Sign))) +
    geom_bar(stat = "count", width = 0.7, fill = "skyblue") +
    labs(title = "Distribution of Zodiac Signs in Company Heads",
         x = "Zodiac Sign",
         y = "Count") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  print(bar_graph)
  
  
  ##Part c
  total_observations <- nrow(data)
  num_zodiac_signs <- 12
  expected_births <- total_observations / num_zodiac_signs
  expected_births
  
  ##Part d
  observed_scorpio <- table(data$Sign)["Scorpio"]
  expected_scorpio <- total_observations / num_zodiac_signs
  contribution_scorpio <- ((observed_scorpio - expected_scorpio)^2) / expected_scorpio
  contribution_scorpio
  
  ##Part e
  chi_square_statistic <- sum((table(data$Sign) - expected_births)^2 / expected_births)
  chi_square_statistic
  
  ##Part f
  degrees_of_freedom <- (num_zodiac_signs - 1)
  degrees_of_freedom
  
  ##Part g
  p_value <- 1 - pchisq(chi_square_statistic, degrees_of_freedom)
  p_value
  