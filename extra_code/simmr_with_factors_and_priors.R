# This code runs simmr with a single categorical covariate and puts in informative
# prior distributions on each of the factor levels

# Load in simmr
library(simmr)
library(readxl) # Run install.packages('readxl') if you don't have this
library(httr) # Again run install.packages if you don't have this

# Load in the Geese data from the simmr_with_excel example
sheet_names <- excel_sheets(path = "ap_notes/prac_using_simmr/geese_data.xls")
all <- lapply(sheet_names,
  read_excel,
  path = "ap_notes/prac_using_simmr/geese_data.xls"
)

# Load in the pieces
mix <- all[[1]]
source <- all[[2]]
TDF <- all[[3]]
conc <- all[[4]]

# Use simmr_elicity to provide prior information to the model
# Here I will use sex with two levels to provide prior information
# First sex = 0
sex0 <- simmr_elicit(
  n_source = 4,
  proportion_means = c(0.1, 0.2, 0.3, 0.4),
  proportion_sds = c(0.05, 0.05, 0.1, 0.1),
)
# Now sex = 0
sex1 <- simmr_elicit(
  n_source = 4,
  proportion_means = c(0.2, 0.2, 0.1, 0.5),
  proportion_sds = c(0.1, 0.1, 0.02, 0.2),
)



# Write some JAGS code to run the model with a single factor covariate
model_code <- "
model{
  # Likelihood
  for(j in 1:J) {
    for (i in 1:N) {
      y[i,j] ~ dnorm(inprod(p[i,1:K]*q[,j], s_mean[,j]+c_mean[,j]) / inprod(p[i,1:K],q[,j]), 1/var_y[i,j])
      var_y[i,j] <- inprod(pow(p[i,1:K]*q[,j],2),pow(s_sd[,j],2)+pow(c_sd[,j],2))/pow(inprod(p[i,1:K],q[,j]),2) + pow(sigma[j],2)
    }
  }

  # Prior on sigma
  for(j in 1:J) {
    sigma[j] ~ dgamma(sigma_shape[j], sigma_rate[j])
  }

  # CLR prior on p
  for (i in 1:N) {
    p[i,1:K] <- expf[i,1:K]/sum(expf[i,1:K])
    for(k in 1:K) {
      expf[i,k] <- exp(f[i,k])
      f[i,k] <- inprod(X[i,1:L], beta[k,1:L])
    }
  }
  
  # Prior on beta
  for (k in 1:K) {
    for (l in 1:L) {
      beta[k,l] ~ dnorm(beta_mean[k,l], beta_sd[k,l]^-2)
    }
  }
  
  # Also get predictions
  for (i in 1:N_pred) {
    p_pred[i,1:K] <- expf_pred[i,1:K]/sum(expf_pred[i,1:K])
    for(k in 1:K) {
      expf_pred[i,k] <- exp(f_pred[i,k])
      f_pred[i,k] <- inprod(X_pred[i,1:L], beta[k,1:L])
    }
  }
}"

# Set up the data
model_data <- list(
  N = nrow(mix),
  J = 2,
  K = nrow(source),
  y = mix[,1:2],
  q = conc[,2:3],
  s_mean = source[,2:3],
  s_sd = source[,4:5],
  c_mean = TDF[,2:3],
  c_sd = TDF[,4:5],
  X = model.matrix(~factor(mix$Sex) - 1),
  L = ncol(model.matrix(~factor(mix$Sex) - 1)),
  X_pred = cbind(c(0, 1), c(1, 0)),
  N_pred = 2,
  beta_mean = cbind(sex0$mean, sex1$mean), # This is where the clever prior information comes in
  beta_sd = cbind(sex0$sd, sex1$sd),
  sigma_shape = rep(3, 2),
  sigma_rate =  rep(3/50, 2)
)

# Run this through simmr
out <- jags(
  data = model_data,
  model = textConnection(model_code),
  parameters.to.save = c("p", "beta", "sigma", "f", "f_pred", "p_pred")
)

plot(out)

# Create a plot of the histograms for the two levels across the sources
par(mfrow = c(2, 4))
source_names <- as.vector(source[,1]$Sources)
for(i in 1:4) {
  hist(out$BUGSoutput$sims.list$p_pred[,1,i], breaks = 30, main = paste("Sex = 0;", source_names[i]))  
}
for(i in 1:4) {
  hist(out$BUGSoutput$sims.list$p_pred[,2,i], breaks = 30, main = paste("Sex = 1;", source_names[i]))  
}
par(mfrow = c(1, 1))

