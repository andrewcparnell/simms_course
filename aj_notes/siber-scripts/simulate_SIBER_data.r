# This file generates some simulated data appropriate
# for analysing in using either the ellipse or layman
# metrics approaches.

set.seed(101)

# generate some fake data
ng <- 4 # number of groups

meanC <- runif(ng,-10,20)
meanN <- runif(ng,-5,15)

std <- 1

nsamps <- 8

ndata <- nsamps * ng

# prep some vectors for data
grps <- numeric(ndata)
dC <- grps
dN <- grps

ct <- 0
for (i in 1:ng){
  
  for (j in 1:nsamps){
    ct <- ct + 1
    grps[ct] <- i
    dC[ct] <- rnorm(1,meanC[i],std)
    dN[ct] <- rnorm(1,meanN[i],std)
  }
}

# plot the data
plot(dC,dN,type="p",pch=grps,col=grps)

out <- data.frame(group = grps, x = dC, y = dN,
                  stringsAsFactors = F)

write.csv(out, file = "tmp_siber_data.csv", row.names = F)

