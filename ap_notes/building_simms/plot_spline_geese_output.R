
# Plot the Geese output from the JAGS model in module 8
rm(list=ls())

# Set the working directory
setwd("/Volumes/MacintoshHD2/GDrive/Conferences&Talks/SIAR_Glasgow/mod_9_building_SIMMs")

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
      f[i,k] ~ dnorm(mu_f[i,k],1/pow(sigma_f[k],2))
    }
  }
  for(k in 1:K) { 
    mu_f[1:N,k] <- B%*%beta[,k]
    sigma_f[k] ~ dgamma(2,1)
    beta[1,k] ~ dnorm(0,0.001)
    for(l in 2:L) { beta[l,k] ~ dnorm(beta[l-1,k],1/pow(sigma_beta[k],2)) }
    sigma_beta[k] ~ dunif(0,10)
  }
  for(j in 1:J) { sigma[j] ~ dunif(0,10) }
}
'
library(siar)
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
output=coda.samples(model=model,variable.names=c('sigma_beta','beta','sigma_f'),n.iter=100000,thin=100)
save(output,file='SIMM_spline_output.rda')
#load(file='SIMM_spline_output.rda')
gelman.diag(output,multivariate = FALSE)
beta_rows = beta_mean = list(length=data$K)
for(k in 1:data$K) {
  beta_rows[[k]] =  grep(paste(',',k,']',sep=''),rownames(summary(output)$statistics))  
  beta_mean[[k]] = summary(output)$statistics[beta_rows[[k]],2]
}

# Load in the jags output
load(file='SIMM_spline_output.rda')

# Sort out the days to plot them properly
julianday_rescaled = (con$julianday-299.75)%%365

# Create grid of predicted values
new_grid = seq(min(julianday_rescaled),max(julianday_rescaled),length=100)
#plot_grid = seq(300,300+length(new_grid)-1,length=length(new_grid))
B_new = bbase(new_grid)
stop()

# Get the beta values - should be ncol(B_new) betas - beta[1,k], beta[2,k], ..., beta[ncol(B_new),k)
out = do.call(rbind,output)
beta_out = list(length=K)
for(k in 1:K) {
  curr_cols = grep(paste(',',k,']',sep=''),colnames(out))    
  beta_out[[k]] = out[,curr_cols]
}

# Now loop through the output creating predictions of the mean
n_samples = nrow(out)
mu_f_pred = array(NA,dim=c(length(new_grid),K,n_samples))
for(s in 1:n_samples) {
  for(k in 1:K) {
    mu_f_pred[,k,s] = B_new%*%beta_out[[k]][s,]
  }
}

# Now create predicted proportions
p_pred = array(NA,dim=c(length(new_grid),K,n_samples))
for(s in 1:n_samples) {
  p_pred[,,s] = clrInv(mu_f_pred[,,s])
}
p_upper = apply(p_pred,c(1,2),'quantile',probs=0.9)
p_median = apply(p_pred,c(1,2),'quantile',probs=0.5)
p_lower = apply(p_pred,c(1,2),'quantile',probs=0.1)

##########################

# Finally create the plot
stop()

# Start plot
par(mar=c(3,3,2,1), mgp=c(2,.7,0), tck=-.01,las=1)
plot(new_grid,new_grid,type='n',xlab='Julian Day',ylim=c(0,1.1),las=1,xaxt='n',ylab='Dietary Proportion',pch=19,main='Dietary proportions by Julian day')

# Add in a specialised axis
grid()
axis(1,at=seq(0,65,by=20),labels=seq(300,365,by=20))
axis(1,at=seq(65,200,by=20),labels=seq(365,500,by=20)%%365)

# Create some colours
transp = 0.5
mycols = c(rgb(1,0,0,transp),rgb(0,0,1,transp),rgb(0,1,0,transp),rgb(1,1,0,transp))

# And finally add lines
for(k in 1:K) {
  polygon(c(new_grid,rev(new_grid)),c(p_lower[,k],rev(p_upper[,k])),col=mycols[k],border=NA)
  lines(new_grid,p_median[,k],lwd=3,col=mycols[k])
}

# Add in some dates
mylinelocs = c(1+365,32+365,61+365,92+365,306,336)
myoffset = -0.5
mylineheight=0.9
lines(c(mylinelocs[1],mylinelocs[1]),c(0,1)) # 1/1
text(mylinelocs[1]+myoffset,mylineheight,labels='1st Jan',srt=90,pos=3,offset=0)
lines(c(mylinelocs[2],mylinelocs[2]),c(0,1)) # 1/2
text(mylinelocs[2]+myoffset,mylineheight,labels='1st Feb',srt=90,pos=3,offset=0)
lines(c(mylinelocs[3],mylinelocs[3]),c(0,1)) # 1/3
text(mylinelocs[3]+myoffset,mylineheight,labels='1st Mar',srt=90,pos=3,offset=0)
lines(c(mylinelocs[4],mylinelocs[4]),c(0,1)) # 1/4
text(mylinelocs[4]+myoffset,mylineheight,labels='1st Apr',srt=90,pos=3,offset=0)
lines(c(mylinelocs[5],mylinelocs[5]),c(0,1)) # 1/11
text(mylinelocs[5]+myoffset,mylineheight,labels='1st Nov',srt=90,pos=3,offset=0)
lines(c(mylinelocs[6],mylinelocs[6]),c(0,1)) # 1/12
text(mylinelocs[6]+myoffset,mylineheight,labels='1st Dec',srt=90,pos=3,offset=0)
legend('top',legend=sourcesdemo[,1],pch=19,col=mycols,horiz=T)

