# Create some data for a spline type model

# Clear the workspace
rm(list=ls())

# Set the working directory
#setwd("~/GDrive/Conferences&Talks/SIAR_Glasgow_Jan16/ap_notes/mod_9_building_simms")
#setwd("/Volumes/MacintoshHD2/GDrive/Conferences&Talks/SIAR_Glasgow/mod_9_building_SIMMs")

# Set the seed
set.seed(123)

# Source in the basis functions
source('bases.r')

# Create some data
N = 100
t = 1:N

# Create basis functions
B = bbase(t)

# Simulate some parmeters
sd_beta = 0.2
beta = cumsum(rnorm(ncol(B),0,sd_beta))

# Noise sd
sigma = 0.1
  
# Data
y = rnorm(N,mean=B%*%beta,sigma)
# Re-scale so in the range 0,1
p = (y-min(y)+2)/(max(y)-min(y)+4)

# Plot it
par(mar=c(3,3,2,1), mgp=c(2,.7,0), tck=-.01,las=1)
#plot(t,p)
