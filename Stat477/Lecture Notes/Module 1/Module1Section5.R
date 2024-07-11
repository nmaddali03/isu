##Module 1 - Section 5
##Confidence Intervals for a Population Proportion

##Required Libraries
  library(ggplot2)

##Required Functions  
  prop.ci<- function(y, n, type, conf.level){
    phat<- y/n
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    newy<- y + z^2/2
    newn<- n + z^2
    newphat<- newy/newn
  
  
    if (type=="normal") {
      lowerci<- phat - z*sqrt(phat*(1-phat)/n)
      upperci<- phat + z*sqrt(phat*(1-phat)/n)
    }
  
    else if (type=="score") {
      lowerci<- (phat + (1/(2*n))*z^2 - z*sqrt(phat*(1-phat)/n + z^2/(4*n^2)))/(1 + (1/n)*z^2)
      upperci<- (phat + (1/(2*n))*z^2 + z*sqrt(phat*(1-phat)/n + z^2/(4*n^2)))/(1 + (1/n)*z^2)
    }
  
    else {
      lowerci<- newphat - z*sqrt(newphat*(1-newphat)/newn)
      upperci<- newphat + z*sqrt(newphat*(1-newphat)/newn)
    }
    cat(lowerci, upperci, "\n")
  }

  nprop.ci<- function(p, m, conf.level) {
    alpha<- 1 - conf.level
    z<- qnorm(1 - alpha/2)
    ceiling((z/m)^2*p*(1-p))
  }

##Obtain confidence interval using normal approximation method
  prop.ci(64,400,type = "normal", 0.95)
  
##Obtain confidence interval using score method
  prop.ci(64,400,type = "score", 0.95)
  
##Find sample size using worse-case scenario value of p = 0.5  
  nprop.ci(0.5, 0.02, 0.95)
  
##Find sample size using best estimate of value of p (in this example = 0.2)
  nprop.ci(0.2, 0.02, 0.95)

