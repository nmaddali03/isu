library(plyr)
library(ggplot2)


data <- read.csv(file.choose(), header = T)
baby.counts<- count(data, var = 'Baby')
baby.table<- mutate(baby.counts, prop=freq/sum(baby.counts[2]))
baby.table<- rbind(baby.table, data.frame(Baby='Total',
                                          t(colSums(baby.table[, -1]))))
baby.table

ggplot(data, aes(x=Baby))+
  geom_bar(fill="blue", color="black")+
  labs(x="Baby",
       y="Response",
       title="Number of responses per baby")+
  theme_bw()+
  theme(axis.title.y=element_text(size=rel(1.4)),
        axis.title.x = element_text(size=rel(1.4)),
        axis.text.x = element_text(size=rel(1.2)),
        axis.text.y = element_text(size=rel(1.2)),
        plot.title = element_text(hjust=0.5, size=rel(1.6)))


observed_freq <- baby.counts$freq
expected_freq <- rep(sum(baby.counts$freq) / length(baby.counts$freq), length(baby.counts$freq))
chisq.test(observed_freq, p = expected_freq / sum(expected_freq))


prop_B <- baby.table$prop[baby.table$Baby == "B"]
prop_others <- sum(baby.table$prop[baby.table$Baby %in% c("A", "C", "D")])
prop.test(c(prop_B * 33, prop_others * (140 - 33)), c(33, 140 - 33), alternative = "two.sided")



