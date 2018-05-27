
# Plot the Geese output from the JAGS model in module 8
rm(list=ls())

# Set the working directory
#setwd("/Volumes/MacintoshHD2/GDrive/Conferences&Talks/SIAR_Glasgow/mod_9_building_SIMMs")
setwd("~/GDrive/Conferences&Talks/SIAR_Glasgow/mod_9_building_SIMMs")

# Load in packages
library(siar)
library(compositions)

# Source in bases.r functions
source('bases.r')

# Load in the data and the output
data(geese1demo,sourcesdemo,correctionsdemo,concdepdemo)
sources = as.matrix(sourcesdemo[,2:5])
tefs = as.matrix(correctionsdemo[,2:5])
cd = as.matrix(concdepdemo[,c(2,4)])
con = read.csv('../mod_8_complex_SIMMs/GeeseConsumers2.csv')

# Some useful bits from the data
N = nrow(con)
K = nrow(sources)

# Run the JAGS SIMM Spline model
modelstring ='
model {
  for(i in 1:N) { 
    for(j in 1:J) {
      y[i,j] ~ dnorm(inprod(p[i,]*q[,j],s[,j]+c[,j])/inprod(p[i,],q[,j]),1/pow(sigma[j],2))
    }
  }
  for(k in 1:K) { 
    for(j in 1:J) {
      s[k,j] ~ dnorm(s_mean[k,j],s_prec[k,j]) 
      c[k,j] ~ dnorm(c_mean[k,j],c_prec[k,j]) 
    }
  }
  for(i in 1:N) {
    p[i,1:K] <- expf[i,]/sum(expf[i,])
    for(k in 1:K) {
      expf[i,k] <- exp(f[i,k])
    }
  }
  for(k in 1:K) { 
    f[1:N,k] <- B%*%beta[,k]
    beta[1,k] ~ dnorm(0,0.001)
    for(l in 2:L) { beta[l,k] ~ dnorm(beta[l-1,k],1/pow(sigma_beta[k],2)) }
    sigma_beta[k] ~ dunif(0,10)
  }
  for(j in 1:J) { sigma[j] ~ dunif(0,10) }
}
'

# Run model
con = read.csv('../mod_8_complex_SIMMs/GeeseConsumers2.csv')
data(geese1demo,sourcesdemo,correctionsdemo,concdepdemo)
sources = as.matrix(sourcesdemo[,2:5])
tefs = as.matrix(correctionsdemo[,2:5])
cd = as.matrix(concdepdemo[,c(2,4)])
julianday_rescaled = (con$julianday-299.75)%%365
B = bbase(julianday_rescaled)
data=list(y=con[,2:3],s_mean=sources[,c(1,3)],s_prec=1/sources[,c(2,4)]^2,
          c_mean=tefs[,c(1,3)],c_prec=1/tefs[,c(2,4)]^2,
          q=cd,N=nrow(con),K=nrow(sources),
          J=ncol(con[,2:3]),B=B,L=ncol(B))
model=jags.model(textConnection(modelstring), data=data, n.chains=3)
stop()
output=coda.samples(model=model,variable.names=c('sigma_beta','beta','sigma'),n.iter=10000,thin=10)
save(output,file='SIMM_spline_output.rda')
#load(file='SIMM_spline_output.rda')
gelman.diag(output,multivariate = FALSE)
