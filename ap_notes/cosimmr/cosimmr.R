## ----eval = FALSE-------------------------------------------------------------
#  install.packages("cosimmr")

## ----eval = FALSE-------------------------------------------------------------
library(cosimmr)

## -----------------------------------------------------------------------------
data(geese_data_day1)

## -----------------------------------------------------------------------------
cosimmr_1 <- with(
  geese_data_day1,
  cosimmr_load(
    formula = mixtures ~ 1,
    source_names = source_names,
    source_means = source_means,
    source_sds = source_sds,
    correction_means = correction_means,
    correction_sds = correction_sds,
    concentration_means = concentration_means
  )
)

## -----------------------------------------------------------------------------
plot(cosimmr_1)

## -----------------------------------------------------------------------------
cosimmr_1_out = cosimmr_ffvb(cosimmr_1)

## -----------------------------------------------------------------------------
summary(cosimmr_1_out, type = "statistics")

## -----------------------------------------------------------------------------
plot(cosimmr_1_out, type ="prop_histogram", ind = 7)

## -----------------------------------------------------------------------------
data(geese_data)
Groups = matrix(geese_data$groups)

cosimmr_2 <-cosimmr_load(
    formula = geese_data$mixtures ~ as.factor(Groups) -1,
    source_names = geese_data$source_names,
    source_means = geese_data$source_means,
    source_sds = geese_data$source_sds,
    correction_means = geese_data$correction_means,
    correction_sds = geese_data$correction_sds,
    concentration_means = geese_data$concentration_means)

cosimmr_2_out = cosimmr_ffvb(cosimmr_2)

## -----------------------------------------------------------------------------
summary(cosimmr_2_out, type = "statistics")

## -----------------------------------------------------------------------------
pred_matrix = data.frame(Groups = c("Period 1", "Period 3"))
groups_predict = predict(cosimmr_2_out, x_pred = pred_matrix)

## -----------------------------------------------------------------------------
plot(cosimmr_2_out)

## -----------------------------------------------------------------------------
data("alligator_data")

## -----------------------------------------------------------------------------

cosimmr_ali <- with(alligator_data, cosimmr_load(
  formula = as.matrix(mixtures) ~ length,
  source_names = source_names,
  source_means = as.matrix(source_means),
  source_sds = as.matrix(source_sds),
  correction_means = as.matrix(TEF_means),
  correction_sds = as.matrix(TEF_sds)))

## -----------------------------------------------------------------------------
plot(cosimmr_ali)

# Or...
plot(cosimmr_ali, colour_by_cov = TRUE, cov_name = "length")

## -----------------------------------------------------------------------------
cosimmr_ali_out = cosimmr_ffvb(cosimmr_ali)

## -----------------------------------------------------------------------------
summary(cosimmr_ali_out, type = "statistics")

## -----------------------------------------------------------------------------
plot(cosimmr_ali_out, type = c("p_ind", "beta_histogram"), binwidth = 0.01, ind = c(1,2))

## -----------------------------------------------------------------------------
x_pred = data.frame(length = c(100,210,302))
alli_pred = predict(cosimmr_ali_out, x_pred)

## -----------------------------------------------------------------------------
summary(alli_pred, ind = c(1,2,3), type = "statistics")

plot(alli_pred, type = "beta_boxplot")

