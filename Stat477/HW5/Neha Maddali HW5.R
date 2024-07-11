library(ggplot2)
library(ggmosaic)
library(vcdExtra)

##Problem 1
data <- read.csv("poll.csv")

##part a - contingency table
contingency_table <- table(data$Register, data$Penalty)
contingency_table

##part b - mosaic plot or segmented bar graph
ggplot(data = data) +
  geom_mosaic(aes(x = product(Register, Penalty), fill = Register),
              na.rm = TRUE, divider = mosaic("h")) +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        strip.text.y = element_text(size = rel(1.4)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6))) +
  labs(x = "Death Penalty Opinions",
       y = "Gun Registration Opinions",
       fill = "Gun Registration Opinions",
       title = "Opinions on Gun Registration and Death Penalty")

##part c - test of independence
chi_square_test <- chisq.test(contingency_table)
print(chi_square_test)

chi_square_test$statistic
chi_square_test$p.value

##part d - estimated correlation
r.phi<- function(table){
  chisqstat<- chisq.test(table, correct = F)$statistic
  n<- sum(table)
  sgn<- sign(table[1,1]*table[2,2]-table[1,2]*table[2,1])
  sgn*sqrt(chisqstat/n)
}

r.phi(contingency_table)


##Problem 2
tireshift_data <- read.csv("tireshift.csv")

##part a - contingency table
contingency_table <- table(tireshift_data$Shift, tireshift_data$Condition)
contingency_table

##part b - mosaic plot or segmented bar graph
ggplot(data = tireshift_data) +
  geom_mosaic(aes(x = product(Condition, Shift), fill = Condition),
              na.rm = TRUE, divider = mosaic("h")) +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        strip.text.y = element_text(size = rel(1.4)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6))) +
  labs(x = "Shift",
       y = "Tire Condition",
       fill = "Tire Condition",
       title = "Mosaic Plot of Shift and Tire Condition")

##part e - test of independence
chi_square_test <- chisq.test(contingency_table)
print(chi_square_test)
chi_square_test$statistic
chi_square_test$p.value

##part f - estimated Cramer's V
phi.c<- function(table){
  chisqstat<- chisq.test(table, correct = F)$statistic
  min.dim<- min(dim(table))
  numobs<- sum(table)
  sqrt((chisqstat/numobs)/(min.dim - 1))
}

phi.c(contingency_table)


##Problem 3
ability_data <- read.csv("ability.csv")

##Part a - contingency table
ability_data$Child <- factor(ability_data$Child, levels = c("Below Average", "Average", "Above Average"))
ability_data$Mother <- factor(ability_data$Mother, levels = c("Below Average", "Average", "Above Average"))
ability_table <- table(ability_data$Child, ability_data$Mother)
print(ability_table)

##Part b - mosaic plot or segmented bar graph
ggplot(data = ability_data) +
  geom_mosaic(aes(x = product(Child, Mother), fill = Child),
              na.rm = TRUE, divider = mosaic("h")) +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        strip.text.y = element_text(size = rel(1.4)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6))) +
  labs(x = "Mother's Perception",
       y = "Child's Perception",
       fill = "Child's Perception",
       title = "Child and Mother Perceptions of Academic Ability")

##Part c - Test of independence
chi_square_test <- chisq.test(ability_table)
print(chi_square_test)
chi_square_test$statistic
chi_square_test$p.value

##Part d - Calculate Goodman-Krustal Gamma statistic
gamma_result <- GKgamma(ability_table)
print(gamma_result)
