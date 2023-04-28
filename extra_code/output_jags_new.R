#' Create output plots and tables from a MixSIAR run
#'
#' @param jags.1 A run of the Bayesian MixSIAR model from [MixSIAR::run_model()]]
#' @param mix The mixture object created from [MixSIAR::load_mix_data()]]
#' @param source The source object created from [MixSIAR::load_source_data()]]
#' @param output_options A text string made up of any combination of 'summary_diagnostics', 'summary_statistics', 'summary_quantiles', 'plot_global', 'plot_global_matrix', 'plot_factors', and 'plot_cont'. See Return below for more details
#' @param search_par A text string that is used to search for certain parameters in the posterior. Only used for the `output_options` containing 'summary_'
#'
#' @return Depending on `output_options`:
#' - 'summary_diagnostics' returns R-hat values for testing convergence
#' - 'summary_statistics' returns means and standard deviations for all of the parameters
#' - 'summary_quantiles' returns the 2.5th, 25th, 50th, 75th, and 97.5th percentile for all parameters
#' - 'plot_global' returns a plot of all the global parameter posterior values
#' - 'plot_global_matrix' returns a matrix plot of all the global parameter posterior values
#' - 'plot_factors' returns a grid-based plot of the parameter posterior values with the sources in the columns and the factor variables in the rows. It will return an error if there are no factor variables in the model run.
#' - 'plot_cont' returns a plot of the parameter posterior values against the continuous variable used in the model. It will return an error if there are no factor variables in the model run. Currently only supports 1 continuous variable
#' 
#' The summaries can often contain large numbers of parameters so users might find it helpful to use the `search_par` option to reduce the parameters down to global parameters only (use `search_par = "p.global")`) or factor variables (use `search_par = "p.fac")`). A good general choice is `search_par = "p."` which will return all the dietary proportions in the model
#' The function returns (invisibly) the tables and the ggplots so these can be extended using standard ggplot commands
#' @export
#'
#' @examples
#' \dontrun{
#' A simple version that should work with almost any model
#' output_JAGS(jags.1, mix = mix, source = source,
#'             output_options = c('summary_diagnostics',
#'               'summary_statistics',
#'               'summary_quantiles',
#'               'plot_global'),
#'             search_par = "p.")
#' }
output_JAGS <- function(jags.1,
                        mix,
                        source,
                        output_options = c(
                          "summary_diagnostics",
                          "summary_statistics",
                          "summary_quantiles",
                          "plot_global",
                          "plot_global_matrix",
                          "plot_factors",
                          "plot_cont"
                        ),
                        search_par = NULL) {
  output_options <- match.arg(output_options, several.ok = TRUE)

  # Extract the MCMC output
  mcmc_out_matrix <- jags.1$BUGSoutput$sims.matrix
  mcmc_out_list <- jags.1$BUGSoutput$sims.list
  source_names <- source$source_names

  # Narrow down the matrices if the search term is included
  # Note search_par only used for means/quantiles
  if (!is.null(search_par)) {
    choose_columns <- grep(search_par, colnames(mcmc_out_matrix))
    mcmc_out_matrix <- jags.1$BUGSoutput$sims.matrix[, choose_columns]
  }

  # Create a holder for the output
  out <- vector("list", length = length(output_options))
  names(out) <- output_options

  if ("summary_diagnostics" %in% output_options) {
    out$summary_diagnostics <- jags.1$BUGSoutput$summary[, "Rhat"]
    cat("Worst 10 R-hat values - these values should all be close to 1.\n")
    cat("If not, try a longer run of MixSIAR.\n")
    o <- order(out$summary_diagnostics, decreasing = TRUE)[1:10]
    print(round(out$summary_diagnostics[o], 2))
  }
  if ("summary_statistics" %in% output_options) {
    out$summary_statistics <- t(apply(mcmc_out_matrix, 2, function(x) {
      return(c(mean = mean(x), sd = stats::sd(x)))
    }))
    print(out$summary_statistics)
  }
  if ("summary_quantiles" %in% output_options) {
    out$summary_quantiles <- t(apply(mcmc_out_matrix, 2, "quantile",
      probs = c(0.025, 0.25, 0.5, 0.75, 0.975)
    ))
    print(out$summary_quantiles)
  }
  if ("plot_global" %in% output_options) {
    post_global <- mcmc_out_list$p.global
    colnames(post_global) <- source_names
    out$plot_global <- post_global |>
      as.data.frame() |>
      pivot_longer(
        names_to = "Source",
        values_to = "Proportion",
        cols = everything()
      ) |>
      ggplot(aes(x = Proportion, fill = Source)) +
      geom_histogram(aes(y = after_stat(density)), bins = 30) +
      facet_wrap(~Source) +
      theme(legend.position = "None")
    print(out$plot_global)
  }
  if ("plot_global_matrix" %in% output_options) {
    post_global <- mcmc_out_list$p.global
    colnames(post_global) <- source_names
    modified_bar <- function(data, mapping, ...) {
      GGally::ggally_barDiag(data, mapping, ..., binwidth = 0.025) + coord_cartesian(xlim = c(0, 1)) + theme_bw()
    }
    modified_density <- function(data, mapping, ...) {
      ggplot(data = data, mapping = mapping, ...) +
        stat_density_2d(
          geom = "polygon", contour = TRUE,
          aes(fill = after_stat(..level..)), colour = "black",
          bins = 5
        ) +
        scale_fill_distiller(palette = "Blues", direction = 1) +
        theme_bw() +
        scale_x_continuous(limits = c(0, 1)) +
        scale_y_continuous(limits = c(0, 1))
    }
    out$plot_global_matrix <- post_global |>
      as.data.frame() |>
      GGally::ggpairs(
        upper = list(continuous = GGally::wrap(modified_density)),
        diag = list(continuous = GGally::wrap(modified_bar)),
        lower = list(continuous = GGally::wrap("cor", stars = FALSE))
      )

    print(out$plot_global)
  }
  if ("plot_factors" %in% output_options) {
    n_factors <- mix$n.effects
    if (n_factors == 0) stop("No factor variables in this MixSIAR model.
                            Re-run with 'plot_factors' removed from output_options")
    out$plot_factors <- vector("list", length = n_factors)
    fac_locations <- grep("p.fac", names(mcmc_out_list))
    for (i in 1:n_factors) {
      post_curr_factor <- mcmc_out_list[[fac_locations[i]]]
      factor_name <- mix$FAC[[i]]$name
      factor_levels <- mix$FAC[[i]]$labels
      dimnames(post_curr_factor) <- list(
        paste0(
          "Iteration",
          1:jags.1$BUGSoutput$n.sims
        ),
        factor_levels,
        source_names
      )
      curr_df <- as.data.frame(ftable(post_curr_factor))
      names(curr_df) <- c("Iteration", "Factor", "Source", "Proportion")
      out$plot_factors[[i]] <- ggplot(curr_df, aes(x = Proportion, fill = Source)) +
        geom_histogram(aes(y = after_stat(density)), bins = 30) +
        facet_grid(Factor ~ Source) +
        theme(legend.position = "None")
      print(out$plot_factors[[i]])
    }
  }
  if ("plot_cont" %in% output_options) {
    n_cont <- mix$n.ce
    if (n_cont == 0) stop("No continuous variables in this MixSIAR model.
                            Re-run with 'plot_cont' removed from output_options")
    if (n_cont > 1) stop("This function currently does not support plotting of
                        multiple continuous variables")
    cont_vals <- mix$CE_orig
    post_cont <- mcmc_out_list$p.ind
    cont_name <- mix$cont_effects
    dimnames(post_cont) <- list(
      paste0("Iteration", 1:jags.1$BUGSoutput$n.sims),
      cont_vals[[1]],
      source_names
    )
    curr_df <- as.data.frame(ftable(post_cont))
    colnames(curr_df) <- c("Iteration", "Cont_var", "Source", "Proportion")
    out$plot_cont <-
      curr_df |>
      group_by(Source, Cont_var) |>
      summarise(
        y_min = quantile(Proportion, 0.025),
        y_max = quantile(Proportion, 0.975),
        y_med = quantile(Proportion, 0.5)
      ) |>
      mutate(Cont_var2 = as.numeric(levels(Cont_var))[Cont_var]) |>
      ungroup() |>
      ggplot(aes(
        x = Cont_var2,
        y = y_med,
        colour = Source
      )) +
      geom_line() +
      geom_ribbon(aes(ymin = y_min, ymax = y_max, fill = Source), colour = NA, alpha = 0.2) +
      labs(
        y = "Proportion",
        x = mix$cont_effects
      )
    print(out$plot_cont)
  }

  invisible(out)
}
