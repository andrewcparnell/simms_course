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

# we will focus on the Petal Length data for a start
dev.new()
mu <- tapply(Petal.Length,Species,mean)

centres<-barplot(mu, names.arg=names(mu),ylim=c(0,7),
                  las=1,xlab="Species",ylab="Petal Length (cm)",
                  cex.lab=1.2,cex.axis=1.2)

# Now add the error bars on top.
#
# first create our own function to calculate standard error of a vector of
# numbers in a hypothetical vector named "x".
std.error <- function (x) {return(sqrt(var(x)/length(x)))}

# then apply this function across a tabulated data of petal lengths grouped by
# Species 
se <- tapply(Petal.Length,Species,std.error)

# and use the plotting function arrows() to draw arrows with flat heads on each 
# end which are essentially vertical lines with T-shaped tops and bottoms.. 
# i.e. errorbars.
arrows( x0= centres, x1=centres, y0=mu+se, y1=mu-se,
         code=3, length=0.3, angle=90,lwd=2)



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





