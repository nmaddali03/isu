#logical
TRUE
FALSE
TRUE & FALSE
TRUE | FALSE
!TRUE
!FALSE

#two cartoon characters, Donald the duck and Mickey the mouse
isMouse <- c(FALSE, TRUE)
isDuck <- c(TRUE, FALSE)
canQuack <- c(TRUE, FALSE)
isMouse & isDuck
isMouse | isDuck
isMouse & TRUE

isMouse | isDuck & canQuack
(isMouse | isDuck) & canQuack

!isMouse
!isMouse | isDuck
!(isMouse | isDuck)

#comparison operators
a <- c(1,10)
b <- c(2,3)
a<b
a >= b
a != b
a == b #comparison
a = b #Assignment. NOT WHAT WE WANT HERE
a <- b

x <- 2000:2020
isOdd <- x %% 2 = 1
is2020 <- x = 2000
x[isOdd|is2020]
x[!(isOdd | is2020)]

# %in%
col <- 'cardinal'
redCols <- c('red','wine','cherry','cardinal')
col %in%redCols
c('cherry','pear') %in% redCols

c(1,5) %in% 1:3

ifelse(c(TRUE,FALSE,FALSE),
       'Mickey',
       'Donald')
ifelse(1:10 %% 2 == 0, 'even','odd')

library(classdata)
str(cities)
dat <- cities[cities$City == 'Ames',
              cities$City == 'Ankeny']
dat1 <- cities[cities$City %in% c('Ames','Ankeny'),]

dat == dat1 #wont work
identical(dat, dat1)

plot(dat$Violent.crime, dat$Property.crime,col=ifelse(dat$City == 'Ames','red','black'))

#your turn demo
a <- c(1,15,3,20,5,8,9,10,1,3)
a<20
a[a<20]
a^2 >= 100 | a^2 <10
a[a^2 >= 100 | a^2 <10]
a %in% c(1,3,5)
a[a %in% c(1,3,5)]
a %% 2 == 0
a[a %% 2 == 0]

#datasets
library(classdata)
takeout <- fbi$State =='Iowa' & fbi$Year == 2009
Iowa2009 <- fbi[takeout,]

takeout2 <- fbi$State == 'Iowa' & (fbi$Year == 2009 | fbi$Year == 2010)

#take out some neighbors of Iowa
someStates <- fbi[fbi$State %in% c('Nebraska','Minnesota','Illinois'),]

fbiNoAbb <- fbi[, !names(fbi) %in% c('Abb','Violent.crime')]
str(fbiNoAbb)

#change a column in place
fbiCopy <- fbi
fbiCopy$State[fbiCopy$State == 'Iowa'] <- 'Our State'
unique(fbiCopy$State)

fbi$PopinM <- fbi$Population / 1000000
fbi$Population

x <- c('dog','cat','cat')
factor(x)
factor(x, levels=c('dog', 'cat'))

fbi$rate <- fbi$Count / fbi$Population
type <- reorder(fbi$Type, fbi$rate, median, na.rm=TRUE)
boxplot(fbi$rate ~ type)

x <- c(FALSE, TRUE)
y <- c(FALSE, TRUE)
z <- c(TRUE, FALSE)
x & !y | z

takeout3 <- fbi$State == 'Iowa' & (fbi$Year == 2010 | fbi$Year == 2011)
takeout3
data.frame(table(fbi$State == 'Iowa' & (fbi$Year == 2010 | fbi$Year == 2011)))

