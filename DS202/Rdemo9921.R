library(classdata)
str(cities)
unique(cities$City)
length(unique(cities$City))

#sort, rank, order
#which is the most dangerous city in 2016?
#could use just the number of violent crimes 
dat2016 <- cities[cities$Year == 2016, ]
violent <- dat2016$Violent.crime
names(violent) <- dat2016$City
sort(violent)
sort(violent, decreasing = TRUE)[1:5]
worst5 <- head(sort(violent, decreasing=TRUE), 5)
names(worst5)
str(worst5)

rank(violent)
rank(violent)['Ames']
order(violent)
violent[9]
violent[37]
violent[order(violent)] #same as sort(violent)
dat2016Sorted <- dat2016[order(violent),]

#plotting functions
hist(dat2016$Violent.crime)
boxplot(dat2016$Violent.crime)

hist(dat2016$Violent.crime / dat2016$Population)
boxplot(dat2016$Violent.crime / dat2016$Population)

amesPop <- dat2016[dat2016$City == 'Ames', 'Population']
ankenyPop <- dat2016$Population[dat2016$City == 'Ankeny']
pop <- c(amesPop, ankenyPop)
names(pop) <- c('Ames','Ankeny')
barplot(pop)

#bivariate
plot(dat2016$Population, dat2016$Violent.crime)
plot(log(dat2016$Population),log(dat2016$Violent.crime))
plot(log10(dat2016$Population),log10(dat2016$Violent.crime))

x <- log(dat2016$Population)
y <- log(dat2016$Violent.crime)
city <- dat2016$City
plot(x,y)
points(x[city == 'Ames'], y[city == 'Ames'],col='red')
points(x[city == 'Ames'], y[city == 'Ames'],col='red', cex=2)
points(x[city == 'Ames'], y[city == 'Ames'],col='red', cex=2,pch=3)

#na.omit(cities)

cities$Violent1000 <- cities$Violent.crime / cities$Population * 1000
ames <- cities[cities$city == 'Ames',]
plot(ames$Year, ames$Violent1000)
plot(ames$Year, ames$Violent1000, type = 'b')
plot(ames$Year, ames$Violent1000, type = 'l')
plot(ames$Year, ames$Violent1000, type = 'l', ylim=c(0,max(ames$Violent1000)))

ankeny <- cities[cities$City == 'Ankeny',]
lines(ankeny$Year, ankeny$Violent1000)
points(ankeny$Year, ankeny$Violent1000)
abline(h=2)

plot(ames$Year, ames$Violent.crime,
     ylim=c(0, max(ames$Violent1000)),
     type='b')
points(ankeny$Year, ankeny$Violent1000,
       pch=2,col='blue')
lines(ankeny$Year, ankeny$Violent1000,
      pch=2, col='blue')


#could also use the sum of the number of violent and property crimes