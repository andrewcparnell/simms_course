# Author: Andrew L Jackson
# Date 30/08/2012
# Data Handling Course BD7054
# How to calculate summary statistics of variables, which also includes
# a quick explanation of how to write your own functions in R.
#


# -------------------------------------------------------------------
# Housekeeping

rm(list=ls()) # remove everything currently held in the R memory

graphics.off() # close all open graphics windows 


# -------------------------------------------------------------------
# Enter or read in your data from a file

# read in data from our CSV file
# This is a comma separated file

# use the in-built "iris" data
attach(iris)

# --------------------------------------------------------------------
# Plot and explore your data

head(iris)

# generate some summary statistics on the Petal Lengths
mu <- mean(Petal.Length)    # mean
med <- median(Petal.Length)  # median
variance <- var(Petal.Length)     # variance
stan.dev <- sd(Petal.Length)      # standard deviation
n <- length(Petal.Length) # the number of observations
standard.error <- sd(Petal.Length) / sqrt(length(Petal.Length)) # SE of the mean
maximum <- max(Petal.Length, na.rm=T)
minimum <- min(Petal.Length, na.rm=T)

# But... we probably want to calculate these metrics for each of the 
# three species seperately. Use the function aggregate() to collect the data
# into subsets associated with each species, and apply a given function 
# to the subset.
# It probably helps if we have a quick graph of the data as a reference point
# for these summary statistics. A boxplot does this and i refer you to the
# associated podcast on boxplots for more information

dev.new()
boxplot(Petal.Length ~ Species)

mu.sepal.lengths <- aggregate(Petal.Length, by=list(Species), mean)

# we could repeat this for all the metrics, but instead, we can write
# our own function that calculates a series of useful summary statistics
# on the data.

# specify our own function
summary.stats <- function (x,...) {

# "out" will be a vector with names assigned to each entry.
out <- c( n.obs=length(x),
          min=min(x),
          quantile(x,c(0.25,0.5,0.75)),
          max=max(x),
          mean=mean(x),
          sd=sd(x),
          var=var(x),
          se=sd(x)/sqrt(length(x))
          )
          
return(out)  # this tells the function what to return as "the answer"
} # end of function

# now apply our summary.stats() function to the Petal Length data by Species
petal.length.summaries <- aggregate(Petal.Length,by=list(Species),summary.stats)

# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever



# --------------------------------------------------------------------

# 
# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="grazing_data.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(iris)





