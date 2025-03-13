# Practical session on using JAGS for logistic regression

# Start up code - clear workspace and call packages
rm(list=ls()) # Clear the workspace
library(R2jags)
library(boot) # Package contains the logit transform

# Data --------------------------------------------------------------------

# Adapted data from Royle and Dorazio (Chapter 2)
# Moth mortality data
N = 12 # Number of experiments
K = 20 # Number of moths in each experiment
y = c(1,4,9,13,18,20, 0,2,6,10,12,16) # Number died
sex = c(rep('male',6), rep('female',6)) # Sex
dose = rep(0:5, 2) # Dose of ???
sex_male = as.integer(sex == 'male') # Turn sex into an integer
# The key questions is: what are the effects of dose and sex?

# Quick exploratory plot
plot(dose, y, col = sex_male + 1)
legend('topleft', legend = c('Female', 'Male'), 
       col = 1:2, pch = 1)

# Or better plot of proportion died
plot(dose, y/K, col = sex_male + 1, las = 1)
legend('topleft', legend = c('Female', 'Male'), 
       col = 1:2, pch = 1)

# JAGS code ---------------------------------------------------------------

# Jags code to fit the model to the simulated data
model_code = '
model
{
  # Likelihood
  for (i in 1:N) {
    y[i] ~ dbin(p_died[i], K)
    logit(p_died[i]) <- alpha + beta_male * x_male[i] + beta_dose * x_dose[i]
  }

  # Priors
  alpha ~ dnorm(0, 10^-2)
  beta_male ~ dnorm(0, 10^-2)
  beta_dose ~ dnorm(0, 10^-2)
}
'

# Run the model -----------------------------------------------------------

# Set up the data
model_data = list(N = N, y = y, x_male = sex_male, x_dose = dose, K = K)

# Choose the parameters to watch
model_parameters =  c("alpha", "beta_male", "beta_dose")

# Run the model
model_run = jags(data = model_data,
                 parameters.to.save = model_parameters,
                 model.file = textConnection(model_code))

# Look at output ----------------------------------------------------------

print(model_run)
plot(model_run)

# Look at effect of sex - quantified by beta_male
hist(model_run$BUGSoutput$sims.list$beta_male, breaks = 30)
# Seems positive - males more likely to die

# Can vconvert this into odds:
hist(exp(model_run$BUGSoutput$sims.list$beta_male), breaks = 30)
# 3 times higher chance of dying if you're male!

# Look at the posterior
head(model_run$BUGSoutput$sims.matrix)

# Extract the mean values of the parameters
alpha_mean = model_run$BUGSoutput$mean$alpha[1]
beta_male_mean = model_run$BUGSoutput$mean$beta_male[1]
beta_dose_mean = model_run$BUGSoutput$mean$beta_dose[1]

# What about effect of dose?
o = order(dose)
plot(dose, y/K, col = sex_male + 1, las = 1)
# Males
with(model_run,
     lines(dose[o],
           inv.logit(alpha_mean + beta_male_mean * 1 + 
                       beta_dose_mean * dose[o]),
           col = 'red'))
# Females
with(model_run,
     lines(dose[o],
           inv.logit(alpha_mean + beta_male_mean * 0 + 
                       beta_dose_mean * dose[o]),
           col = 'blue'))

# Legend
legend('topleft',
       legend = c('Males', 'Females'),
       lty = 1,
       col = c('red','blue'))


# Other tasks -------------------------------------------------------------

# 1) See if there is an interaction between sex and dose in the above example. To do this add an extra term in the model beta_int * x_male[i] * x_dose[i]. Don't forget to include beta_int in your parameters to watch vector. Is beta_int precisely estimated in the posterior?
# 2) It almost always the case that the death rate increases with dose. Try changing the prior distribution on beta_dose to reflect the fact that the parameter should be positive. How much effect does this have on the posterior ditribution of beta_dose?
# 3) (Harder) A common task is to estimate the LD-50, the dose at which 50% of the animals have died. See if you can estimate the LD-50 for males and females with uncertainty. (hint: either estimate a 95% CI for the LD50 for each group or, better yet, produce a full posterior distribution)

