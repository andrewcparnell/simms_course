# A script to run MixSIAR on the Wolves example
# The full versions are in the MixSIAR manual: https://github.com/brianstock/MixSIAR/blob/master/Manual/mixsiar_manual.pdf
# and the MixSIAR vignettes: https://cran.r-project.org/web/packages/MixSIAR/vignettes/

library(MixSIAR)
library(tidyr) # For pivoting later in new output_jags
library(ggplot2)

# My new output function
source("output_jags_new.R")

# Find the data
mix.filename = system.file("extdata", "wolves_consumer.csv", package = "MixSIAR")
#system(paste('open',mix.filename))

# Load into MixSIAR
mix = load_mix_data(filename=mix.filename, 
                    iso_names=c("d13C","d15N"), 
                    factors=c("Region","Pack"), 
                    fac_random=c(TRUE,TRUE), 
                    fac_nested=c(FALSE,TRUE), 
                    cont_effects=NULL)

# Have a look at the mixture data
# mix.data = read.csv(mix.filename)
# str(mix.data)

# Replace the system.file call with the path to your file
source.filename = system.file("extdata", "wolves_sources.csv", package = "MixSIAR")

# Load the source data
source = load_source_data(filename=source.filename,
                          source_factors="Region", 
                          conc_dep=FALSE, 
                          data_type="means", 
                          mix)

# Replace the system.file call with the path to your file
discr.filename = system.file("extdata", "wolves_discrimination.csv", package = "MixSIAR")

# Load the discrimination/TDF data
discr = load_discr_data(filename=discr.filename, mix)

# Isospace plot 
plot_data(filename="isospace_plot", 
          plot_save_pdf = FALSE, 
          plot_save_png = FALSE,
          mix = mix, 
          source = source, 
          discr = discr)

# Alternative plot saving it and editing it
p <- plot_data(filename="isospace_plot", 
          plot_save_pdf = FALSE, 
          plot_save_png = FALSE,
          mix = mix, 
          source = source, 
          discr = discr, return_obj = TRUE)

# Can now do e.g.
p + theme(legend.position = "None")

# Plot the prior
#plot_prior(alpha.prior=1,source)

# Write the model out
model_filename = "MixSIAR_model.txt"   # Name of the JAGS model file
write_JAGS_model(model_filename, 
                 resid_err = TRUE, 
                 process_err = TRUE, 
                 mix, source)

# Test run
jags.1 = run_model(run="test", 
                   mix, source, discr, 
                   model_filename, 
                   alpha.prior = c(1,1,1), 
                   resid_err = TRUE, 
                   process_err = TRUE)

# Long run - change run to 'normal' if you have 5 hours to kill
jags.2 = run_model(run="very short", 
                   mix, source, discr, 
                   model_filename, 
                   alpha.prior = 1, 
                   resid_err = TRUE, 
                   process_err = TRUE)

# Get the output
# output_JAGS(jags.1, mix = mix, source = source,
#             output_options = 
#               list(summary_save = TRUE, 
#                    summary_name = "summary_statistics",
#                    sup_post = FALSE, 
#                    plot_post_save_pdf = FALSE, 
#                    plot_post_name = "posterior_density",
#                    sup_pairs = FALSE, 
#                    plot_pairs_save_pdf = FALSE, 
#                    plot_pairs_name = "pairs_plot", 
#                    sup_xy = FALSE, 
#                    plot_xy_save_pdf = FALSE, 
#                    plot_xy_name = "xy_plot", 
#                    gelman = FALSE, 
#                    heidel =FALSE, 
#                    geweke = FALSE, 
#                    diag_save = FALSE, 
#                    diag_name = "diagnostics", 
#                    indiv_effect = FALSE, 
#                    plot_post_save_png = FALSE, 
#                    plot_pairs_save_png = FALSE, 
#                    plot_xy_save_png = FALSE, 
#                    diag_save_ggmcmc = FALSE))

out <- output_JAGS(jags.1, mix = mix, source = source,
            c('summary_diagnostics',
              'summary_statistics',
              'summary_quantiles',
              'plot_global',
              'plot_factors'))


