# Example of estimating TDFs for a simple system with known dietary proportions

# Data set 1: 10 obs on 2 isos, 4 sources, with tefs and concdep
# Assume p = c(0.25, 0.25, 0.25, 0.25)

# Need the development version of simmr
# Run this first (but you only need it once)
# library(devtools)
# install_github('andrewcparnell/simmr')
library(simmr)

# The data
mix = matrix(c(-10.13, -10.72, -11.39, -11.18, -10.81, -10.7, -10.54,
-10.48, -9.93, -9.37, 11.59, 11.01, 10.59, 10.97, 11.52, 11.89,
11.73, 10.89, 11.05, 12.3), ncol=2, nrow=10)
colnames(mix) = c('d13C','d15N')
s_names=c('Source A','Source B','Source C','Source D')
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96), ncol=2, nrow=4)
s_sds = matrix(c(0.48, 0.38, 0.48, 0.43, 0.46, 0.39, 0.42, 0.48), ncol=2, nrow=4)
conc = matrix(c(0.02, 0.1, 0.12, 0.04, 0.02, 0.1, 0.09, 0.05), ncol=2, nrow=4)



# Load into simmr without any corrections
simmr_tdf = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     concentration_means = conc)

# Plot it - they should be slightly off centre as they're not corrected
plot(simmr_tdf)

# MCMC run - assumes they're know to have eaten equal proportions of sources
simmr_tdf_out = simmr_mcmc_tdf(simmr_tdf, 
                               p = rep(1/simmr_tdf$n_sources, simmr_tdf$n_sources))

# Summary
summary(simmr_tdf_out,type='diagnostics')
summary(simmr_tdf_out,type='quantiles')

# Now put these corrections back into the model and check the
# iso-space plots and dietary output
simmr_tdf_2 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means = simmr_tdf_out$c_mean_est,
                     correction_sds = simmr_tdf_out$c_sd_est,
                     concentration_means = conc)

# Plot with corrections now
plot(simmr_tdf_2)

# Now re-run
simmr_tdf_2_out = simmr_mcmc(simmr_tdf_2)

# Check convergence
summary(simmr_tdf_2_out, type = 'diagnostics')

# And see if it looks equal
plot(simmr_tdf_2_out, type = 'boxplot')
plot(simmr_tdf_2_out, type = 'matrix')

