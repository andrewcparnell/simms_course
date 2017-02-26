library(rjags)
library(siar)

# Set wd
#setwd("~/transfer/SIMM_Glasgow")

# Load in the data and the output
data(geese1demo,sourcesdemo,correctionsdemo,concdepdemo)
sources = as.matrix(sourcesdemo[,2:5])
tefs = as.matrix(correctionsdemo[,2:5])
cd = as.matrix(concdepdemo[,c(2,4)])
con = read.csv('GeeseConsumers2.csv')

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
X = cbind(1,sin(2*pi*con$julianday/365),cos(2*pi*con$julianday/365))
stop()
data=list(y=con[,2:3],s_mean=sources[,c(1,3)],s_prec=1/sources[,c(2,4)]^2,
          c_mean=tefs[,c(1,3)],c_prec=1/tefs[,c(2,4)]^2,
          q=cd,N=nrow(con),K=nrow(sources),
          J=ncol(con[,2:3]),X=X,L=ncol(X))
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
