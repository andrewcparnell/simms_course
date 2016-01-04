# load the siar library
library(siar)

# remove any pre-existing and open graphics windows
graphics.off()

# ------------------------------------------------------------------------------
# After that bit of house-keeping. Read in the data files.
# ------------------------------------------------------------------------------

# here i am going to simulate a 4-source, 3-tracer system as a demonstration
sources <- data.frame(Means=c("S1","S2","S3","S4"),)

# ------------------------------------------------------------------------------
# Thats the data read in... now we can run the model and analyse the results
# ------------------------------------------------------------------------------

# this line calls the SIAR model for either multiple or single groups
# of consumers depending on the format of the consumers dataset
model1 <- siarmcmcdirichletv4(consumers, sources, corrections, concs)

# this line plots the raw isotope data for sources and consumers as a bi-plot.
# The trophic enrichment factors have been applied to the sources.
# You will be asked to position a legend on the screen by left clicking.
siarplotdata(model1,iso=c(2,1))

# This line plots the estimated proportional contribution of each source in the 
# consumer's diet.
# It will ask you which group you wish to plot the data for.
# There are 8 in this example)
# You will then be asked whether you want the histograms plotted all together
# on one graph, or a seperate graph for each source. Suggest you go for group 3.
siarhistograms(model1)

# This function plots the histogram data from the previous example as box-style
# plots showing the highest density regions of the estimated posterior
# distributions. This function plots estimates for a single source across
# all groups. In this example it plots the estimated contribution of grass
# (grp = 2) to the diet across all 8 groups of consumers.
siarproportionbysourceplot(model1,grp=1)

# This function plots the histogram data as box-style
# plots showing the highest density regions of the estimated posterior
# distributions. This function plots estimates for a single group of consumers 
# across all their sources.
# In this example it plots the estimated contribution of all 5 sources for 
# the consumer group = 1.
siarproportionbygroupplot(model1,grp=8)

# This gets the 95% credible intervals, modes and means of the estimates
# It returns values for all estimated parameters... ie. the proportion of each
# source in the diet for each group of consumers.
# In this example, ZosteraG1 is the proportion of Zostera aglae in the diet of 
# the consumer geese in the Group 1.
# SD1G1 is the residual error associated with Isotope 1 for consumers in Group 1.
# This value tells you how variable the consumers are within a group, after
# fitting the model.
siarhdrs(model1)

# This line creates some potentially very useful diagnostic plots. It will ask
# you which group you wish to run the analysis for. I suggest for this example
# you select group 3 and compare with the histogram and boxplots for this same
# group that we generated above.
# These matrix plots show how the estimated dietary proportions are correlated
# with each other.
# The diagonal shows the histograms for each possible source. For group 3, 
# the model is sure that the consumers are eating about 50% grass, and very
# little Zostera. However, it appears to be considerably less certain about how
# much U.lactuca or Enteromorpha is in the diet. The high negative correlation
# between  U.lactuca and Enteromorpha backs this assertion up... the model can
# be solved with either U.lactuca or Enteromorpha and as it
# increases the contribution of one of them it reduces the contribution of
# the other. The upper triangle of the matrix diplays the correlation graphically
# while the lower triangle gives the correlation coefficient with larger values
# getting larger text size.
siarmatrixplot(model1)

# If you want to access the raw data output from the model you can get it...
# This line just returns the first 10 rows (and all the columns)
# of the data because its very large. The histograms and density plots 
# generated above are simply histograms of each column in this file which
# represents the posterior density draws.
model1$output[1:10,]


# Comparing the diets of the consumers in groups 4, 5 and 6
# In this example i want to copmare the proportion of zostera in the diet
# across these 3 groups. These data are held in 
# model1$output[,19]
# model1$output[,25]
# model1$output[,31]
# These data are depicted in the figure titled "Proportions by source: Zostera"
# To compare group 4 with group 5 i use the following code to deterimine which
# samples in the MCMC process were bigger in group 4 than group 5
test45 <-  model1$output[,19] >  model1$output[,25]
# the probability that the proportion of zostera in the diet of consumer group
# 4 is bigger than that in group 5 is then approximated by the proportion of 
# samples that were bigger in group 4 than group 5 given by:
P45 <- sum(test45)/length(test45)

# We can now do the exact same for groups 4 and 6
test46 <-  model1$output[,19] >  model1$output[,31]
P46 <- sum(test46)/length(test46)

# ... or 5 & 6
test56 <-  model1$output[,25] >  model1$output[,31]
P56 <- sum(test56)/length(test56)

# ... or 7 & 8 - which look very similar on the graph
test78 <-  model1$output[,37] >  model1$output[,43]
P78 <- sum(test78)/length(test78)


# save your model to a file name of your choice
save(model1,file="your_choice.rdata")

# For more details on the Bayesian method i suggest reading
# McCarthy, M.A. 2007. Bayesian methods for Ecology. Cambridge University Press.


