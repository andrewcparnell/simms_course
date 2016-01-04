# Date 13/10/2011
# Data Handling Course BD7054
# t-tests in R
# Template file on how to perform t-tests in R.
# This file is a direct follow-on from the podcast "Intro to 
# R lesson 3 - reading in data" and its associated script and data

# -------------------------------------------------------------------
# Housekeeping

rm(list=ls()) # remove everything currently held in the R memory

graphics.off() # close all open graphics windows 

# Here i set the working directory using the command line function setwd()
# Alternatively you do this manually from the dropdown menu option in the
# console window.
setwd("D:/Alternative My Documents/Andrews Documents/Website/new zoology theoretical/Rpodcastsfiles/t_tests") 


# -------------------------------------------------------------------
# Enter or read in your data from a file

# read in data from our CSV file
# This is a comma separated file

mydata <- read.table("finger_lengths.csv", header=TRUE, sep=",")

attach(mydata)



# --------------------------------------------------------------------
# Plot your data


# open up a new figure for plotting
dev.new()
boxplot(finger.length~hand, xlab="Hand", ylab="digit length(cm)")



# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever

# first lets do the default t-test in R
welch.test <- t.test(finger.length~hand)


welch.test.alternative <- t.test(finger.length[hand=="left"],finger.length[hand=="right"])

# Ruxton, G.D. (2006) The unequal variance t-test is an 
# underused alternative to Student's t-test and the 
# Mann–Whitney U test. Behavioral Ecology, 17, 688-690.
# http://dx.doi.org/10.1093/beheco/ark016



# now lets do the "classic" t-test
classic.test <- t.test(finger.length~hand, var.equal=T)


# and a paired t-test
paired.test <- t.test(finger.length~hand, paired=T)


# ... and a non-parametric Mann-Whitney U-test for completeness
# this is called the "Wilcoxon Rank Sum (for non-paired data) 
# and Signed Rank Tests (for paired data)" in R

mann.test <- wilcox.test(finger.length~hand, paired=F)

signed.rank.test <- wilcox.test(finger.length~hand, paired=T)

# --------------------------------------------------------------------
# Plot the results of your analysis



# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="finger_data.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(mydata)





