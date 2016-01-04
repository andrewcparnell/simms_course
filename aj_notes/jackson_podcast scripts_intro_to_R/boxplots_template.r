# 28/08/2012
# Example script for creating simple boxplots of data


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

# we will focus on the Petal Length data for a start
# Lets start with 3 histograms
dev.new()
par(mfrow=c(3,1)) # specify a 3x1 panel plot
hist(Petal.Length[Species=="setosa"], breaks=seq(0,7,0.25), freq=F,
      main="setosa", xlab="", ylab="", cex.lab=1.5)
hist(Petal.Length[Species=="versicolor"], breaks=seq(0,7,0.25),  freq=F,
      main="versicolor", xlab="", ylab="Frequency", cex.lab=1.5)
hist(Petal.Length[Species=="virginica"], breaks=seq(0,7,0.25),  freq=F,
      main="virginica", xlab="Petal Length (cm)", ylab="", cex.lab=1.5)


# use a boxplot to show this same information in one single panel
# See the wikipedia site for more information
# http://en.wikipedia.org/wiki/Box_plot
dev.new()
par(mfrow=c(1,1))
boxplot( Petal.Length ~ Species,
		ylab="Petal Length (cm)", xlab="Species")




# Some code below to facilirate direct comparison of histograms and boxplots
# Intended for illustrative purposes in this podcast only
dev.new()
par(mfrow=c(3,1)) # specify a 3x1 panel plot

hist(Petal.Length[Species=="setosa"], breaks=seq(0,7,0.25), freq=F,
      main="setosa", xlab="", ylab="", cex.lab=1.5,ylim=c(0,4),
      col="lightgrey")
boxplot(Petal.Length[Species=="setosa"],at=3.5,horizontal=T,add=T,width=2)

hist(Petal.Length[Species=="versicolor"], breaks=seq(0,7,0.25),  freq=F,
      main="versicolor", xlab="", ylab="Frequency", cex.lab=1.5, ylim=c(0,2),
      col="lightgrey")
boxplot(Petal.Length[Species=="versicolor"],at=1.5,horizontal=T,add=T)

hist(Petal.Length[Species=="virginica"], breaks=seq(0,7,0.25),  freq=F,
      main="virginica", xlab="Petal Length (cm)", ylab="", cex.lab=1.5, 
      ylim=c(0,2), col="lightgrey")
boxplot(Petal.Length[Species=="virginica"],at=1.5,horizontal=T,add=T)



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





