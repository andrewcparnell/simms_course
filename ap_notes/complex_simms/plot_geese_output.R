
# Plot the Geese output from the JAGS model in module 8
rm(list=ls())

# Set the working directory
#setwd("/Volumes/MacintoshHD2/GDrive/Conferences&Talks/SIAR_Glasgow/mod_8_timeseries_SIMMs")
#setwd("~/GDrive/Conferences&Talks/SIAR_Glasgow/mod_8_complex_SIMMs")
#setwd("~/transfer/SIMM_Glasgow")

# Load in packages
library(simmr)
library(readxl)
library(compositions)

# Load in the data and the output
path = system.file("extdata", "geese_data.xls", package = "simmr")
geese_data = lapply(excel_sheets(path), read_excel, path = path)
geese_consumers <- read.csv('ap_notes/complex_simms/GeeseConsumers2.csv')
julianday = geese_consumers$julianday
con = geese_data[[1]]
sources = geese_data[[2]]
TDF = geese_data[[3]]
Conc = geese_data[[4]]

# Some useful bits from the data
N = nrow(con)
K = nrow(sources)

# Load in the jags output
load(file='ap_notes/complex_simms/geese2_jags_output.rda')
out = do.call(rbind,output)

# Sort out the days to plot them properly
newday = julianday
newday[newday<299.75] = abs(newday[newday<299.75])+365

# Create grid of predicted values
new_grid = c(290:365,1:110)
plot_grid = seq(300,300+length(new_grid)-1,length=length(new_grid))
X_new = cbind(1,sin(2*pi*new_grid/365),cos(2*pi*new_grid/365))

# Get the beta values - should be three betas - beta[1,k], beta[2,k], beta[3,k]
beta_out = list(length=K)
for(k in 1:K) beta_out[[k]] = out[,(3*k-2):(3*k)]

# Now loop through the output creating predictions of the mean
n_samples = nrow(out)
f_pred = array(NA,dim=c(length(new_grid),K,n_samples))
for(s in 1:n_samples) {
  for(k in 1:K) {
    f_pred[,k,s] = X_new%*%beta_out[[k]][s,]
  }
}

# Now create predicted proportions
p_pred = array(NA,dim=c(length(new_grid),K,n_samples))
for(s in 1:n_samples) {
  p_pred[,,s] = clrInv(f_pred[,,s])
}
p_upper = apply(p_pred,c(1,2),'quantile',probs=0.9)
p_median = apply(p_pred,c(1,2),'quantile',probs=0.5)
p_lower = apply(p_pred,c(1,2),'quantile',probs=0.1)

##########################

# Finally create the plot

# Start plot
par(mar=c(3,3,2,1), mgp=c(2,.7,0), tck=-.01,las=1)
plot(newday,newday,type='n',xlab='Julian Day',ylim=c(0,1.1),las=1,xaxt='n',ylab='Dietary Proportion',pch=19,main='Dietary proportions by Julian day')

# Add in a specialised axis
grid()
axis(1,at=seq(300,365,by=20),labels=seq(300,365,by=20))
axis(1,at=seq(365,500,by=20),labels=seq(365,500,by=20)%%365)

# Create some colours
transp = 0.5
mycols = c(rgb(1,0,0,transp),rgb(0,0,1,transp),rgb(0,1,0,transp),rgb(1,1,0,transp))

# And finally add lines
for(k in 1:K) {
  polygon(c(plot_grid,rev(plot_grid)),c(p_lower[,k],rev(p_upper[,k])),col=mycols[k],border=NA)
  lines(plot_grid,p_median[,k],lwd=3,col=mycols[k])
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
legend('top',legend=as.matrix(sources[,1]),pch=19,col=mycols,horiz=T)

