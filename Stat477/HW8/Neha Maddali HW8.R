##Homework 8 Template

##Required Libraries
  library(ggplot2)
  library(pROC)
  library(ResourceSelection)

##Required Functions
  glm.prob.ci<- function(model, newdata = NULL, conf.level = 0.95){
    alpha2.level<- conf.level + (1 - conf.level)/2
    z_alpha2<- qnorm(alpha2.level, 0, 1)
    if (is.null(newdata)=="TRUE") {
      model.logodds<- predict.glm(model, se.fit = T)
      model.logodds.lci<- model.logodds$fit - z_alpha2*model.logodds$se.fit
      model.logodds.uci<- model.logodds$fit + z_alpha2*model.logodds$se.fit
      model.probs.lci<- exp(model.logodds.lci)/(1 + exp(model.logodds.lci))
      model.probs.uci<- exp(model.logodds.uci)/(1 + exp(model.logodds.uci))
      model$data<- cbind(model$data, model.probs.lci, model.probs.uci)
      model$data
    } else {
      model.logodds<- predict.glm(model, newdata = newdata, se.fit = T)
      model.logodds.lci<- model.logodds$fit - z_alpha2*model.logodds$se.fit
      model.logodds.uci<- model.logodds$fit + z_alpha2*model.logodds$se.fit
      model.probs.lci<- exp(model.logodds.lci)/(1 + exp(model.logodds.lci))
      model.probs.uci<- exp(model.logodds.uci)/(1 + exp(model.logodds.uci))
      probs.ci<- cbind(model.probs.lci, model.probs.uci)
      colnames(probs.ci)<- c(as.character(100*(1-alpha2.level)), 
                           as.character(100*alpha2.level))
      list(probs.ci)
    }
  }

  confusion.glm <- function(model, cutoff = 0.5) {
    predicted <- ifelse(predict(model, type='response') > cutoff, 
                      1, 0)
    observed<- model$y
    confusion  <- table(observed, predicted)
    agreement<- (confusion[1,1]+confusion[2,2])/sum(confusion)
    specificity<- confusion[1,1]/rowSums(confusion)[1]
    sensitivity<- confusion[2,2]/rowSums(confusion)[2]
    list("Confusion Table" = confusion, 
         "Agreement" = agreement, 
         "Sensitivity" = sensitivity,
         "Specificity" = specificity)
  }

  McFR2<- function(model) {
    G2<- model$deviance
    G2null<- model$null.deviance
    McFR2<- 1 - G2/G2null
    McFR2
  } 

##Problem 1 - Fit Model with GPA and MCAT
  med<- read.csv(file.choose(), header=T)
  
  ##Part b - Prediction
  model <- glm(Acceptance ~ MCAT + GPA, data = med, family = binomial)
  summary(model)

  ##Part c - Confidence interval for probability
  new_data <- data.frame(MCAT = 38, GPA = 3.54)
  glm.prob.ci(model, newdata = new_data, conf.level = 0.95)
  
  ##Part d - test for overall significance
  model0<- glm(Acceptance ~ 1, data = med,
                       family = binomial)
  anova(model0, model, test = "Chisq")
  
##Problem 2 - Fit Model with GPA, MCAT, and Sex
  
  ##part a
  ##equation for females
  ##equation for males
  model2 <- glm(Acceptance ~ MCAT + GPA + Sex, data = med, family = binomial)
  summary(model2)
  
  ##part b
  ##confidence interval for slope
  exp(confint(model2)[4,])
  
##Problem 3 - Fit Model with GPA, MCAT, and Interaction
  
  ##Part b - Prediction
  model_interaction<- glm(Acceptance ~ MCAT + GPA + MCAT:GPA,
                          data = med,
                          family = binomial)
  summary(model_interaction)
  
  ##Part c - Confidence interval for probability
  new_data <- data.frame(MCAT = 38, GPA = 3.54)
  glm.prob.ci(model_interaction, newdata = new_data, conf.level = 0.95)
  
##Problem 4 - Model selection using all 4 explanatory variables
  
  ##For Final Model, find:
  full_model <- glm(Acceptance ~ MCAT + GPA + Sex + Apps, data = med, family = binomial)
  summary(full_model)
  
  modelstep1<- step(full_model)
  
  modelstep2<- step(full_model, k = log(55))
  
  ##McFadden's R-square
  McFR2(modelstep1)
  
  ##Hosmer-Lemeshow goodness of fit test
  hoslem.test(med$Acceptance,
              modelstep1$fitted.values, g = 5)
  
  ##Confusion Table
  confusion.glm(modelstep1)
  
  ##Roc Curve analysis
  medroc<- roc(med$Acceptance ~ modelstep1$fitted.values)
  ggroc(medroc)+
    theme_bw()+
    theme(axis.title.y = element_text(size = rel(1.4)))+
    theme(axis.title.x = element_text(size = rel(1.4)))+
    theme(axis.text.x = element_text(size = rel(1.2)))+
    theme(axis.text.y = element_text(size = rel(1.2)))+
    theme(plot.title = element_text(hjust=0.5, size = rel(1.6)))+
    geom_segment(aes(x = 1, xend = 0, y = 0, yend = 1),
                 linetype="dashed")+
    labs(x = "Specificity",
         y = "Sensitivity",
         title = "ROC Curve for 'Best' Med Acceptance Model")
  auc(medroc)
  
  