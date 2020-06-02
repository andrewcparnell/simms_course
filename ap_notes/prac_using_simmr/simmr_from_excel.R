# A simmr example from an Excel data set

# Clear workspace
rstudioapi::restartSession()

# Load packages
library(simmr)
library(readxl) # Run install.packages('readxl') if you don't have this
library(httr) # Again run install.packages if you don't have this

# Load in the data

# Go to the files pane and find the file 'geese_data.xls'
# Then click (in the files pane) on More > Set as WD
# Copy the command from the console window into the line below
setwd("~/GitHub/simms_course/ap_notes/prac_using_simmr")

# Find out what the sheet names are and load in all of them
sheet_names = excel_sheets(path = 'geese_data.xls')
all = lapply(sheet_names,
             read_excel, path = 'geese_data.xls')

# Extract out the different pieces
mix = all[[1]]
source = all[[2]]
TDF = all[[3]]
Conc = all[[4]]

# Get the data into simmr
simmr_groups = simmr_load(mixtures=as.matrix(mix[,1:2]),
                          source_names=unlist(source[,1]),
                          source_means=source[,2:3],
                          source_sds=source[,4:5],
                          correction_means=TDF[,2:3],
                          correction_sds=TDF[,4:5],
                          concentration_means = Conc[,2:3],
                          group=paste('day', mix$Time))

# Plot the iso-space plot
plot(simmr_groups,
     group=1:8,
     xlab=expression(paste(delta^13, "C (\u2030)",sep="")), 
     ylab=expression(paste(delta^15, "N (\u2030)",sep="")), 
     title='Isospace plot of Inger et al Geese data',
     mix_name='Geese')

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


