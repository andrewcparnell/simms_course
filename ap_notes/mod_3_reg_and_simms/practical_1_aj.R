# This is the first jags file I ran while on the SIMMS course in 
# Glasgow 12/01/16.
# It is taken from Andrew Parnell's code in 
# module_3_reg_and_simms.Rmd


# ---------------------------------------------------------------------
# A little housekeeping to start
rm(list=ls())
graphics.off()

# ---------------------------------------------------------------------
# Load the required libraries
library(rjags)
library(siar)

# --------------------------------------------------------------------
# load the data
# And now the demo example included with SIAR

# this data is bundled with the siar package
data(geese1demo) # the consumer data
data(sourcesdemo) # the source data

# extract the data we need for this one-isotope example
consumers = geese1demo[,2]
sources = sourcesdemo[1:2,4:5]


con_grid = seq(-35,-5,length=100)
plot(con_grid,dnorm(con_grid,mean=sources[2,1],sd=sources[2,2]),
     type='l',col='red',xlab='d13C',ylab='Probability density')
lines(con_grid,dnorm(con_grid,mean=sources[1,1],sd=sources[1,2]),
      col='blue')
points(consumers,rep(0,9))
legend('topright',legend=c('Grass','Zostera','Consumers'),
       lty=c(1,1,-1),pch=c(-1,-1,1),col=c('red','blue','black'))

# ---------------------------------------------------------------------
# Lines 193 - 210
# This is a very basic mixing model

# specify the jags model
modelstring ='
model {
  for(i in 1:N) { 
    y[i] ~ dnorm( p_1 * s_1 + p_2 * s_2, 1 / pow(sigma, 2) ) 
  }

  p_1 ~ dunif(0,1)
  p_2 <- 1-p_1
  s_1 ~ dnorm(s_1_mean,s_1_prec)
  s_2 ~ dnorm(s_2_mean,s_2_prec)
  sigma ~ dunif(0,10)
}
' # end of string

# specify the data
data = list(y = consumers, 
            s_1_mean = sources[1,1],
            s_1_prec = 1 / sources[1,2] ^ 2,
            s_2_mean = sources[2,1],
            s_2_prec = 1 / sources[2,2] ^ 2,
            N = length(consumers)
            ) # end of data specification

# generate the model
model = jags.model(textConnection(modelstring), data=data)

# generate the samples for the posterior
output = coda.samples(model=model,variable.names=c("p_1","p_2"),
                    n.iter=10000)

plot(output)

# focus in on chain one to check the trace as it looks to 
# me like it is a bit correlated.
plot(output[[1]][1000:1500,1], type = "b")

# Autocorrelation of the posterior chain for p_1
# Which i dont like! its badly correlated even up to 
# a lag of 20!!
acf(output[[1]][,1])

# ----------------------------------------------------------
# add a second chain
model = jags.model(textConnection(modelstring), 
                   data=data,
                   n.chains = 3)

# re-run the model and thin the output by 20
# generate the samples for the posterior
output.2 = coda.samples(model=model,
                      variable.names=c("p_1","p_2"),
                      n.iter = 20 * 10000,
                      thin = 20)

# chech the output of our new model that is thinned
plot(output.2)

# check the zoom in again
plot(output.2[[1]][1000:1500,1], type = "b")

# check the acf again
acf(output.2[[1]][,1])

