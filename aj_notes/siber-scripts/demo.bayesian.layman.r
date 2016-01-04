# this demo generates some random data for M consumers based on N samples and
# caculates the Bayesian estimated layman metrics

rm(list = ls())
graphics.off()

library(siar)

# ------------------------------------------------------------------------------
# ANDREW - REMOVE THESE LINES WHICH SHOULD BE REDUNDANT
# change this line
#setwd("c:/rtemp")
# ------------------------------------------------------------------------------



# read in some data
mydata <- read.csv("example_layman_data_2.csv", header=T)

# Attach the data
attach(mydata)

# calculate the Bayesian Layman metrics given data for Isotopes 1 and 2, 
# a grouping variable group and a number of iterations to use to generate
# the results
metrics <- siber.hull.metrics(mydata$x, mydata$y, mydata$group, R=10^4)




# ------------------------------------------------------------------------------
# Plot out some of the data and results
# ------------------------------------------------------------------------------

# Plot the raw [simulated in this case] data

# these are the names of each of the metrics taken from the fitted model
xlabels <- attributes(metrics)$dimnames[[2]]

# Now lets calculate the convex hull as per the current method based
# simply on the means for each group
means.x <- aggregate(mydata$x,list(mydata$group),mean)$x
means.y <- aggregate(mydata$y,list(mydata$group),mean)$x
sample.hull <- convexhull(means.x,means.y)

# get the 6 layman metrics based on the means of each group, i.e. the Maximum
# Likelihood estimates
ML.layman <- laymanmetrics(means.x, means.y)

# knowing how many groups we have is useful for constraining the plot 
M <- max(mydata$group)

#dev.new()
par(mfrow=c(1,1))
plot(x, y,
     col = mydata$group,
     xlab = "Isotope 1",
     ylab = "Isotope 2",
     pch = 1, asp=1, 
     xlim = c( min(x)-2, max(x)+2), 
     ylim = c( min(y)-2, max(y)+2)
     )

lines(sample.hull$xcoords, sample.hull$ycoords, lty = 1, col = 1, lwd = 2)

legend("topleft",
  legend = as.character(c(paste("group ",1:M),"sample hull")),
  pch = c(rep(1,M),NA), col = c(1:M,1,1), lty = c(rep(NA,M),1),
  bty = "n")

# in this example, I plot TA as a histogram seperately to the other
# metrics as it is usually on a scale so vastly different from the other 
# metrics.
#dev.new()
par(mfrow = c(1,2))

hist(metrics[,"TA"], freq = F, xlab = "TA", ylab = "Density", main="")

# add a vertical line indicating the TA based on the sample means
# but you may not want this.
abline(v = ML.layman$hull$TA, col = "red", lwd = 2, lty = 2)

# -------------------------------------
siardensityplot(metrics[,c(1,2,4,5,6)],
                xticklabels = xlabels[c(1,2,4,5,6)],
                ylims = c(0,25),
                ylab = expression('\u2030'),
                xlab = "Metric")

# this is a bit hardcoded, but basically it converts the contents of 
# ML.layman metrics from a list into a vector, and then pulls out the
# appropriate entries corresponding to the right metrics... i just looked this
# up and counted in to find the correct entry numbers... hardly elegant.
# But you may not want this... its just reasssuring to see they match.
points(1:5, unlist(ML.layman)[c(1,2,19,20,21)], col = "red", pch = "x")


detach(mydata)
