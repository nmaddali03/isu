##HW 4 Template

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

##Required Functions
rr.ci<- function(y, n, conf.level){
  y1<- y[1]
  y2<- y[2]
  n1<- n[1]
  n2<- n[2]
  alpha<- 1 - conf.level
  z<- qnorm(1 - alpha/2)
  
  phat1<- y1/n1
  phat2<- y2/n2
  rr<- phat1/phat2
  
  selogrr<- sqrt((1-phat1)/(n1*phat1) + (1-phat2)/(n2*phat2))
  
  logrr.lower<- log(rr) - z*selogrr
  logrr.upper<- log(rr) + z*selogrr
  
  rr.lower<- exp(logrr.lower)
  rr.upper<- exp(logrr.upper)
  
  cat("Estimated Relative Risk = ", rr, "\n")
  cat("Confidence Interval for Population Relative Risk = ", rr.lower, rr.upper, "\n")
}

or.ci<- function(y, n, conf.level){
  y1<- y[1]
  y2<- y[2]
  n1<- n[1]
  n2<- n[2]
  alpha<- 1 - conf.level
  z<- qnorm(1 - alpha/2)
  
  phat1<- y1/n1
  phat2<- y2/n2
  
  or<- (phat1/(1-phat1))/(phat2/(1-phat2))
  
  selogor<- sqrt(1/(n1*phat1) + 1/(n1*(1-phat1)) + 1/(n2*phat2) + 1/(n2*(1-phat2)))
  
  logor.lower<- log(or) - z*selogor
  logor.upper<- log(or) + z*selogor
  
  or.lower<- exp(logor.lower)
  or.upper<- exp(logor.upper)
  
  cat("Estimated Odds Ratio = ", or, "\n")
  cat("Confidence Interval for Population Odds Ratio = ", or.lower, or.upper, "\n")
}


##Problem 1
data <- read.csv("WHI.csv")

  ##Part a
contingency_table <- table(data$Group, data$Cancer)
print(contingency_table)

proportion_cancer_hormone <- contingency_table["Hormone", "Yes"] / sum(contingency_table["Hormone", ])
proportion_cancer_hormone
proportion_cancer_placebo <- contingency_table["Placebo", "Yes"] / sum(contingency_table["Placebo", ])
proportion_cancer_placebo
  
  ##Part b
prop_test <- prop.test(c(contingency_table["Hormone", "Yes"], contingency_table["Placebo", "Yes"]), 
                       c(sum(contingency_table["Hormone", ]), sum(contingency_table["Placebo", ])))
prop_test$statistic
prop_test$p.value

  ##Part c
prop.test(c(contingency_table["Hormone", "Yes"], contingency_table["Placebo", "Yes"]), 
                           c(sum(contingency_table["Hormone", ]), sum(contingency_table["Placebo", ])),
                           conf.level = 0.90)

  ##Part d
y <- c(contingency_table["Hormone", "Yes"], contingency_table["Placebo", "Yes"])
n <- c(sum(contingency_table["Hormone", ]), sum(contingency_table["Placebo", ]))
conf_level <- 0.90
rr.ci(y, n, conf_level)

  ##Part e
or.ci(y, n, conf_level)


##Problem 2
titanic_data <- read.csv("titanic.csv")

  ##Part a
ggplot(data = titanic_data) +
  geom_mosaic(aes(x = product(Status, Ticket), fill = Status),
              na.rm = TRUE, divider = mosaic("h")) +
  scale_fill_manual(values = c("blue", "green")) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = rel(1.4))) +
  theme(axis.title.y = element_text(size = rel(1.2))) +
  theme(axis.title.x = element_text(size = rel(1.2))) +
  theme(axis.text.x = element_text(size = rel(1))) +
  theme(axis.text.y = element_text(size = rel(1))) +
  theme(strip.text.y = element_text(size = rel(1.2))) +
  labs(x = "Ticket Class",
       y = "Status",
       fill = "Rescue Status",
       title = "Mosaic Plot of Rescue Status given Ticket Class")

  ##Part b
contingency_table <- table(titanic_data$Ticket, titanic_data$Status)
chisq.test(contingency_table)
chi_squared_test$statistic
chi_squared_test$p.value

  ##Part c
pairwise.prop.test(contingency_table[, "Rescued"], 
                                    rowSums(contingency_table),
                                    p.adjust.method = "BH")


##Problem 3
gss_data <- read.csv("GSS.csv")

  ##Part a
catholic_data <- subset(gss_data, Religion == "Catholic")
table(catholic_data$Wrong) / nrow(catholic_data)

  ##Part b
protestant_data <- subset(gss_data, Religion == "Protestant")
table(protestant_data$Wrong) / nrow(protestant_data)

  ##Part c
ggplot(data = gss_data) +
  geom_mosaic(aes(x = product(Wrong, Religion), fill = Wrong),
              na.rm = TRUE, divider = mosaic("h")) +
  scale_fill_manual(values = c("blue", "green", "brown", "black", "yellow")) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, size = rel(1.4))) +
  theme(axis.title.y = element_text(size = rel(1.2))) +
  theme(axis.title.x = element_text(size = rel(1.2))) +
  theme(axis.text.x = element_text(size = rel(1))) +
  theme(axis.text.y = element_text(size = rel(1))) +
  theme(strip.text.y = element_text(size = rel(1.2))) +
  labs(x = "Religious Affiliation",
       y = "Attitude",
       fill = "Attitude",
       title = "Attitudes Towards Premarital Sex by Religious Affiliation")
  
  ##Part d
contingency_table <- table(gss_data$Religion, gss_data$Wrong)
chi_squared_test <- chisq.test(contingency_table)
chi_squared_test$statistic
chi_squared_test$p.value
  
  ##Part e
expected_freq <- chi_squared_test$expected
which(expected_freq < 5, arr.ind = TRUE)

