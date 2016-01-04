# Date 01/12/2011
# Binary logistic regression in R
# Template file based on Linear Regression in R
#
# The response variable here is binary and could represent:
# 0/1 , Absent/Present , Uninfected/Infected etc...
# The single explanatory variable here is a linear covariate
# but any combination of fixed, linear or random factors
# are allowed under the glm framework.
# The key alteration here is the use of family="binomial" 
# to account for the binary data.

# -------------------------------------------------------------------
# Housekeeping

rm(list=ls()) # remove everything currently held in the R memory

graphics.off() # close all open graphics windows 


# -------------------------------------------------------------------
# Enter or read in your data from a file

# read in data from our CSV file
# This is a comma separated file

mydata <- read.csv("binary_example_data.csv", header=TRUE, sep=",")

# make the data directly accessible by the column headers
attach(mydata)


# --------------------------------------------------------------------
# Plot and explore your data

head(mydata)


# open up a new figure for plotting the raw data
dev.new()
par(mfrow=c(1,2)) # a 1x2 panel plot

plot(X1,Y,type="p",bty="L", yaxp=c(0,1,1),las=1) # a scatter plot

boxplot(X1~Y,horizontal=T,ylab="Y",xlab="X1",
        main="Take care with axes",bty="L",las=1) # a boxplot


# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever
# 
# NB in this case we specify the family of the GLM to have
# binomial errors (i.e. not the default normal or gaussian errors) for the 
# residuals of the data to the predicted model. Specifically in this case, 
# we are modelling a binomial distribution
# (http://en.wikipedia.org/wiki/Binomial_distribution)
# with one single observation per
# data point (i.e. one coin toss for which record either heads/tails,
# presence/absence, infected/uninfected etc...). This situation is actually a
# special case of the binomial distribution called the bernouli distribution
# http://en.wikipedia.org/wiki/Bernoulli_distribution
model1 <- glm(Y~X1,family=binomial)

summary(model1)


# --------------------------------------------------------------------
# Plot the results of your analysis

# Remember that we have fitted a linear model, and as we have only first-order
# polynomials in X fitted, can expect a straight line on the graph. However,
# you have to remember that this is linear on the log(odds) scale.

# ------------------------------------------------------------------------------
# ** START OF THE 2X2 PANEL PLOTTING **
# ------------------------------------------------------------------------------

dev.new()
par(mfrow=c(2,2))  # a 2x2 panel plot

# first plot the fitted model on the log(odds) scale on which it operated,
# and on which scale it returns its estimates

plot(0,0,type="n",xlim=c(min(X1),max(X1)),ylim=c(-4,4),
      ylab="log(odds)",xlab="X1",main="log(odds) predictions",bty="L")
abline(model1,col="red",lwd=2)

# this is not hugely informative for our data though as we cant add
# the raw data to this plot, since we can calculate log(odds) for stricly 
# binary data as we get 1/(1-1) = 1/0 which is Infinity, and we cant take 
# log(0) which is -Infinity. So, instead we need to plot our data on their
# 0/1 scale and add the model as a probability of Y taking 0 or 1. In order to 
# do this, we need to predict our model for a range of X values. There are two
# ways to acheive this.

# *****************************************************
# PREDICTION METHOD 1 - evaluate the function
# create a new  vector of X values at small increments
X.predict <- seq(0,100,0.01)

b0 <- coef(model1)[1]  # extract the intercept of the model
b1 <- coef(model1)[2]   # extract the slope

Y.predict.1 <- 1 / ( 1 + exp( -( b0 + b1*X.predict ) ) )

plot(X1,Y,type="p",main="prediction method 1",bty="L",las=1) # now plot the raw data
lines(X.predict,Y.predict.1,col="red",lwd=2)

# *****************************************************
# PREDICTION METHOD 2 - use the predict function

# this time we need to create a new dataset which we will ask the model
# to predict values of Y from using its internal information.
data.predict <- data.frame(X1=X.predict)

# use the predict function
Y.predict.2 <- predict(model1, newdata=data.predict, type="response")

plot(X1,Y,type="p",main="prediction method 2",bty="L",las=1) # now plot the raw data
lines(X.predict,Y.predict.2,col="blue",lwd=2)

# *****************************************************
# now the only thing remaining is to make sure the residuals of this
# model are normally distributed. NB there are more than one kind of residual.
# For all GLMS, the predcition is that the "deviance residuals" are normally
# distributed.

qqnorm(resid(model1,type="deviance"))
qqline(resid(model1,type="deviance"),col="red",lwd=2)


# ------------------------------------------------------------------------------
# ** END OF THE 2X2 PANEL PLOTTING **
# ------------------------------------------------------------------------------


# A histogram of the data if you want
dev.new()
hist(resid(model1,type="deviance"),freq=F)

# you can superimpose the model over the horizontal boxplots if you 
# prefer that style.
dev.new()
boxplot(X1~Y,horizontal=T,ylab="Y",xlab="X1",
          main="superimpose over boxes", frame.plot=T, las=1)

# note the +1 to the Y variable as the model line is between 0 and 1
# whereas the categories that boxplot produces are 
# automatically assigned 1 and 2
lines(X.predict,Y.predict.2+1,col="blue",lwd=2)

# 
# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="grazing_data.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(mydata)





