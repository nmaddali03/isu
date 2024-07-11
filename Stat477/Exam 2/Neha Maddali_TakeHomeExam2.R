library(plyr)
library(ggplot2)
library(dplyr)

# data <- read.csv("TakeHomeExam2.Data1.csv")
data <- read.csv(file.choose(), header = T)

# Convert 'Correct' column to logical (TRUE/FALSE)
data$Correct <- data$Correct == "Yes"

# Summary statistics for each version
summary_table <- table(data$Version, data$Correct)
print(summary_table)

# Calculate proportions of correct answers for each version
prop_correct <- prop.table(summary_table, margin = 1)
print(prop_correct)

# Plotting bar chart of proportions
barplot(prop_correct, beside = TRUE, legend.text = TRUE, ylim = c(0, 1), 
        main = "Proportion of Correct Answers by Version", 
        xlab = "Version", ylab = "Proportion of Correct Answers", col = c("lightblue", "lightgreen"))

# Get counts of incorrect answers
incorrect_counts <- rowSums(summary_table) - summary_table[, TRUE]

# Hypothesis test for comparing two population proportions
prop_test <- prop.test(incorrect_counts, rowSums(summary_table), correct = FALSE)
print(prop_test)


# data2 <- read.csv("TakeHomeExam2.Data2.csv")
data2 <- read.csv(file.choose(), header = T)

# Convert 'Correct' columns to logical (TRUE/FALSE)
data2$Question2.Correct <- data2$Question2.Correct == "Yes"
data2$Question3.Correct <- data2$Question3.Correct == "Yes"

# Summary statistics for each question
summary_table <- table(data2$Question2.Correct, data2$Question3.Correct)
print(summary_table)

# Calculate proportions of correct answers for each question
prop_correct <- prop.table(summary_table, margin = 1)
print(prop_correct)

# Plotting bar chart of proportions
barplot(prop_correct, beside = TRUE, legend.text = TRUE, ylim = c(0, 1), 
        main = "Proportion of Correct Answers by Question", 
        xlab = "Question", ylab = "Proportion of Correct Answers", col = c("lightblue", "lightgreen"),
        names.arg = c("Question 2", "Question 3"))

# Hypothesis test for comparing two population proportions
prop_test <- prop.test(summary_table[,1], summary_table[,1] + summary_table[,2])
print(prop_test)

