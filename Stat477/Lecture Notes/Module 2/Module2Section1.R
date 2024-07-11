##Module 2 - Section 1
##Numerical and Graphical Summaries of Contingency Tables

##Required Libraries
  library(ggplot2)
  library(ggmosaic)
  
##Read in the data from the ISUeyecolorgender.csv file  
  ecgendata <- read.csv(file.choose(), header = T)

##Set the levels of the Eye Color variable
  ecgendata$EyeColor<- factor(ecgendata$EyeColor, 
                              levels = c("Blue", "Hazel", "Green", "Brown", "Other"))

##Obtain and view the contingency table of the two variables
  ecgentable<- table(ecgendata$Gender, ecgendata$EyeColor)
  ecgentable

##Find the marginal distribution of the Gender variable (row = 1)
  margin.table(ecgentable, 1)
  round(margin.table(ecgentable, 1)/sum(ecgentable), 4)

##Find the marginal distribution of the Eye Color variable (column = 2)
  margin.table(ecgentable, 2)
  round(margin.table(ecgentable, 2)/sum(ecgentable), 4)

##Find the conditional distributions of Eye Color given Gender (row = 1)
  round(prop.table(ecgentable, 1), 4)
  
##Find the conditional distributions of Gender given Eye Color (column = 2)
  round(prop.table(ecgentable, 2), 4)

##Graph the segmented bar graph of Eye Color given Gender
  ggplot(ecgendata, aes(x = Gender, fill = EyeColor))+
    geom_bar(position = "fill")+
    scale_fill_manual(values = c("blue", "aquamarine", "green",
                                  "brown", "black"))+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.2)),
          axis.title.x = element_text(size = rel(1.2)),
          axis.text.x = element_text(size = rel(1)),
          axis.text.y = element_text(size = rel(1)),
          plot.title = element_text(hjust=0.5, size = rel(1.4)))+
    labs(y = "Proportion",
         title = "Segmented Bar Graph of Eye Color given Gender")

##Graph the segmented bar graph of Gender given Eye Color
  ggplot(ecgendata, aes(x = EyeColor, fill = Gender))+
    geom_bar(position = "fill")+
    scale_fill_manual(values=c("pink", "blue"))+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.2)),
          axis.title.x = element_text(size = rel(1.2)),
          axis.text.x = element_text(size = rel(1)),
          axis.text.y = element_text(size = rel(1)),
          plot.title = element_text(hjust=0.5, size = rel(1.4)))+
    labs(y = "Proportion",
         x = "Eye Color",
         title = "Segmented Bar Graph of Gender given Eye Color")

##Graph the mosaic plot of Eye Color given Gender
  ggplot(data = ecgendata)+
    geom_mosaic(aes(x = product(EyeColor, Gender), fill = EyeColor),
                   na.rm = TRUE, divider =  mosaic("h"))+
    scale_fill_manual(values = c("blue", "aquamarine", "green",
                                 "brown", "black"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.4)))+
    theme(axis.title.y = element_text(size = rel(1.2)))+
    theme(axis.title.x = element_text(size = rel(1.2)))+
    theme(axis.text.x = element_text(size = rel(1)))+
    theme(axis.text.y = element_text(size = rel(1)))+
    theme(strip.text.y = element_text(size = rel(1.2)))+
    labs(x = "Gender", 
         y = "Eye Color", 
         fill = "Eye Color", 
         title = "Mosaic Plot of Eye Color given Gender")

##Graph the mosaic plot of Gender given Eye Color
  ggplot(data = ecgendata)+
    geom_mosaic(aes(x = product(Gender, EyeColor), fill = Gender), 
              na.rm = TRUE, divider =  mosaic("h"))+
    scale_fill_manual(values=c("pink", "blue"))+
    theme_bw()+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.4)),
          axis.title.y = element_text(size = rel(1.2)),
          axis.title.x = element_text(size = rel(1.2)),
          axis.text.x = element_text(size = rel(1)),
          axis.text.y = element_text(size = rel(1)),
          strip.text.y = element_text(size = rel(1.2)))+
    labs(x = "Eye Color", 
         y = "Gender", 
         fill = "Gender", 
         title = "Mosaic Plot of Gender given Eye Color")

