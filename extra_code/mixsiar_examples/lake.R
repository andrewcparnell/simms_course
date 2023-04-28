## ---- eval=FALSE--------------------------------------------------------------
#  library(MixSIAR)
#  mixsiar.dir <- find.package("MixSIAR")
#  paste0(mixsiar.dir,"/example_scripts")

## ---- eval=FALSE--------------------------------------------------------------
#  source(paste0(mixsiar.dir,"/example_scripts/mixsiar_script_lake.R"))

## -----------------------------------------------------------------------------
library(MixSIAR)
library(tidyr) # For pivoting later in new output_jags
library(ggplot2)
library(GGally)
library(dplyr)

# My new output function
source("extra_code/output_jags_new.R")

## -----------------------------------------------------------------------------
# Replace the system.file call with the path to your file
mix.filename <- system.file("extdata", "lake_consumer.csv", package = "MixSIAR")

mix <- load_mix_data(filename=mix.filename,
                     iso_names=c("d13C","d15N"),
                     factors=NULL,
                     fac_random=NULL,
                     fac_nested=NULL,
                     cont_effects=NULL)

## -----------------------------------------------------------------------------
# Replace the system.file call with the path to your file
source.filename <- system.file("extdata", "lake_sources.csv", package = "MixSIAR")

source <- load_source_data(filename=source.filename,
                           source_factors=NULL,
                           conc_dep=FALSE,
                           data_type="raw",
                           mix)

## -----------------------------------------------------------------------------
# Replace the system.file call with the path to your file
discr.filename <- system.file("extdata", "lake_discrimination.csv", package = "MixSIAR")

discr <- load_discr_data(filename=discr.filename, mix)

## ---- eval=FALSE--------------------------------------------------------------
#  # Make an isospace plot
#  plot_data(filename="isospace_plot", plot_save_pdf=TRUE, plot_save_png=FALSE, mix,source,discr)

## -----------------------------------------------------------------------------
# Calculate the convex hull area, standardized by source variance
calc_area(source=source,mix=mix,discr=discr)

## ---- eval=FALSE--------------------------------------------------------------
#  # default "UNINFORMATIVE" / GENERALIST prior (alpha = 1)
#  plot_prior(alpha.prior=1,source)

## ---- eval=FALSE--------------------------------------------------------------
#  # Write the JAGS model file
 model_filename <- "MixSIAR_model.txt"
 resid_err <- TRUE
 process_err <- FALSE
 write_JAGS_model(model_filename, resid_err, process_err, mix, source)

## ---- eval=FALSE--------------------------------------------------------------
 jags.1 <- run_model(run="test", mix, source, discr, model_filename)

## ---- eval=FALSE--------------------------------------------------------------
#  jags.1 <- run_model(run="normal", mix, source, discr, model_filename)

## ---- eval=FALSE--------------------------------------------------------------
#  output_JAGS(jags.1, mix, source, output_options)
output <- output_JAGS(jags.1, mix = mix, source = source,
            c('summary_diagnostics',
              'summary_statistics',
              'summary_quantiles',
              'plot_global_matrix',
              'plot_global',
              'plot_cont'),
            search_par = 'p.global')
 
# Change around if required
output$plot_cont + 
  facet_wrap(~Source) + 
  theme_bw() + 
  theme(legend.position = "None")

# Get the DIC (similar to AIC) find a model with the smallest DIC
jags.1$BUGSoutput$DIC
