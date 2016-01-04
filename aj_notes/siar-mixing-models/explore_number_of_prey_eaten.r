graphics.off()
rm(list=ls())

library(gplots)


S.mu <- 0
S.sd <- 1

f <- 3.5

reps <- 1000

n.range <- 30

results <- matrix(0,ncol=n.range,nrow=reps)

for (j in 1:n.range){

  for (i in 1:reps){
    
    results[i,j] <- S.mu + mean(rnorm(j,0,S.sd)) + f
    
    
  }
  
}

dev.new()

res.mu <- apply(results,2,mean)
res.sd <- apply (results,2,sd) 

plotCI(1:n.range,res.mu,res.sd,
        ylab="d15N of consumer", xlab = "n prey consumed")

lines(1:n.range,S.mu+f+S.sd/sqrt(1:n.range),col="red")
lines(1:n.range,S.mu+f-S.sd/sqrt(1:n.range),col="red")

