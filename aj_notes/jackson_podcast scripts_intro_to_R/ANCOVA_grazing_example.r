# Date 25/01/2011
# Data Handling Course BD7054
# Linear Regression in R
# Template file on how to perform ANCOVA Linear Regression in R
#
# The data give the diameter of plants in mm and the 
# amount of seed each plant produced in g.
# We are interested in how seed production is affected
# by Grazing by herbivores, after taking account of
# differences in plant size, as indicated by root diameter.

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
plot(Root, Seed, type="p", 
	col=Grazing, 
	pch=as.numeric(Grazing))




# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever

# ANCOVA with fixed effects and linear covariate only
# i.e. No interaction term and hence assuming parallel lines

model1 <- glm( Seed ~ Root + Grazing )

summary(model1)


# ANCOVA with interaction term and hence testing for differences
# between the slopes of the lines

model2 <- glm( Seed ~ Root * Grazing )

summary(model2)



# --------------------------------------------------------------------
# Plot the results of your analysis

# In this example, the model with no interactions is superior
# so we will continue with that example. 

# abline(b0,b1) adds the best fit line for intercept b0 and 
# slope b1.
# First add the line for the Grazed group
abline(-127.829, 23.560, col="black", lty=1)

# Now add the line for the Ungrazed group
abline(-127.829+36.103, 23.560, col="red", lty=2)


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





