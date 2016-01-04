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

# read in data from our CSV file
# This is a comma separated file

mydata <- read.table("grazing.csv", header=TRUE, sep=",")

# make the data directly accessible by the column headers
attach(mydata)


# --------------------------------------------------------------------
# Plot and explore your data

head(mydata)


# open up a new figure for plotting
dev.new()
plot(Root,Seed,type="p")




# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever

model1 <- lm(Seed~Root)

summary(model1)


# --------------------------------------------------------------------
# Plot the results of your analysis

# abline() adds the best fit line
abline(model1,col="red")

# Extract the residuals for easy recall
rsd <- residuals(model1)

# Histogram of the residuals
dev.new()
hist(rsd,6)

# QQ plot of the residuals to assess how well the residuals
# compare with an ideal normal distribution

dev.new()
qqnorm(rsd)
qqline(rsd,col="red")

# Check for a trend in the residuals with the X axis variable
dev.new()
plot(Root,rsd)
abline(0,0,col="blue")

# 
# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="grazing_data.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(mydata)





