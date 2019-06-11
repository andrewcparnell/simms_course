# A simmr example from an Excel data set

# Clear workspace
rstudioapi::restartSession()

# Load packages
library(simmr)
library(readxl) # Run install.packages('readxl') if you don't have this
library(httr) # Again run install.packages if you don't have this

# Load in the data
file_path = 'ap_notes/prac_using_simmr/geese_data.xls'
mix = read_excel(file_path, sheet = 'Targets')
source = read_excel(file_path, sheet = 'Sources')
TDF = read_excel(file_path, sheet = 'TEFs')
Conc = read_excel(file_path, sheet = 'ConcDep')

# Get the data into simmr
simmr_groups = simmr_load(mixtures=as.matrix(mix[,c(2:1)]),
                          source_names=unlist(source[,1]),
                          source_means=source[,3:2],
                          source_sds=source[,5:4],
                          correction_means=TDF[,3:2],
                          correction_sds=TDF[,5:4],
                          concentration_means = Conc[,3:2],
                          group=as.integer(as.factor(mix$Time)))

# Plot the iso-space plot
plot(simmr_groups,group=1:8,xlab=expression(paste(delta^13, "C (\u2030)",sep="")), 
     ylab=expression(paste(delta^15, "N (\u2030)",sep="")), 
     title='Isospace plot of Inger et al Geese data',mix_name='Geese')

# RUN THE MODEL
simmr_groups_out = simmr_mcmc(simmr_groups)

# Check convergence
summary(simmr_groups_out, type = 'diagnostics', group = 1:8) 
# Some of these are not good - longer run?

# Example plots
plot(simmr_groups_out,
     type = 'boxplot',
     group = 2,
     title = 'simmr output group 2')
plot(simmr_groups_out,
     type = c('density', 'matrix'),
     group = 6,
     title = 'simmr output group 6')


