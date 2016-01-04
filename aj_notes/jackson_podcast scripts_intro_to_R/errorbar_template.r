# Date 18/01/2011
# Data Handling Course BD7054
# Linear Regression in R
# Template file on how to perform Linear Regression in R
#
# The data give the diameter of plants in mm and the 
# amount of seed each plant produced in g.
# We are interested in how seed production is affected
# by plant size, as indicated by root diameter.

# -------------------------------------------------------------------
# Housekeeping

rm(list=ls()) # remove everything currently held in the R memory

graphics.off() # close all open graphics windows 


# -------------------------------------------------------------------
# Enter or read in your data from a file
# In this example we will use the in-built dataset "iris" which gives the 
# measurements in centimeters of the variables sepal length and width 
# and petal length and width, respectively, for 50 flowers from each 
# of 3 species of iris. The species are Iris setosa, versicolor, and virginica.
# see ?iris for more information

#setwd("D:/Alternative My Documents/Andrews Documents/Camtasia Studio/R podcasts/R podcasts scripts/graphics scripts")

# read in data from our CSV file                              
# This is a comma separated file

#brain.data <- read.csv("brain_data.csv", header=TRUE)

# make the data directly accessible by the column headers
attach(iris)


# --------------------------------------------------------------------
# Plot and explore your data


head(iris)

# *************************************
# use an errorbar plot to show the data
# NB not straight forward
dev.new()
par(mfrow=c(1,1))
# calculate the means of the groups using tapply()
mu <- tapply(Petal.Length,Species,mean)

# Here i write my own function to calculate the 95% confidence intervals, see
# http://en.wikipedia.org/wiki/Standard_error#Assumptions_and_usage
CI95 <- function (x) {return(1.96*sqrt(var(x)/length(x)))} 
se <- tapply(Petal.Length,Species,CI95)
plot(1:3,mu,xlim=c(0,4),ylim=c(1,7),pch=20, las=1, bty="L",
      xlab="Species", ylab="Petal Length (cm)")
arrows( x0=1:3, x1=1:3, y0=mu+se, y1=mu-se, code=3, length=0.1, angle=90)
# ************************************* 


# *************************************
# use an errorbar plot to show the data
# Fix the x-axis labels  and tidy up the plot
dev.new()
par(mfrow=c(1,1))
# calculate the means of the groups
mu <- tapply(Petal.Length,Species,mean)
CI95 <- function (x) {return(1.96*sd(x)/sqrt(length(x)))} 
se <- tapply(Petal.Length,Species,CI95)
plot(1:3,mu,xlim=c(0,4),ylim=c(1,7),pch=20, las=1, bty="L",
       xaxt="n",xlab="Species", ylab="Petal Length (cm)")
axis(1, at=1:3, levels(Species), ) 
arrows( x0=1:3, x1=1:3, y0=mu+se, y1=mu-se, code=3, length=0.1, angle=90)
# *************************************


# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever



# --------------------------------------------------------------------
# Plot the results of your analysis



# 
# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="grazing_data.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(iris)





