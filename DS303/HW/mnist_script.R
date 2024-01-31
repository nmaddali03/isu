## download data directly: 
# http://yann.lecun.com/exdb/mnist/

# or Cybox: 
# https://iastate.box.com/s/huwcjw4yp2djhpfky7u079pp1iboz75s

## reading in data: 
load_mnist()
#mnist = load_mnist()

ls()
names(train)
names(test)

head(train$y)

dim(train$x)
# each observations represents a 28 x 28 pixel image (we treat it as 784 dimensional observation)
show_digit(train$x[5,])
train$y[5]

## see corresponding X values for 5th observation in my training set? 
train$x[5,200:220]

labels <- paste(train$y[1:25],collapse = ", ")
par(mfrow=c(5,5), mar=c(0.1,0.1,0.1,0.1))
for(i in 1:25) show_digit(train$x[i,], axes=F)

table(train$y)

## apply KNN classifier on MNIST dataset

library(class)
# do not run unless you've saved your work (very slow)
# k5 = knn(train$x, test$x,train$y, k=5)

index.train = sample(1:dim(train$x)[1], 2000, replace=FALSE)
index.test = sample(1:dim(test$x)[1], 100, replace=FALSE)

k5 = knn(train$x[index.train,], test$x[index.test,],train$y[index.train], k=5)

## how to choose k? cross-validation 

