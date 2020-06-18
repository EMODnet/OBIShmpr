#' Get OBIS occurences matched to layers of evironmental data
#'
#' function to get OBIS records for a given species and match to IAP and Bio-Oracle temperatures
#' if save_all_recs == TRUE, this full matched dataset will be saved before summarising
#' function returns a summary of temperature affinity of the species
#'
#' @param sp_id validates species Aphia ID
#' @param check_match whether to check validity of `sp_id`. 
#' @param layers character vector of habitat layers to match
#' @param overwrite whether to re-download and overwrite already downloaded layers
#' @inheritParams get_obis_recs
#' @return an `sf` object, one row for each species occurence returned from obis.
#' Column include requested OBIS metadata through `fields` argument plus a column 
#' for each layer environmental layer requested containing data retuned for each
#' occurence location.
#' @importFrom rlang .env
#' @export
#'
#' @examples
#' obis_match_habitat(sp_id = 325567, layers = c("BO_bathymean", 
#'                    "BO2_phosphateltmax_bdmean", "BO2_salinitymin_ss", 
#'                    "rock50cm", "april", "march"))
obis_match_habitat <- function(sp_id, layers,
                               fields = c(
                                 "decimalLongitude", "decimalLatitude",
                                 "minimumDepthInMeters", "maximumDepthInMeters", "depth",
                                 "eventDate", "year", "month",
                                 "scientificName", "aphiaID"
                               ),
                               #save_all_recs = TRUE, 
                               check_match = FALSE,
                               validate_sp_id = FALSE, 
                               geometry = NULL, 
                               ignore_failures = FALSE,
                               overwrite = FALSE) {
  
  if (check_match == TRUE) {
    # TODO
  }

  # Get OBIS records
  obis_recs <- get_obis_recs(sp_id = sp_id,
                             validate_sp_id = validate_sp_id,
                             geometry = geometry, 
                             ignore_failures = ignore_failures) 
  if(is.null(obis_recs)){
    return(NULL)
  }else{
  obis_recs <- obis_recs %>%
    checkmate_obis_recs(crs = 4326) 
  }
  
  # split layers according to dataset_source
  layers_by_data_source <- layer_info %>%
    dplyr::filter(.data$layer_code %in% .env$layers) %>%
    split(x = .$layer_code, f = .$dataset_source) 
  
  
  extr <- NULL
  
  if("sedmaps" %in% names(layers_by_data_source)){
    extr <- dplyr::bind_cols(extr, 
                             get_sedm(obis_recs, layers_by_data_source[["sedmaps"]]))
  }
  if("sdmpredictors" %in% names(layers_by_data_source)){
    extr <- dplyr::bind_cols(extr, 
                             get_spdm(obis_recs, layers_by_data_source[["sdmpredictors"]]))
  }
  
  dplyr::bind_cols(obis_recs, extr[ , layers])
}
