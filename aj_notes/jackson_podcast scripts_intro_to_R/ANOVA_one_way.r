# Date 26/11/2012
# Linear Regression in R
# Template file on how to perform one-way ANOVA in R
#
# The data represent femur lengths of an animal for varying genotypes.
# Specifically, two genes, at two independent loci are predicted to 
# affect femur length.

# -------------------------------------------------------------------
# Housekeeping

rm(list=ls()) # remove everything currently held in the R memory

graphics.off() # close all open graphics windows 


# -------------------------------------------------------------------
# Enter or read in your data from a file

# read in data from our CSV file
# This is a comma separated file

mydata <- read.csv("genedata.csv", header=TRUE)

# make the data directly accessible by the column headers
attach(mydata)


# --------------------------------------------------------------------
# Plot and explore your data

head(mydata)

# for these data, it might be worth in the first instance, creating a
# new grouping column that identifies the four categories:
# 1) both genes absent
# 2) only gene 1 present
# 3) only gene 2 present
# 4) both genes present
# NB -- later we will see how we could analyse this slightly differently
# using a two-way ANOVA by using the original coding structure

# first of all create a vector of length = number of observations
Group <- numeric(length(femur))

# now will it with character strings naming each group appropriately
Group[gene1=="absent" & gene2=="absent"] <- "Absent"
Group[gene1=="gene1" & gene2=="absent"] <- "Gene1only"
Group[gene1=="absent" & gene2=="gene2"] <- "Gene2only"
Group[gene1=="gene1" & gene2=="gene2"] <- "Both"

# now conver this vector of character strings to the factor format for data
# that is used in models to identify categorical data
Group <- as.factor(Group)

# append it to the mydata dataframe
mydata$Group <- Group

# and check it
print(mydata)


# open up a new figure for plotting
dev.new()
boxplot(femur~Group,ylab="Femur Length (cm)", xlab="Genotype")


# --------------------------------------------------------------------
# Analyse your data
# e.g. a t-test, or linear regression, or ANOVA, or whatever

anova.1 <- aov(femur~Group)

summary(anova.1)

# that anova tells us whether or not there is a significantly more variation
# among groups than within compared with what would be expected under the
# null hypothesis that there is no difference among groups.
# It DOES NOT tell us which groups are different from one another. In order
# to ask which if any groups are different, we can use one of a number of
# posthoc tests which account for the multiple testing issue that arises
# (http://en.wikipedia.org/wiki/Multiple_comparisons).
# The easiest one to run in R is Tukey's "Honest Significant Difference" test

test.all.comparisons <- TukeyHSD(anova.1)

print(test.all.comparisons)


# --------------------------------------------------------------------
# Plot the results of your analysis

# NB for anova's there is no other plot to include as there are
# no model predicted lines to add. Instead, the model predictions are
# the means of each category, and an estimate of the within group variance
# and among group variance. All of this information is already depicted in
# our boxplots, so there is no need to do anything further to the plot
# we already have (except of course to tidy it up for publication - 
# but you can follow my other podcasts on boxplots for those hints)


# --------------------------------------------------------------------
# Save your data (only if you want)

# The "list=" command tells us which variables we want to save
# The "file=" option tells us what file to save the data to

# save( list=ls(), file="femur_lengths.rdata" )

# -------------------------------------------------------------------
# Housekeeping - Cleaning up
detach(mydata)





