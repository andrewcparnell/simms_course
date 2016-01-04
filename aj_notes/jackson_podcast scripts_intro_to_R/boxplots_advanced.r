# Advanced techniques for Boxplots
# 29/08/2012
# Author: Andrew Jackson, Trinity College Dublin.
#
# This example uses the R included data "iris"

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

# A basic default boxplot
dev.new()
par(mfrow=c(1,1))
boxplot( Petal.Length ~ Species,
		ylab="Petal Length (cm)", xlab="Species")




# some advanced tricks to customising plots.
# Remove the frame surrounding the boxplot by suppressing the axes and
# manually specifying them. NB this is straight forward for most plots, 
# but for some reason the boxplot function is encoded differently.
dev.new()
par(mfrow=c(1,1))
boxplot( Petal.Length ~ Species, axes=F )
box(bty="L")
axis(1,at=1:3,c("Iris setosa","Iris versicolor","Iris virginica"),
        font=3, cex.axis=1.2, tcl=0.5)
title(xlab="Species", cex.lab=1.4)
axis(2, at=0:7, las=1, tcl=0.5)
title(ylab="Petal Length (cm)",cex.lab=1.2)

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





