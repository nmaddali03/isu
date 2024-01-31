library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(lubridate)



bis.full <- readxl::read_xlsx('KIB - Best in Show (public).xlsx', sheet='Best in show full sheet', skip=2)

bis.full <- bis.full[-1,]

bis.full <- bis.full %>% select(1, "category", "datadog score", 6, "size category", "intelligence category")
colnames(bis.full) <- c("Breed", "Category", "Score", "Popularity", "Size", "Intelligence")


plt <- bis.full %>% ggplot(aes(x = Score, y = Popularity, shape=Intelligence, label=Breed, color=Category)) + geom_point(aes(size=Size))
cols <- c('Herding' = '#CB7057', 'Hound' = '#3E3267', 'Non-sporting' = '#618446', 'Sporting' = '#A22729', 'Terrier' = '#A77619', 'Toy' = '#5A1429', 'Working' = '#293E3C')
plt + scale_color_manual(values = cols)
#plt + scale_shape_manual(values=c(15,16))
plt + theme_void()
#plt + scale_y_reverse()
plt + geom_hline(yintercept=75) + geom_vline(xintercept=2.3)
plt + geom_label_repel()

plt + annotate(geom="text", x = 1, y = 80, label="Score", size = 4)
plt + annotate(geom="text", x = 2.45, y = 0.25, label="Popularity", size=4)

plt + annotate(geom="text", x = 1.2, y = 1, label="Inexplicably Overrated", size=6)
plt + annotate(geom="text", x = 3.5, y = 1, label="Hot Dogs!", size=6)
plt + annotate(geom="text", x = 1, y = 170, label="The Rightly Ignored", size=6)
plt + annotate(geom="text", x = 3.5, y = 170, label="Overlooked Treasures", size=6)
plt




bestInShow <- read_excel('./KIB - Best in Show (public).xlsx', sheet='Best in show')
