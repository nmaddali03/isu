#Neha Maddali HW3
#DS301
#2/16/22

##################1a.####################
patient = read.table("/Users/neham/Desktop/DS301/patient.txt",header=FALSE)
names(patient) = c("satisf","age","severe","anxiety")
head(patient) # check to make sure the data was read in correctly

model1=lm(satisf~age+severe+anxiety,data=patient)
summary(model1)

##################1b.####################
deviance(model1)

##################1c.####################
null = lm(satisf~1, data = patient)
deviance(null)

##################1d.####################
summary(model1)

##################1e.####################
ts = (-1.1416)/0.2148
ts
pt(abs(ts), 42, lower.tail=FALSE)*2

##################1f.####################
age_new =c(77)
severe_new=c(68)
anxiety_new=c(3)

new_data = data.frame(age=age_new,severe=severe_new,anxiety=anxiety_new)

predict(model1,newdata=new_data,interval='confidence',level=0.95)

##################1g.####################
head(model1$fitted.values)
head(predict(model1))

##################1g.####################
sum(model1$residual^2)/(46-(3+1))
 
##################3a.####################
library(ISLR2)
head(Carseats)
?Carseats
modelCar = lm(Sales~., data=Carseats)
summary(modelCar)

##################3b.####################
summary(modelCar)

##################3c.####################
ts = (0.0928153) / 0.0041477
ts
#pt(abs(ts),388, lower.tail=FALSE)*2

##################3d.####################
sum(modelCar$residual^2)/(400-(11+1))

##################3f.####################
contrasts(Carseats$ShelveLoc)

##################3g.####################
x = data.frame(CompPrice = mean(Carseats$CompPrice),Income=median(Carseats$Income), 
               Advertising = 15, Population = 500, Price = 50, ShelveLoc = "Good", Age = 30,
               Education = 10, Urban = "Yes", US="Yes")

predict(modelCar,newdata=x,interval='confidence',level=0.99)

##################3h.####################
x = data.frame(CompPrice = mean(Carseats$CompPrice),Income=median(Carseats$Income), 
               Advertising = 15, Population = 500, Price = 50, ShelveLoc = "Good", Age = 30,
               Education = 10, Urban = "Yes", US="Yes")

predict(modelCar,newdata=x,interval='prediction',level=0.99)




