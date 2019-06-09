# Practical session on using JAGS for Poisson regression

# Start up code - clear workspace and call packages
rm(list=ls()) # Clear the workspace
library(R2jags)

# Data --------------------------------------------------------------------

butterflies = data.frame(garden = factor(c(1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 
                                           2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 
                                           3, 3)),
                         monarchs = c(0, 4, 2, 2, 0, 6, 0, 0, 5, 9, 7, 
                                      5, 7, 5, 9, 5, 10, 14, 12, 12, 
                                      10, 16, 10, 10))

# A simple plot
boxplot(monarchs ~ garden, data = butterflies)

# JAGS code ---------------------------------------------------------------

# Jags code to fit the model to the simulated data
model_code = '
model
{
  # Likelihood
  for (i in 1:N) {
    y[i] ~ dpois(rate[i])
    log(rate[i]) <- alpha + beta_garden2 * x_garden2[i] + 
        beta_garden3 * x_garden3[i]
  }
  # Priors
  alpha ~ dnorm(0, 10^-2)
  beta_garden2 ~ dnorm(0, 10^-2)
  beta_garden3 ~ dnorm(0, 10^-2)
}
'

# Run the model -----------------------------------------------------------

# Set up the data
model_data = with(butterflies, 
                  list(N = length(garden), y = monarchs, 
                  x_garden2 = as.integer(garden==2), 
                  x_garden3 = as.integer(garden==3)))

# Choose the parameters to watch
model_parameters =  c("alpha", "beta_garden2", "beta_garden3")

# Run the model
model_run = jags(data = model_data,
                 parameters.to.save = model_parameters,
                 model.file = textConnection(model_code))

# Look at output ----------------------------------------------------------

stop()
print(model_run)
plot(model_run)

# Extract tbe output of each garden and plot them against the data
garden_1 = exp(model_run$BUGSoutput$sims.list$alpha)
garden_2 = exp(model_run$BUGSoutput$sims.list$beta_garden2)
garden_3 = exp(model_run$BUGSoutput$sims.list$beta_garden3)
n_samples = length(garden_3)

posterior = data.frame(garden = rep(1:3, each = n_samples),
                       monarchs = c(garden_1, garden_2, garden_3))

#boxplot(monarchs ~ garden, data = butterflies)
boxplot(monarchs ~ garden, data = posterior)

# Other tasks -------------------------------------------------------------

# 1) Think carefully about how the model is set up and what the parameters actually represent. Perhpas we could change the model to get a parameter that represents the rate for each garden? 
# 2) The Poisson distribution unrealistically assumes that the mean and the variance are equal. Do you know any other count distributions that might fit these data better. If so fit them!

