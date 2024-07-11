##Homework 9 Template

##Required Libraries
  library(ggplot2)
  library(nnet)
  library(VGAM)
  library(data.table)

##Problem 1 - Fit Model for AfterLife
  life_data<- read.csv(file.choose(), header=T)
  model <- multinom(Afterlife ~ Gender + Race, data = life_data)
  summary(model)
  
  model<- vglm(Afterlife ~ Gender + Race,
                          data = life_data,
                          family = cumulative(parallel = T))
  summary(lifemodel)
  
  # Fit the null model without the 'Gender' variable
  null_model <- multinom(Afterlife ~ Race, data = life_data)
  
  # Fit the full model with the 'Gender' variable
  full_model <- multinom(Afterlife ~ Gender + Race, data = life_data)
  
  # Perform likelihood ratio test using anova
  lr_test <- anova(null_model, full_model, test = "Chisq")
  print(lr_test)
  
  # Fit the null model without the 'Race' variable
  null_model <- multinom(Afterlife ~ Gender, data = life_data)
  
  # Fit the full model with the 'Race' variable
  full_model <- multinom(Afterlife ~ Gender + Race, data = life_data)
  
  # Perform likelihood ratio test using anova
  lr_test <- anova(null_model, full_model, test = "Chisq")
  print(lr_test)
  
  
##Problem 2 - Fit Model for Gun Control-Death Penalty
  gun_data<- read.csv(file.choose(), header=T)
  
  ## Part a
  # Set baseline categories
  gun_data$Gun.Register <- factor(gun_data$Gun.Register, levels = c("Oppose", "Favor"))
  gun_data$Death.Penalty <- factor(gun_data$Death.Penalty, levels = c("Oppose", "Favor"))
  
  indep_model <- glm(Count ~ Gun.Register + Death.Penalty, data = gun_data, family = poisson)
  expected_counts <- fitted(indep_model) * sum(gun_data$Count)
  print(expected_counts)
  
  # Test goodness of fit
  deviance <- indep_model$deviance
  df_residual <- indep_model$df.residual
  p_value <- pchisq(deviance, df_residual, lower.tail = FALSE)
  print(p_value)
  
  ## Part b
  # Fit the saturated log-linear model
  saturated_model <- glm(Count ~ Gun.Register + Death.Penalty + Gun.Register:Death.Penalty,
                         data = gun_data, family = poisson)
  
  print(summary(saturated_model)$coefficients)
  
  # Calculate odds ratio
  odds_ratio <- exp(coef(saturated_model)["Gun.RegisterFavor"] +
                      coef(saturated_model)["Death.PenaltyFavor"] +
                      coef(saturated_model)["Gun.RegisterFavor:Death.PenaltyFavor"])
  print(round(odds_ratio, 2))
  

##Problem 3 - Shower Data
  shower_data<- read.csv(file.choose(), header=T)
  shower_data$Wet <- factor(shower_data$Wet, levels = c("Toward", "Away"))
  shower_data$Lather <- factor(shower_data$Lather, levels = c("Toward", "Away"))
  shower_data$Rinse <- factor(shower_data$Rinse, levels = c("Toward", "Away"))
  
  # Mutual Independence Model
  mutual_indep <- glm(Count ~ Wet + Lather + Rinse, data = shower_data, family = poisson)
  
  # Joint Independence Models
  joint_indep_wl <- glm(Count ~ Wet + Lather + Rinse + Wet:Lather, data = shower_data, family = poisson)
  joint_indep_wr <- glm(Count ~ Wet + Lather + Rinse + Wet:Rinse, data = shower_data, family = poisson)
  joint_indep_lr <- glm(Count ~ Wet + Lather + Rinse + Lather:Rinse, data = shower_data, family = poisson)
  
  # Conditional Independence Models
  cond_indep_wl <- glm(Count ~ Wet + Lather + Rinse + Wet:Lather + Wet:Rinse, data = shower_data, family = poisson)
  cond_indep_wr <- glm(Count ~ Wet + Lather + Rinse + Wet:Lather + Lather:Rinse, data = shower_data, family = poisson)
  cond_indep_lr <- glm(Count ~ Wet + Lather + Rinse + Wet:Rinse + Lather:Rinse, data = shower_data, family = poisson)
  
  # Homogeneous Association Model
  h_assoc <- glm(Count ~ Wet + Lather + Rinse + Wet:Lather + Wet:Rinse + Lather:Rinse, data = shower_data, family = poisson)
  
  # Saturation Model
  sat_model <- glm(Count ~ Wet + Lather + Rinse + Wet:Lather + Wet:Rinse + Lather:Rinse + Wet:Lather:Rinse, data = shower_data, family = poisson)
  
  models <- list(mutual_indep, 
                 joint_indep_wl, joint_indep_wr, joint_indep_lr, 
                 cond_indep_wl, cond_indep_wr, cond_indep_lr, 
                 h_assoc, 
                 sat_model)
  model_names <- c("Mutual Independence", 
                   "Joint Independence (Wet:Lather)", "Joint Independence (Wet:Rinse)", "Joint Independence (Lather:Rinse)", 
                   "Conditional Independence (Wet:Lather)", "Conditional Independence (Wet:Rinse)", "Conditional Independence (Lather:Rinse)", 
                   "Homogeneous Association", 
                   "Saturation")
  
  # Function to calculate p-value
  calc_p_value <- function(model) {
    pchisq(model$deviance, df.residual(model), lower.tail = FALSE)
  }
  
  # Extract deviance and p-value for each model
  deviances <- sapply(models, function(model) model$deviance)
  p_values <- sapply(models, calc_p_value)
  
  model_comparison <- data.frame(Model = model_names, Deviance = deviances, P_Value = p_values)
  print(model_comparison)
  
  
