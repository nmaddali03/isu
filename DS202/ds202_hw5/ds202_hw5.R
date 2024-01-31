library(ggplot2)
library(dplyr)
library(tidyverse)
library(stringr)
library(lubridate) # Time
library(scales) 

data <- read.csv('./2021_Iowa_Liquor_Sales.csv')
str(data)
View(data)

new_data <- data

#convert the date to a date object
new_data <- new_data %>% mutate(Date = mdy(Date))

#parse out latitude and longitude into their own columns
new_data <- separate(new_data, col = "Store.Location",
                     into=c("Point","Latitude","Longitude"),sep="\\(")
new_data$Point <- NULL
new_data <- separate(new_data, col="Latitude", into=c("Latitude","Longitude"),sep="\\)")
new_data <- separate(new_data, col="Latitude", into=c("Latitude","Longitude"),sep=" ")
View(new_data)

#First overview: Provide a visual breakdown of the liquor category (by Category Name). 
#Include volume sold in the breakdown. Describe your figure. Which type of liquor is the most 
#popular?
new_data$`Category.Name` = factor(new_data$`Category.Name`)
temp_data <- new_data %>% arrange(desc(`Volume.Sold..Gallons.`))
head(temp_data)
labels = temp_data$`Category.Name`[1:20]

new_data %>% ggplot(aes(x = `Category.Name`), group_by = `Volume.Sold..Gallons.`) + 
  geom_bar() + 
  #scale_x_discrete(breaks = labels) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  labs(x = "Category name", y = "Number sold")
#ANALYSIS: American Vodkas is the most popular as it has the most number sold compared to the 
#other categories.

#Which day of the week has the most orders? Use a barchart to visualize the results. Explain 
#the pattern and provide a reason why the pattern occurs.
data1 <- new_data
data1$weekday <- weekdays(data1$Date)
data1

data1 %>% ggplot(aes(x = weekday), group_by = `Volume.Sold..Gallons.`) + 
  geom_bar() +
  labs(x = "Days of the Week", y = "Number sold")
#ANALYSIS: Thursdays have the most orders. This could be a preparation for the weekend type of 
#parties that occur.

#Create a single plot for the monthly volumes sold. Each liquor category should be shown 
#using a separate time series. Label the top 5 categories using text labels.
monthly <- new_data %>%
  group_by(Name=`Category.Name`, month=floor_date(new_data$Date, "month")) %>%
  summarize(totalVolumes = sum(`Volume.Sold..Gallons.`), Name, month)

monthlySummary <- monthly %>%
  group_by(Name) %>%
  summarize(month=max(month), totalVolumes = max(totalVolumes))
monthlySummary <- monthlySummary %>%
  arrange(desc(totalVolumes))

ggplot(monthly, aes(x=month, y=totalVolumes, by=Name))+geom_line() +
  labs(y="Total Volume Sold", title="Total Volume Sold vs. Months of Liquor") +
  geom_text(aes(x=month, y=totalVolumes, label=Name),data=monthly %>% filter(totalVolumes > 1210))


monthly <- new_data %>%
  group_by(Name=`Category.Name`, month=floor_date(new_data$Date, "month")) %>%
  summarize(totalVolumes = sum(`Volume.Sold..Gallons.`))

monthlySummary <- monthly %>%
  group_by(Name) %>%
  summarize(month=max(month), totalVolumes = max(totalVolumes))
monthlySummary <- monthlySummary %>%
  arrange(desc(totalVolumes))

ggplot(monthly, aes(x=month, y=totalVolumes, color=Name))+geom_line() +
  labs(y="Total Volume Sold", title="Total Volume Sold vs. Months of Liquor") +
  geom_text(aes(x=month, y=totalVolumes, label=Name),data=monthly %>% filter(totalVolumes > 1210))

#ANALYSIS: American Vodkas are the highest in volumes sold (gallons) per month. The top 5 categories
#are American Vodkas, Canadian Whiskies, Cocktails/RTD, Straight Bourbon Whiskies, and White Rum. 


#Which categories are spring graduation party favorites? Find at least one category.
#April May June are months of spring
datTest <- new_data %>%
  select(Date, Volume.Sold..Gallons.,Category.Name,) %>%
  filter(between(Date, as.Date("2021-04-01"), as.Date("2021-06-30"))) %>%
  group_by(Name=`Category.Name`) %>%
  summarize(totalVolumes = sum(`Volume.Sold..Gallons.`)) %>%
  arrange(desc(totalVolumes))
View(datTest)  

#ANALYSIS: For this problem, I looked at the volume sold in gallons for the months of April,
#May, and June. American Vodkas is the highest category. The second and third are Canadian Whiskies,
#Cocktails/RTD. These can be the spring graduation party favorites.


               