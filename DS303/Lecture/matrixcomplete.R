## Matrix Completion 

## We'll use the USArrests dataset
## We turn the data frame into a matrix, 
## after centering and scaling each column to have mean zero and
## variance one.

X = data.matrix(scale(USArrests))
 
## This dataset does not have any missing values in it. So we are going to 
## randomly select 20 rows (states) and then select one of the four entries
## in each row at random 
## This ensures that every row has at least three observed values.

nomit = 20
set.seed(15)
ina = sample(seq(50), nomit)
inb = sample(1:4, nomit, replace = TRUE)
Xna = X
index.na = cbind(ina, inb)
Xna[index.na] = NA


## Iterative matrix completion 

## We first write a  function that takes in a matrix, 
## and returns an approximation to the matrix using the `svd()` function.

fit.svd = function(X, M = 1) {
  svdob = svd(X)
  with(svdob,
       u[, 1:M, drop = FALSE] %*%
         (d[1:M] * t(v[, 1:M, drop = FALSE]))
  )
}

## We use the `with()` function to make it a little easier to index the elements of `svdob`.


### Step 1
## Replace the missing values with the column means of the non-missing entries.


Xhat = Xna
xbar = colMeans(Xna, na.rm = TRUE)
Xhat[index.na] = xbar[inb]

###
## Before we begin Step 2, we set ourselves up to measure the progress of our
## iterations:
  

thresh = 1e-7
rel_err = 1
iter = 0
ismiss = is.na(Xna)
mssold = mean((scale(Xna, xbar, FALSE)[!ismiss])^2)
mss0 = mean(Xna[!ismiss]^2)


## Here  `ismiss` is a new logical matrix with the same dimensions as `Xna`; 
## a given element equals `TRUE` if the corresponding matrix element is missing. 

## We store the mean of the squared non-missing elements in `mss0`.
## We store the mean squared error of the non-missing elements  of the old version of `Xhat` in `mssold`. 

## We plan to store the mean squared error of the non-missing elements of the current version of `Xhat` in `mss`, 

## Iterate Step 2 of until the *relative error*, defined as (mssold - mss) / mss0, falls below `thresh = 1e-7'.

while(rel_err > thresh) {
  iter = iter + 1
  # Step 2(a)
  Xapp = fit.svd(Xhat, M = 1)
  # Step 2(b)
  Xhat[ismiss] = Xapp[ismiss]
  # Step 2(c)
  mss = mean(((Xna - Xapp)[!ismiss])^2)
  rel_err = (mssold - mss) / mss0
  mssold = mss
  cat("Iter:", iter, "MSS:", mss,
      "Rel. Err:", rel_err, "\n")
}

# We see that after eight iterations, the relative error has fallen below `thresh = 1e-7`, and so the algorithm terminates. 
# When this happens, the mean squared error of the non-missing elements equals 0.369.
