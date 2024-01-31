############################
### Prediction Intervals ### 
############################
patient = read.table("/Users/lchu/Documents/Teaching/Academic2021_2022/Fall2021/DS303_F21/Lectures/2-MLR/patient.txt",header=FALSE)

head(patient) #look at the first few rows of the data, make sure it's been loaded into R correctly

# give each column its variable name
names(patient) = c("satisf","age","severe","anxiety")

model = lm(satisf~age+severe+anxiety,data=patient)
summary(model)

Xh = data.frame(age=36,severe=42,anxiety=2.8)
predict(model,newdata=Xh)

predict(model,newdata=Xh,interval='prediction',level=0.95)
predict(model,newdata=Xh,interval='confidence',level=0.95)

age_new =c(46)
severe_new=c(32)
anxiety_new=c(1)

new_data = data.frame(age=age_new,severe=severe_new,anxiety=anxiety_new)

predict(model,newdata=new_data,interval='prediction',level=0.95)

