
set.seed(1) # so we all get the same x values. 
n = 100
p = 20
Xmat = matrix(NA,nrow=n,ncol=p)
for(i in 1:p){
  Xmat[,i] = rnorm(n)
}
beta = rep(seq(1,3,length.out=5),4)
Y = Xmat%*%beta + rnorm(n,0,1)

train_set = data.frame(Xmat,Y)