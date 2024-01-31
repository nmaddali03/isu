## simulated example where there are truly two clusters

set.seed(2)
x = matrix(rnorm(50*2),ncol=2)
x[1:25,1] <- x[1:25,1] + 3
x[1:25,2] <- x[1:25,2] - 4

## K-means clustering with K = 2
km.out <- kmeans(x,2,nstart=20) #nstart should be at least 20
km.out
km.out$cluster

par(mfrow = c(1, 2))
plot(x, col = c(rep(2,25),rep(3,25)),
     main = "True clusters", xlab = "", ylab = "", pch = 20, cex = 2)

plot(x, col = (km.out$cluster + 1),
       main = "K-Means Clustering Results with K = 2", xlab = "", ylab = "", pch = 20, cex = 2)

## The K-means clustering perfectly separated the observations 
## into two clusters even though we did not supply any group information to kmeans()


## what if we had set K = 3?
set.seed(4)
km.out3 <- kmeans(x, 3, nstart = 20)
plot(x, col = (km.out3$cluster + 1),
     main = "K-Means Clustering Results with K = 3", xlab = "", ylab = "", pch = 20, cex = 2)


