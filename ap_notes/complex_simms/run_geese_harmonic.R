library(rjags)
library(simmr)
library(readxl)

# Set wd
#setwd("~/transfer/SIMM_Glasgow")

# Load in the data and the output
path = system.file("extdata", "geese_data.xls", package = "simmr")
geese_data = lapply(excel_sheets(path), read_excel, path = path)
geese_consumers <- read.csv('ap_notes/complex_simms/GeeseConsumers2.csv')

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
    f[1:N,k] <- X[1:N,1:L]%*%beta[1:L,k] #~ dnorm(mu_f[i,k],1/pow(sigma_f[k],2))
    #mu_f[1:N,k] <- X[1:N,1:L]%*%beta[1:L,k]
    #sigma_f[k] ~ dgamma(2,1)
  }
  for(l in 1:L) {
    for(k in 1:K) { beta[l,k] ~ dnorm(0,1) }
  }
  for(j in 1:J) { sigma[j] ~ dunif(0,10) }
}
'
X = cbind(1,sin(2*pi*geese_consumers[,4]/365),cos(2*pi*geese_consumers[,4]/365))
data=list(y=geese_consumers[,2:3],
          s_mean=geese_data[[2]][,2:3],
          s_prec=1/geese_data[[2]][,4:5]^2,
          c_mean=geese_data[[3]][,2:3],
          c_prec=1/geese_data[[3]][,4:5]^2,
          q=geese_data[[4]][,2:3],
          N=nrow(geese_consumers),
          K=nrow(geese_data[[2]]),
          J=2,X=X,L=ncol(X))
init = function() {
  list(
    'beta'=matrix(rnorm(data$L*data$K,0,0.1),ncol=data$K,nrow=data$L),
    'sigma'=runif(data$J,0,1)
  )  
}
model=jags.model(textConnection(modelstring), data=data, n.chains=3,init=init)
stop()
output=coda.samples(model=model,variable.names=c('beta'),n.iter=10000,thin=10)
save(output,file='geese2_jags_output.rda')
gelman.diag(output,multivariate=FALSE)
