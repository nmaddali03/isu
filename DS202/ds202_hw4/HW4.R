library(ggplot2)
library(tidyverse)
library(dplyr)
install.packages("nycflights13")
library(nycflights13)
library(knitr)
View(airports)
View(flights)
View(weather)

#Find if the flight carriers use the same flight number only once in each day. 
#Create a data frame where each row corresponds to a different combination of date, 
#carrier, and flight number, and there should be an additional column once indicating 
#whether the flight number has been used only once (TRUE) or not (FALSE). Finally, print 
#out the first few rows of the records where the once column is FALSE.

dat <- flights %>%
  group_by(year, month, day, carrier, flight) %>%
  summarize(
    count = n(),
    once = (count == 1)
  )
dat

#Add the location of both the origin and destination (i.e. the lat and lon) to flights. 
#Retain only columns for the airport code, airport name, longitude, and latitude. Name 
#the columns in a user-friendly manner.

dat1 <- flights %>%
  select(year, month, day, carrier, flight, origin, dest)
dat2 <- airports %>%
  select(faa, name, lon, lat)

dat1 %>%
  inner_join(airports, by=c("origin"="faa"))

dat3 <- dat1 %>%
  inner_join(dat2 %>%
               select(faa, name_origin=name, lon_origin=lon, lat_origin=lat),
             by=c("origin"="faa")) %>%
  inner_join(dat2 %>%
               select(faa, name_dest=name, lon_dest=lon, lat_dest=lat),
             by=c("dest"="faa"))
dat3

#Create appropriate numerical and/or graphical summaries to investigate how visibility 
#condition makes it more likely to see a delay. Make sure to also investigate the flight 
#delays with missing visibility values. (Hint: use left_join)
visibPlot <- left_join(flights, weather %>% 
                         select(visib, origin, year, month, day, hour),
                       by = c("origin"="origin","year"="year",
                              "month"="month", "hour"="hour", "day"="day")) %>%
  mutate(visib_group = floor(visib)) %>%
  ggplot(aes(factor(visib_group),dep_delay))+geom_boxplot()+coord_flip()
visibPlot

#Which 5 destination airports have the least severe arrival delay? The severity of delay 
#is defined as the proportion of arriving flights that have no less than 30 minutes 
#arrival delay. To give you a formula, the proportion of delayed flights = the number 
#of delayed flights / the total number of flights. Create a data frame containing the 
#airport name, code, and the severity of delay.
least5 <- flights %>%
  filter(!is.na(arr_delay)) %>%
  mutate(severe = (arr_delay >= 30)) %>%
  group_by(dest) %>%
  summarize(severity=sum(severe)/n()) %>%
  arrange(severity) %>%
  rename("faa"=dest) %>%
  head(5) %>%
  left_join(airports %>% select(name, faa))
least5
  
#What happened on June 13, 2013? Look at the delay severity by airport on that day, and 
#then use Google to cross-reference with the weather.
juneData <- flights %>%
  filter(!is.na(arr_delay)) %>%
  filter(year == 2013, month == 6, day == 13) %>%
  mutate(severe = (arr_delay >= 30)) %>%
  group_by(dest) %>%
  summarize(severity=sum(severe)/n()) %>%
  rename("faa"=dest) %>%
  left_join(airports %>% select(name, faa))
View(juneData)
#Analysis: There was a large series of storms (derechos) in the southeastern US (see 
#June 12-13, 2013 derecho series). 

