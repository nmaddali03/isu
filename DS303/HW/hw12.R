#Neha Maddali HW12
#DS303
#12/4/23

###############################
## Problem 1: Concept Review ##
###############################
################## 1c.i. ####################
library(ISLR)
str(USArrests)
pr.out = prcomp(USArrests, scale = TRUE)
pr.var = pr.out$sdev^2
pve = pr.var / sum(pr.var)
sum(pr.var)
pve

################## 1c.ii. ####################
loadings = pr.out$rotation
USArrests2 = scale(USArrests)
sumvar = sum(apply(as.matrix(USArrests2)^2, 2, sum))
apply((as.matrix(USArrests2) %*% loadings)^2, 2, sum) / sumvar


######################################################
## Problem 2: Simulations for Unsupervised Learning ##
######################################################
################## 2a. ####################
#set.seed(1)
set.seed(1)
c1 = c2 = c3 = matrix(NA,nrow=20,ncol=50)
for(i in 1:20){
  c1[i,]= rnorm(50,2,1.5)
  c2[i,] = rnorm(50,3,1.5)
  c3[i,] = rnorm(50,4,1.5)
}
data = rbind(c1,c2,c3)

################## 2b. ####################
pr.out = prcomp(data)
standard_deviations = pr.out$sdev

# Compute the proportion of variance explained (PVE) for each principal component
variance_explained = (standard_deviations^2) / sum(standard_deviations^2)
pve_first_two = sum(variance_explained[1:2]) # PVE for the first two principal components
print(pve_first_two)

################## 2d. ####################
colors = c(rep("red", 20), rep("green", 20), rep("blue", 20))
plot(pr.out$x[, 1:2], col = colors, pch = 16, main = "PCA: First Two Principal Components")
legend("topright", legend = c("Class 1", "Class 2", "Class 3"), fill = c("red", "green", "blue"))

################## 2e. ####################
km.out = kmeans(pr.out$x, 3, nstart = 20)
true.labels = c(rep(1, 20), rep(2, 20), rep(3, 20))
table(true.labels, km.out$cluster)

################## 2f. ####################
km.out = kmeans(pr.out$x, 2, nstart = 20)
table(true.labels, km.out$cluster)

################## 2g. ####################
km.out = kmeans(pr.out$x, 4, nstart = 20)
table(true.labels, km.out$cluster)

################## 2h. ####################
km.out = kmeans(pr.out$x[, 1:2], 3, nstart = 20)
table(true.labels, km.out$cluster)


##################################
## Problem 3: Matrix Completion ##
##################################
matrix_completion_experiment <- function(data, missing_fraction, M_values = 1:8, num_reps = 10, max_iter = 100, verbose = FALSE) {
  
  # Function to perform matrix completion using the iterative algorithm
  fit.svd = function(X, M = 1) {
    svdob = svd(X)
    with(svdob,
         u[, 1:M, drop = FALSE] %*%
           (d[1:M] * t(v[, 1:M, drop = FALSE]))
    )
  }
  
  # Function to calculate relative error
  calculate_relative_error = function(Xna, Xapp, ismiss) {
    mss = mean(((Xna - Xapp)[!ismiss])^2)
    rel_err = (mssold - mss) / mss0
    return(rel_err)
  }
  
  # Standardize features to have mean zero and standard deviation one
  X = data.matrix(scale(data))
  results = matrix(NA, nrow = length(M_values), ncol = length(missing_fraction))
  
  for (m in M_values) {
    for (frac in missing_fraction) {
      errors = numeric(num_reps)
      
      for (rep in 1:num_reps) {
        set.seed(rep)
        
        # Randomly leave out observations
        nomit = floor(frac * nrow(X))
        ina = sample(seq(nrow(X)), nomit)
        inb = sample(1:ncol(X), nomit, replace = TRUE)
        Xna = X
        index.na = cbind(ina, inb)
        Xna[index.na] = NA
        
        # Step 1: Replace missing values with column means of non-missing entries
        Xhat = Xna
        xbar = colMeans(Xna, na.rm = TRUE)
        Xhat[index.na] = xbar[inb]
        
        # Setup for iterations
        thresh = 1e-7
        rel_err = 1
        iter = 0
        ismiss = is.na(Xna)
        mssold = mean((scale(Xna, xbar, FALSE)[!ismiss])^2)
        mss0 = mean(Xna[!ismiss]^2)
        
        # Iterative matrix completion
        while (rel_err > thresh & iter < max_iter) {
          iter = iter + 1
          # Step 2(a)
          Xapp = fit.svd(Xhat, M = m)
          # Step 2(b)
          Xhat[ismiss] = Xapp[ismiss]
          # Step 2(c)
          rel_err = calculate_relative_error(Xna, Xapp, ismiss)
          mssold = mean(((Xna - Xapp)[!ismiss])^2)
          
          if (verbose) {
            cat("Iter:", iter, "MSS:", mssold, "Rel. Err:", rel_err, "\n")
          }
        }
        errors[rep] = mssold
      }
      # Store the average error over repetitions
      results[m, which(missing_fraction == frac)] = mean(errors)
    }
  }
  return(results)
}

library(MASS)
data(Boston)

# Specify the missing fractions and M values
missing_fraction_values = seq(0.05, 0.3, by = 0.05)
M_values = 1:8

results = matrix_completion_experiment(Boston, missing_fraction_values, M_values, num_reps = 10, max_iter = 100, verbose = FALSE)
results_transposed = t(results)
matplot(missing_fraction_values, results_transposed, type = "l", col = 1:8, lty = 1:8, xlab = "Fraction of Missing Observations", ylab = "Approximation Error", main = "Matrix Completion Experiment")
legend("topright", legend = paste("M =", M_values), col = 1:8, lty = 1:8, cex = 0.8)


###########################################################
## Problem 4: Hierarchical clustering and Classification ##
###########################################################
################## 4a. ####################
data = read.csv("gene.csv", header=FALSE)
distM = dist(cor(data))

hc.complete = hclust(distM, method = "complete")
plot(hc.complete)

hc.single = hclust(distM, method = "single")
plot(hc.single)

hc.average = hclust(distM, method = "average")
plot(hc.average)

################## 4c. ####################
library(stats)
library(caret)
library(MASS)

clusters = cutree(hc.complete, k=2)
data$Cluster = factor(clusters)

pca_result = prcomp(data[, -ncol(data)], scale.=TRUE)
pca_data = as.data.frame(predict(pca_result))
final_data = cbind(pca_data, Cluster = data$Cluster)

# Fit logistic regression
logreg_model = glm(Cluster ~ ., data=final_data, family=binomial)

# Predict cluster assignments
predicted_clusters = predict(logreg_model, type="response")

# Convert predicted probabilities to cluster assignments (1 or 2)
predicted_clusters = ifelse(predicted_clusters > 0.5, 2, 1)

conf_matrix = confusionMatrix(factor(predicted_clusters), final_data$Cluster)
print(conf_matrix)
misclassification_rate = 1 - sum(conf_matrix$byClass["Balanced Accuracy"])/100
misclassification_rate
