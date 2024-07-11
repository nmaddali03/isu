##Module 1 - Section 1
##Numerical and Graphical Summaries of Categorical Variables

##Required Libraries
  library(plyr)
  library(ggplot2)

##Read in the data from the ISUeyecolorgender.csv file
  ecgendata <- read.csv(file.choose(), header = T)
  
##Specify different variables from data file
  ecgendata$EyeColor
  ecgendata$Gender

##Set levels for Eye Color variable
  ecgendata$EyeColor<- factor(ecgendata$EyeColor,
                              levels = c("Blue", "Hazel", "Green", 
                                         "Brown", "Other"))

##Make Summary Table for Gender
  gender.counts<- count(ecgendata, var = 'Gender')
  gender.table<- mutate(gender.counts, 
                        prop = freq/sum(gender.counts[2]))
  gender.table<- rbind(gender.table, data.frame(Gender='Total', 
                                                t(colSums(gender.table[, -1]))))
  gender.table

##Make Summary Table for Eye Color
  eyecolor.counts<- count(ecgendata, var = 'EyeColor')
  eyecolor.table<- mutate(eyecolor.counts, 
                          prop = freq/sum(eyecolor.counts[2]))
  eyecolor.table<- rbind(eyecolor.table, data.frame(EyeColor='Total', 
                      t(colSums(eyecolor.table[, -1]))))
  eyecolor.table

##Make Bar Graph for Eye Color  
  ggplot(ecgendata, aes(x=EyeColor))+ 
    geom_bar(fill = "blue", colour = "black")+
    ylim(0, 800)+
    labs(x = "Eye Color",
         y = "Number of Students",
         title = "Eye Colors of STAT 101 Students")+ 
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)),
          axis.title.x = element_text(size = rel(1.4)),
          axis.text.x = element_text(size = rel(1.2)),
          axis.text.y = element_text(size = rel(1.2)),
          plot.title = element_text(hjust=0.5, size = rel(1.6)))

##Make Pie Graph for Eye Color
  pie(t(eyecolor.counts[2]), labels = t(eyecolor.counts[1]),
    col = c("blue", "aquamarine", "green", "brown", "black"), 
    main = "Pie Graph of Eye Colors of Stat 101 Students")
