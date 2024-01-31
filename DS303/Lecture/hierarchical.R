## simulated example where there are truly two clusters

set.seed(2)
x = matrix(rnorm(50*2),ncol=2)
x[1:25,1] <- x[1:25,1] + 3
x[1:25,2] <- x[1:25,2] - 4

distM = dist(x)
hc.complete <- hclust(distM, method="complete")
# dist() using Euclidean distance matrix
# complete linkage

hc.average <- hclust(dist(x), method="average")
hc.single <- hclust(dist(x), method="single")

par(mfrow=c(1,3))
plot(hc.complete, main = "Complete Linkage", xlab = "", sub ="", cex = 0.9)
plot(hc.average, main = "Average Linkage", xlab = "", sub ="", cex = 0.9)
plot(hc.single, main = "Single Linkage", xlab = "", sub ="", cex = 0.9)

par(mfrow=c(1,1))

## to determine the cluster labels for each observation associated with a given cut of the dendrogram, we can use the cutree() function: 

cutree(hc.complete,2) # cut tree so we obtain 2 clusters
cutree(hc.average,2)
cutree(hc.single,2)

cutree(hc.single,4)

library("dendextend")
dendro = as.dendrogram(hc.complete)
dendo = color_branches(dendro,k=4) # auto-coloring 4 clusters of branches.
plot(dendo)

################################
library(ISLR2)

# NCI60 cancer cell line microarray data, which consists of 6,830 gene expression measurements on 64 cancer cell lines.
nci.labs <- NCI60$labs
nci.data <- NCI60$data
dim(nci.data)

# each line of the data is labeled with a cancer type (that is stored in nci.labs)
# we will not make use of these labels since we want to illustrate unsupervised techniques. 

table(nci.labs)
sd.data <- scale(nci.data)

par(mfrow = c(1, 3))
data.dist <- dist(sd.data)

plot(hclust(data.dist), xlab = "", sub = "", ylab = "", labels = nci.labs, main = "Complete Linkage",cex.labs=0.5) 

plot(hclust(data.dist, method = "average"),labels = nci.labs, main = "Average Linkage",xlab = "", sub = "", ylab = "")

plot(hclust(data.dist, method = "single"), labels = nci.labs, main = "Single Linkage", xlab = "", sub = "", ylab = "")

#Clearly cell lines within a single cancer type do tend to cluster together, although the clustering is not perfect. We will use complete linkage hierarchical clustering for the code that follows.

hc.out <- hclust(dist(sd.data))
hc.clusters <- cutree(hc.out, 4)
table(hc.clusters, nci.labs)

#let's see what the cut on the dendrogram looks like:
plot(hc.out, labels = nci.labs) 
abline(h = 139, col = "red")


