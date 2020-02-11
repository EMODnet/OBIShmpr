#' Title
#'
#' @param t_matched_dat
#'
#' @return
#' @export
#'
#' @examples
t_summary <- function(t_matched_dat) {
  # Function to get a range of temperature summary stats from a matched obis-IAP-bio-oracle data frame
  counts <- summarise(t_matched_dat, n_obis_rec = n())
  missings <- miss_var_summary(dplyr::select(
    t_matched_dat, iap_t:iap_sbt, bo_sst:bo_sbt
  ))
  missings_df <- t(missings[, "n_miss"])
  colnames(missings_df) <- paste0(pull(missings, variable), "_NA")
  missings_df <- as_tibble(missings_df)
  # define separate functions for 5% and 95% quantiles
  q5 <- function(x, na.rm = TRUE) {
    stats::quantile(x, 0.05, na.rm = TRUE)
  }
  q95 <- function(x, na.rm = TRUE) {
    stats::quantile(x, 0.95, na.rm = TRUE)
  }

  # get a range of summary stats over all variables in the dataset
  t_stats <- summarise_at(t_matched_dat,
    vars(iap_t:iap_sbt, bo_sst:bo_sbt),
    tibble::lst(mean, min, max, median, sd, mad, q5, q95),
    na.rm = TRUE
  )

  # Tidy up and return the species-level summary
  t_summ <- bind_cols(counts, missings_df, t_stats)

  t_summ
}
