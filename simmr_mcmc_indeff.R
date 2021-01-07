simmr_mcmc_indeff = function(simmr_in, 
                                  prior_control=list(means=rep(0,simmr_in$n_sources),
                                                     sd=rep(1,simmr_in$n_sources)), 
                                  mcmc_control=list(iter=20000,
                                                    burn=2000,
                                                    thin=20,
                                                    n.chain=4),
                                  individual_effects = TRUE) {
  
  # Main function to run simmr through JAGS
  # if(class(simmr_in)!='simmr_input') stop("Input argument simmr_in must have come from simmr_load")
  
  # Throw warning if n.chain =1
  if(mcmc_control$n.chain==1) warning("Running only 1 MCMC chain will cause an error in the convergence diagnostics")
  
  # Throw a warning if less than 4 observations in a group - 1 is ok as it wil do a solo run
  if(min(table(simmr_in$group))>1 & min(table(simmr_in$group))<4) warning("At least 1 group has less than 4 observations - either put each observation in an individual group or use informative prior information")
  
  # Set up the model string
#   model_string = '
# model {
#   # Likelihood
#   for (j in 1:J) {
#     for (i in 1:N) {
#       y[i,j] ~ dnorm(inprod(p*q[,j], s_mean[,j]+c_mean[,j]) / inprod(p,q[,j]), 1/var_y[j])
#     }
#     var_y[j] <- inprod(pow(p*q[,j],2),pow(s_sd[,j],2)+pow(c_sd[,j],2))/pow(inprod(p,q[,j]),2)
# + pow(sigma[j],2)
#   }
# 
#   # Prior on sigma
#   for(j in 1:J) { sigma[j] ~ dunif(0,sig_upp) }
# 
#   # CLR prior on p
#   p[1:K] <- expf/sum(expf)
#   for(k in 1:K) {
#     expf[k] <- exp(f[k])
#     f[k] ~ dnorm(mu_f[k],1/pow(sigma_f[k],2))
#   }
# }
# '
model_string = '
model {
# Likelihood
for (j in 1:J) {
  for (i in 1:N) {
    y[i,j] ~ dnorm(inprod(p_ind[i,]*q[,j], s_mean[,j]+c_mean[,j]) / inprod(p_ind[i,],q[,j]), 1/var_y[i,j])
    var_y[i,j] <- inprod(pow(p_ind[i,]*q[,j],2),pow(s_sd[,j],2)+pow(c_sd[,j],2))/pow(inprod(p_ind[i,],q[,j]),2) + pow(sigma[j],2)

  }
}

# Prior on sigma
for(j in 1:J) { sigma[j] ~ dunif(0,sig_upp) }

# CLR prior on p
for(i in 1:N) {
  p_ind[i, 1:K] <- expf[i, 1:K]/sum(expf[i, 1:K])
  for(k in 1:K) {
    expf[i, k] <- exp(f[i, k])
    f[i, k] ~ dnorm(mu_f[k],1/pow(sigma_f[k],2))
  }
}

p[1:K] <- exp_f_mean[1:K]/sum(exp_f_mean[1:K])
for(k in 1:K) {
  exp_f_mean[k] <- exp(mu_f[k])
  mu_f[k] ~ dnorm(mu_f_mean[k], sigma_f_sd[k]^-2)
  sigma_f[k] ~ dt(0, sigma_f_sd[k]^-2, 1)T(0,)
}

}
'


output = output_2 = vector('list',length=simmr_in$n_groups)

# Loop through all the groups
for(i in 1:simmr_in$n_groups) {
  if(simmr_in$n_groups>1) cat(paste("\nRunning for group",i,'\n\n'))
  
  curr_rows = which(simmr_in$group_int==i)  
  curr_mix = simmr_in$mixtures[curr_rows,,drop=FALSE]
  
  # Determine if a single observation or not
  if(nrow(curr_mix)==1) {
    cat('Only 1 mixture value, performing a simmr solo run...\n')
    solo=TRUE
  } else {
    solo=FALSE
  }
  
  # Create data object
  data = with(simmr_in,list(
    y=curr_mix,
    s_mean=source_means,
    s_sd=source_sds,
    N=nrow(curr_mix),
    J=n_tracers,
    c_mean=correction_means,
    c_sd = correction_sds,
    q=concentration_means,
    K=n_sources,
    mu_f_mean=prior_control$means,
    sigma_f_sd=prior_control$sd,
    sig_upp=ifelse(solo,0.001,1000)))
  
  # Run in JAGS
  model = rjags::jags.model(textConnection(model_string), 
                            data=data, 
                            n.chain=mcmc_control$n.chain, 
                            n.adapt=mcmc_control$burn)
  
  if(individual_effects) {
    vars_to_save = c("p", "sigma", "p_ind")
  } else {
    vars_to_save = c("p", "sigma")
  }
  output[[i]] = rjags::coda.samples(model=model, 
                                    variable.names=vars_to_save, 
                                    n.iter=mcmc_control$iter, 
                                    thin=mcmc_control$thin)
  if(individual_effects) {
    curr_col_names = colnames(output[[i]][[1]])
    curr_col_names[grep('p\\[', curr_col_names)] = simmr_in$source_names
    curr_col_names[grep('sigma', curr_col_names)] = paste0('sd_',colnames(simmr_in$mixtures))
    for (j in 1:length(simmr_in$source_names)) {
      curr_col_names = gsub(paste0(',',j,'\\]'), paste0(',',simmr_in$source_names[j],']'), curr_col_names)
    }
    output_2[[i]] = lapply(output[[i]],"colnames<-",
                           curr_col_names)
  } else {
    output_2[[i]] = lapply(output[[i]],"colnames<-",
                           c(simmr_in$source_names, 
                             paste0('sd_',colnames(simmr_in$mixtures))))
  }  
  class(output_2[[i]]) = c('mcmc.list')
}

output_all = vector('list')
output_all$input = simmr_in
output_all$output = output_2
if(individual_effects) {
  class(output_all) = c('simmr_output', 'simmr_output_individual')
} else {
  class(output_all) = 'simmr_output'
}

return(output_all)

}