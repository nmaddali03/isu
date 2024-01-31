fit.svd = function(X, M = 1) {
  svdob = svd(X)
  with(svdob,
       u[, 1:M, drop = FALSE] %*%
         (d[1:M] * t(v[, 1:M, drop = FALSE]))
  )
}

MatrixComplete = function(data, Boston, M){
  Xna = scale(data)
  Xhat = scale(data)
  xbar = colMeans(Xna, na.rm = TRUE)
  for(i in 1:dim(Xhat)[2]){
    Xhat[,i][is.na(Xhat[,i])] <- xbar[i]
  }
  thresh = 1e-7
  rel_err = 1
  iter = 0
  ismiss = is.na(Xna)
  mssold = mean((scale(Xna, xbar, FALSE)[!ismiss])^2)
  mss0 = mean(Xna)
  
  while((rel_error > thresh) && (iter<500)){
    iter = iter + 1
    #Step 2(a)
    Xapp = fit.svd(Xhat, M=M)
    #Step 2(b)
    Xhat[ismiss] = Xapp[ismiss]
    #Step 2(c)
    mss = mean(((Xna - Xapp)[!ismiss])^2)
    rel_err = (mssold - mss) / mss0
    mssold = mss
    cat("Iter:", iter, "MSS:", mss,
        "Rel. Err:", rel_err, "\n")
  }
  X=scale(Boston)
  rss = mean((Xhat-X)^2)
  return(rss)
}

library(ISLR2)
M=8
results = matrix(NA, nrow=10, ncol=6)
for(m in 1:M){
  for(k in 1:10){
    ina = inb = c()
    for(i in 1:6){
      nomit = 25
      ina0 = sample(1:nrow(Boston), nomit)
      inb0 = sample(1:ncol(Boston), nomit, replace = TRUE)
      ina = c(ina0, ina) #nested missing
      inb = c(inb0, inb)
      index.na = cbind(ina, inb)
      #Xna = scale(Boston)
      Xna[index.na] = NA
      results[k,i] = MatrixComplete(Xna, Boston, M=m)
    }
  }
  assign(paste("results", m, sep=""), results)
  print(m)
}

meanM1 = colMeans(results1)
meanM2 = colMeans(results2)
meanM3 = colMeans(results3)
meanM4 = colMeans(results4)
meanM5 = colMeans(results5)
meanM6 = colMeans(results6)
meanM7 = colMeans(results7)
meanM8 = colMeans(results8)
par(mfrow=c(4,2))
plot(seq(5,30,by=5),meanM1,xlab="missingness",ylab="approx error; M=1", type="b")
plot(seq(5,30,by=5),meanM2,xlab="missingness",ylab="approx error; M=2", type="b")
plot(seq(5,30,by=5),meanM3,xlab="missingness",ylab="approx error; M=3", type="b")
plot(seq(5,30,by=5),meanM4,xlab="missingness",ylab="approx error; M=4", type="b")
plot(seq(5,30,by=5),meanM5,xlab="missingness",ylab="approx error; M=5", type="b")
plot(seq(5,30,by=5),meanM6,xlab="missingness",ylab="approx error; M=6", type="b")
plot(seq(5,30,by=5),meanM7,xlab="missingness",ylab="approx error; M=7", type="b")
plot(seq(5,30,by=5),meanM8,xlab="missingness",ylab="approx error; M=8", type="b")
