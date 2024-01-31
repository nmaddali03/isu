############################
### Prediction Intervals ### 
############################
patient = read.table("/Volumes/GoogleDrive/My Drive/Teaching/DS303/2-MLR/patient.txt",header=FALSE)

head(patient) #look at the first few rows of the data, make sure it's been loaded into R correctly

# give each column its variable name
names(patient) = c("satisf","age","severe","anxiety")

model = lm(satisf~age+severe+anxiety,data=patient)
summary(model)

Xh = data.frame(age=36,severe=42,anxiety=2.8)

## what is our prediction for Y given age = 36, severe = 42, anxiety = 2.8?
## what is our estimate for E(Y) given age = 36, severe = 42, anxiety = 2.8? 
predict(model,newdata=Xh)

predict(model,newdata=Xh,interval='prediction',level=0.95)
predict(model,newdata=Xh,interval='confidence',level=0.95)

