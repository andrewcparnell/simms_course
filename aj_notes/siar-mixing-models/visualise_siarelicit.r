rm(list=ls())
graphics.off()

# ------------------------------------------------------------------------------
# need to load a library for drawing dirichlet numbers
library(siar)

# define your prior distribution here
# Im going to start with a simple 3 source example as per the demo on wikipedia
# http://en.wikipedia.org/wiki/Dirichlet_distribution
# values corresponding to the example in the top-right image
# http://en.wikipedia.org/wiki/File:Dirichlet_distributions.png
# are
# (6,2,2) ; (3,7,5) ; (6,2,6) ; (2,3,4)
# and (1,1,1) is the default prior of all solutions as likely as the other

alpha <- c(6,2,2)

# number of smpales to draw from the corresponding dirichlet
reps <- 10^4

# prep a matrix to collect the simulated values in for visualisation
# each row is an observation with each column corresponding to a source
# Summing over rows = 1
prior_p <- matrix(0,nrow=reps,ncol=length(alpha))

for (i in 1:reps){

prior_p[i,] <- rdirichlet(alpha)

}


# ------------------------------------------------------------------------------
# NOW SOME FUNCTIONS TO HELP WITH THE PLOTTING VIA PAIRS()
# SEE ?PAIRS FOR MORE INFORMATION
# ------------------------------------------------------------------------------
panel.hist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col="cyan", ...)
}

## put (absolute) correlations on the upper panels,
## with size proportional to the correlations.
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- abs(cor(x, y))
    txt <- format(c(r, 0.123456789), digits=digits)[1]
    txt <- paste(prefix, txt, sep="")
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt, cex = cex.cor * r)
}

panel.myplot <- function( x,y,                # a 2d density computed by kde2D
                          ncol=50,          # the number of colors to use
                          zlim=c(0,max(z)), # limits in z coordinates
                          nlevels=20,       # see option nlevels in contour
    		                  theta=30,         # see option theta in persp
    		                  phi=30)           # see option phi in persp
		      {
d <- kde2d(x,y,n=50)
z   <- d$z
nrz <- nrow(z)
ncz <- ncol(z)

couleurs  <- tail(topo.colors(trunc(1.4 * ncol)),ncol)
fcol      <- couleurs[trunc(z/zlim[2]*(ncol-1))+1]
dim(fcol) <- c(nrz,ncz)
fcol      <- fcol[-nrz,-ncz]


image(d,col=couleurs,add=T)
contour(d,add=T,nlevels=nlevels)
#points(hdr(x)$mode,hdr(y)$mode,pch="+",col="black")

}

panel.myplot.2 <- function( x,y,                # a 2d density computed by kde2D
                          ncol=50,          # the number of colors to use
                          zlim=c(0,max(z)), # limits in z coordinates
                          nlevels=20,       # see option nlevels in contour
    		                  theta=30,         # see option theta in persp
    		                  phi=30)           # see option phi in persp
		      {

d <- cbind(x,y)
bins <- bin2(d,nbin=c(20,20))
f <- ash2(bins,m=c(5,5))

couleurs  <- tail(topo.colors(trunc(1.4 * ncol)),ncol)

image(f$x,f$y,f$z,col=couleurs,add=T)
contour(f$x,f$y,f$z,add=TRUE,nlevels=nlevels)

#points(hdr(x)$mode,hdr(y)$mode,pch="+",col="black")

}

# ------------------------------------------------------------------------------
# plot the results to visualise the dirichlet distribution for the
# specified prior

# two slightly different calculations on the bivariate contours
# using different density esimtations

# i prefer this version as it seems less sensitive to sample size
dev.new()
pairs(prior_p,lower.panel=function(x,y) panel.myplot.2(x,y,nlevels=5),diag.panel=panel.hist,upper.panel=panel.smooth)

dev.new()
pairs(prior_p,lower.panel=function(x,y) panel.myplot(x,y,nlevels=5),diag.panel=panel.hist,upper.panel=panel.smooth)

