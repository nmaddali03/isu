states = row.names(USArrests)
names(USArrests)

## scaling
apply(USArrests,2,mean)
apply(USArrests,2,var)
## If we failed to scale the variables before performing PCA, 
## then most of the principal components that we observed 
## would be driven by the Assault variable, 
## since it has by far the largest mean and variance. 

pr.out = prcomp(USArrests,scale=TRUE)
names(pr.out)
pr.out$scale #standard deviation used for scaling
pr.out$center #means used for scaling

## principal component loadings: 
pr.out$rotation

## principal component score? 
pr.out$x
dim(pr.out$x)
as.matrix(scale(USArrests))%*%pr.out$rotation

## biplot
biplot(pr.out,scale=0)
## unique only up to a sign change

pr.out$rotation = -pr.out$rotation
pr.out$x = -pr.out$x
biplot(pr.out,scale=0)

## variance explained by each principal component
pr.out$sdev^2

######## svd
X = scale(USArrests, center=TRUE, scale=TRUE)
svd(X)$u%*%diag(svd(X)$d) ## principal components
pr.out$x

svd(X)$v ## loading vectors
pr.out$rotation

svd(X)$d^2/49
pr.out$sdev^2

t(svd(X)$v)%*%svd(X)$v
t(svd(X)$u)%*%svd(X)$u

## scree plot
# compute the proportion of variance explained by each principal component
pr.var = svd(X)$d^2/49
pve = pr.var / sum(pr.var)
par(mfrow = c(1, 2))
plot(pve, xlab = "Principal Component",
       ylab = "Proportion of Variance Explained", ylim = c(0, 1),
       type = "b")
plot(cumsum(pve), xlab = "Principal Component",
       ylab = "Cumulative Proportion of Variance Explained", ylim = c(0, 1), type = "b")
## pca regression 