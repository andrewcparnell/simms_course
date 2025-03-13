# Practical on using linear regression in JAGS

# Call in the package we need
library(R2jags)

# Here is some data on sea level rise
sea_level = read.csv('https://raw.githubusercontent.com/andrewcparnell/tsme_course/master/data/church_and_white_global_tide_gauge.csv')
head(sea_level)

# Create a plot of the data
with(sea_level,plot(year_AD,sea_level_m))
# nicer plotting syntax ;) that matches the call to lm
#plot(year_AD ~ sea_level_m, data = sea_level) 

# Let's fit a linear regression with sea_level_m as the response and year as the covariate

# Fit a standard linear regression
lr_1 = lm(sea_level_m ~ year_AD, data = sea_level)
summary(lr_1)

plot(lr_1$residuals ~ lr_1$fitted.values)

# Now look at the JAGS code for this model
model_code = '
model
{
  # Likelihood
  for (i in 1:n) {
    y[i] ~ dnorm(alpha + beta * x[i], sigma^-2)
  }

  # Priors
  alpha ~ dnorm(0, 100^-2)
  beta ~ dnorm(0, 100^-2)
  sigma ~ dunif(0, 10)
}
'

# Set up the data - these match the data objects in the jags code
model_data = list(n = nrow(sea_level), 
                  y = sea_level$sea_level_m, 
                  x = sea_level$year_AD)

# Choose which parameters to save
model_parameters = c('alpha', 'beta', 
                      'sigma')

# Run the model
model_run = jags(data = model_data,
                 parameters.to.save = model_parameters,
                 model.file = textConnection(model_code))

# Look at the output
print(model_run)

# Things to do:
# 1 Compare the lm output to the jags output to see they match
# 2 Change the prior distributions - make them narrower?
# 3 Change the code/results to get mm per year

# Further output ----------------------------------------------------------

plot(model_run)
traceplot(model_run)

# We can access the full posterior data frame
head(model_run$BUGSoutput$sims.matrix)

# Or you can access just the posterior means
model_run$BUGSoutput$mean$alpha
model_run$BUGSoutput$mean$beta

# We can plot the posterior distributions of the parameters
plot(density(model_run$BUGSoutput$sims.list$alpha))
plot(density(model_run$BUGSoutput$sims.list$beta))

# Create a 90% interval for the sea level rate in mm per year
quantile(model_run$BUGSoutput$sims.list$beta,
         probs = c(0.05, 0.95)) * 1000

# We can create a plot of the posterior mean line
alpha_mean = model_run$BUGSoutput$mean$alpha[1]
beta_mean = model_run$BUGSoutput$mean$beta[1]
x = sea_level$year_AD
with(sea_level,plot(year_AD,sea_level_m))
lines(x, alpha_mean + beta_mean * x, col = 'red')
legend('topleft',
       legend = c('Data', 'Posterior mean'),
       lty=c(-1,1),
       pch=c(1,-1),
       col=c('black','red'))

