# Create an iso-space plot for the geese data from siar

# Note: for simplicity this ignores concentration dependence and enrichment factors

library(siar)
data("geese1demo",'sourcesdemo')

# First create plot of sources based on means and 95% confidence intervals
conf_level = 1.96
d15N_low = sourcesdemo$Meand15N - conf_level*sourcesdemo$SDd15N
d15N_high = sourcesdemo$Meand15N + conf_level*sourcesdemo$SDd15N
d13C_low = sourcesdemo$Meand13C - conf_level*sourcesdemo$SDd13C
d13C_high = sourcesdemo$Meand13C + conf_level*sourcesdemo$SDd13C

# Find the range of values for the plotting limits
d13C_low_all = min(d13C_low)
d13C_high_all = max(d13C_high)
d15N_low_all = min(d15N_low)
d15N_high_all = max(d15N_high)

# Set up a basic plot
plot(1,1,type='n',xlab='d13C',ylab='d15N',xlim=c(d13C_low_all,d13C_high_all),ylim=c(d15N_low_all,d15N_high_all),las=1,bty='l')

# Loop through sources to create plusses
n_sources = nrow(sourcesdemo)
for(i in 1:n_sources) {
  # Create horizontal lines
  lines(c(d13C_low[i],d13C_high[i]),c(sourcesdemo$Meand15N[i],sourcesdemo$Meand15N[i]),col=i)
  # Create vertical lines
  lines(c(sourcesdemo$Meand13C[i],sourcesdemo$Meand13C[i]),c(d15N_low[i],d15N_high[i]),col=i)
  # Add the means
  points(sourcesdemo$Meand13C[i],sourcesdemo$Meand15N[i],col=i,pch=i,cex=2)
}


# Add the consumers as dots
points(geese1demo[,2],geese1demo[,1],pch=19)

# Alternativel add them as a plus
geese_means = apply(geese1demo,2,function(x) return(c(mean(x),sd(x))))

# Now create low and high values as above
geese15N_low = geese_means[1,1] - conf_level*geese_means[2,1]
geese15N_high = geese_means[1,1] + conf_level*geese_means[2,1]
geese13C_low = geese_means[1,2] - conf_level*geese_means[2,2]
geese13C_high = geese_means[1,2] + conf_level*geese_means[2,2]

# Now plot lines - horizontal
lines(c(geese13C_low,geese13C_high),c(geese_means[1,1],geese_means[1,1]),lwd=3)
# Create vertical lines
lines(c(geese_means[1,2],geese_means[1,2]),c(geese15N_low,geese15N_high),lwd=3)




