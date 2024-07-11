##Module 1 - Section 2
##Distributions for Counts: Bernoulli, Binomial, and Multinomial Distributions

##Required Libraries
  library(ggplot2)

##Required Functions
  plot.binom<- function(n, p){
    y<- c(0:n)
    proby<- dbinom(0:n, n, p)
    Bars<- as.data.frame(cbind(y, proby))
  
    ggplot(Bars, aes(x = y, y = proby))+ 
      geom_bar(stat="identity", width = 1, 
                fill = "blue", colour = "black")+
      theme_bw()+
      theme(axis.title.y = element_text(size = rel(1.4)),
            axis.title.x = element_text(size = rel(1.4)),
            axis.text.x = element_text(size = rel(1.2)),
            axis.text.y = element_text(size = rel(1.2)),
            plot.title = element_text(hjust=0.5, size = rel(1.6)))+
      labs(x = "y",
           y = "Probability",
           title = "Distribution of Binomial R.V.")
    }

##Calculate probability Y = 3 for Binomial R.V. with n = 5 and p = 0.6
  dbinom(3, 5, 0.6)

##Calculate probability Y >= 2 for Binomial R.V. with n = 5 and p = 0.6
  sum(dbinom(2:5, 5, 0.6))

##Calculate probability Y <= 3 for Binomial R.V. with n = 5 and p = 0.6
  sum(dbinom(0:3, 5, 0.6))

##Plot Binomial Distribution for n = 5 and p = 0.6
  plot.binom(5, 0.6)

##Calculate probability Y_1 = 2, Y_2 = 2, Y_3 = 1, Y_4 = 1, Y_5 = 1, Y_6 = 1
##for Multinomial R.V. with n = 8 and p_1 = 0.24, p_2 = 0.2, p_3 = 0.14, 
##p_4 = 0.13, p_5 = 0.16, p_6 = 0.13
  
  prob<- c(0.24, 0.2, 0.14, 0.13, 0.16, 0.13)
  y<- c(2,2,1,1,1,1)
  dmultinom(y, 8, prob)
