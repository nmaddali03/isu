##Required Libraries
library(ggplot2)
library(ggmosaic)
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

##Problem 1
data_bush <- read.csv("Bushapproval.csv")

##part a - contingency table
contingency_table <- table(data_bush$First, data_bush$Second)
contingency_table

##part b
944/1600
880/1600

##part d - McNemar's test
mcnemar.test(contingency_table, correct = F)

##part e - 95% confidence interval
mcnemar.ci(contingency_table, conf.level = 0.95)


##Problem 2
data_movies <- read.csv("AttheMovies.csv")

##part a - contingency table
contingency_table <- table(data_movies$Siskel, data_movies$Ebert)
contingency_table

##part b
  ##distribution of reviews for Siskel
siskel_distribution <- prop.table(rowSums(contingency_table))
siskel_distribution
  ##distribution of reviews for Ebert
ebert_distribution <- prop.table(colSums(contingency_table))
ebert_distribution

##part c - Extension of McNemar's Test
stuart.maxwell.mh(contingency_table)

##part d - Proportion of movies where reviews matched
matched_reviews_count <- sum(diag(contingency_table))  # Sum of counts where reviews matched
total_movies <- sum(contingency_table)  # Total number of movies
proportion_matched <- matched_reviews_count / total_movies
proportion_matched

##part e - Cohen's kappa
kappa2(data_movies)

##part f - weighted Cohen's kappa
kappa2(data_movies, weight = c("squared"))


##Problem 3
data_scores <- read.csv("Scores.csv")

##Part a - contingency table
contingency_table <- table(data_scores$Person, data_scores$Computer)
contingency_table

##part b - Proportion of scores that matched
matched_scores_count <- sum(diag(contingency_table))  # Sum of counts where scores matched
total_responses <- sum(contingency_table)  # Total number of responses
proportion_matched <- matched_scores_count / total_responses
proportion_matched

##part c - Cohen's kappa
kappa2(data_scores)

##part d - weighted Cohen's kappa
kappa2(data_scores, weight = c("squared"))

