output_JAGS <- function (jags.1, 
                         mix, 
                         source, 
                         output_options = c('summary_diagnostics',
                                            'summary_statistics',
                                            'summary_quantiles',
                                            'plot_global',
                                            'plot_factors'))
{
  output_options = match.arg(output_options, several.ok = TRUE)
  
  # Extract the MCMC output
  mcmc_out_matrix <- jags.1$BUGSoutput$sims.matrix
  mcmc_out_list <- jags.1$BUGSoutput$sims.list
  source_names <- source$source_names
  
  # Create a holder for the output
  out <- vector('list', length = length(output_options))
  names(out) <- output_options
  
  if('summary_diagnostics' %in% output_options) {
    out$summary_diagnostics <- jags.1$BUGSoutput$summary[, "Rhat"]
    cat("Worst 10 R-hat values - these values should all be close to 1.\n")
    cat("If not, try a longer run of MixSIAR.\n")
    o <- order(out$summary_diagnostics, decreasing = TRUE)[1:10]
    print(round(out$summary_diagnostics[o], 2))
  }
  if('summary_statistics' %in% output_options) {
    out$summary_statistics <- t(apply(mcmc_out_matrix, 2, function(x) {
      return(c(mean = mean(x), sd = stats::sd(x)))
    }))
    print(out$summary_statistics)
  }
  if('summary_quantiles' %in% output_options) {
    out$summary_quantiles <- t(apply(mcmc_out_matrix, 2, "quantile", 
                                  probs = c(0.025, 0.25, 0.5, 0.75, 0.975)))
    print(out$summary_quantiles)
  }
  if('plot_global' %in% output_options) {
    post_global <- mcmc_out_list$p.global
    colnames(post_global) <- source_names
    out$plot_global <- post_global |> 
        as.data.frame() |> 
        pivot_longer(names_to = "Source",
                     values_to = "Proportion",
                     cols = everything()) |> 
        ggplot(aes(x = Proportion, fill = Source)) + 
        geom_histogram(aes(y = after_stat(density)), bins = 30) + 
        facet_wrap(~ Source) + 
      theme(legend.position = "None")
    print(out$plot_global)
  }
  if('plot_factors' %in% output_options) {
    n_factors <- mix$n.effects
    if(n_factors == 0) stop("No factor variables in this MixSIAR model. 
                            Re-run with 'plot_factors' removed from output_options")
    out$plot_factors <- vector('list', length = n_factors)
    fac_locations <- grep("p.fac", names(mcmc_out_list))
    for(i in 1:n_factors) {
      post_curr_factor <- mcmc_out_list[[fac_locations[i]]]
      factor_name <- mix$FAC[[i]]$name
      factor_levels <- mix$FAC[[i]]$labels
      dimnames(post_curr_factor) <- list(paste0("Iteration",
                                                1:jags.1$BUGSoutput$n.sims), 
                                         factor_levels,
                                         source_names)
      curr_df <- as.data.frame(ftable(post_curr_factor))
      names(curr_df) <- c("Iteration", "Factor", "Source", "Proportion")
      out$plot_factors[[i]] <- ggplot(curr_df, aes(x = Proportion, fill = Source)) + 
        geom_histogram(aes(y = after_stat(density)), bins = 30) + 
        facet_grid(Factor ~ Source) + 
        theme(legend.position = "None")
      print(out$plot_factors[[i]])
    }
  }
  
  invisible(out)
}