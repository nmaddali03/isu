Hitters = na.omit(Hitters)
x = model.matrix(Salary~.,data=Hitters)[,-1] 
#the [,-1] removes the intercept term. 
Y = Hitters$Salary


set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test=(-train)
Y.test = Y[test]

grid = 10^seq(10,-2,length=100)
alpha = seq(0.01, 0.99, by=0.01)

cv_error = rep(NA,length(alpha))

for (i in 1:length(alpha)){
  cv_elastic = cv.glmnet(x[train,], Y[train], alpha = alpha[i], lambda=grid)
  cv_error[i] = min(cv_elastic$cvm)
}

best_alpha = alpha[which.min(cv_error)]

## find the optimal lambda with best_alpha
elastic_cv = cv.glmnet(x[train,], Y[train], alpha = best_alpha,lambda=grid)
elastic_cv$lambda.min

enet.train = glmnet(x[train,],Y[train],alpha=best_alpha,lambda=grid)

enet.pred = predict(enet.train,s=elastic_cv$lambda.min,newx=x[test,])
mean((enet.pred-Y.test)^2)
