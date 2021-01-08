# Some example code to run the individual effects version of simmr and interpret output

library(simmr)

# Load in the new MCMC function to produce individual effects
source("https://raw.githubusercontent.com/andrewcparnell/simms_course/master/extra_code/simmr_mcmc_indeff.R")

# A very basic data set taken from the vignette
mix = matrix(c(-10.13, -10.72, -11.39, -11.18, -10.81, -10.7, -10.54, 
               -10.48, -9.93, -9.37, 11.59, 11.01, 10.59, 10.97, 11.52, 11.89, 
               11.73, 10.89, 11.05, 12.3), ncol=2, nrow=10)
colnames(mix) = c('d13C','d15N')
s_names = c("Zostera", "Grass", "U.lactuca", "Enteromorpha")
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96), ncol=2, nrow=4)
s_sds = matrix(c(0.48, 0.38, 0.48, 0.43, 0.46, 0.39, 0.42, 0.48), ncol=2, nrow=4)
c_means = matrix(c(2.63, 1.59, 3.41, 3.04, 3.28, 2.34, 2.14, 2.36), ncol=2, nrow=4)
c_sds = matrix(c(0.41, 0.44, 0.34, 0.46, 0.46, 0.48, 0.46, 0.66), ncol=2, nrow=4)
conc = matrix(c(0.02, 0.1, 0.12, 0.04, 0.02, 0.1, 0.09, 0.05), ncol=2, nrow=4)

# Load into simmr
simmr_in = simmr_load(mixtures=mix,
                      source_names=s_names,
                      source_means=s_means,
                      source_sds=s_sds,
                      correction_means=c_means,
                      correction_sds=c_sds,
                      concentration_means = conc)

# Run the individual effects version
simmr_out = simmr_mcmc_indeff(simmr_in)

# Summarise the output 
summary(simmr_out$outpu[[1]]) # Get means and quantiles

# Traceplots and density plots of values
plot(simmr_out$output[[1]])

# If you want the full posterior run
post = do.call(rbind, simmr_out$output[[1]])

# Now if you want e.g. the mean for each parameter
colMeans(post)

