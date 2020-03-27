#' Title
#'
#' @param obis_recs data.frame of OBIS records
#' @param layercodes character vector of bio oracle layer names
#' @param outdir directory to cache data into
#' @param crs crs of obis records. If NULL, defaults to WSG 84
#'
#' @return
#' @export
get_sdmpredictors <- function(obis_recs, layercodes,
                             cache_dir = NULL, crs = NULL) {
  
  layercodes <- match.arg(layercodes, choices = layer_info$layer_code,
                          several.ok = TRUE)
  
  checkmate::assert_class(obis_recs, "data.frame")
  
  # Function to match a set of OBIS occurrence recrods to mean SST and SBT from Bio-ORACLE
  # Set path for where these two temperature datasets will be stored
  if(is.null(cache_dir)){
    cache_dir <- here::here("cached-data")
  }
  if(!dir.exists(cache_dir)){
    dir.create(
      path = cache_dir,
      recursive = TRUE, 
      showWarnings = FALSE
    )
    usethis::use_build_ignore("cached-data")
  }

  
  spdm_rst <- sdmpredictors::load_layers(layercodes,
                                         equalarea = FALSE, 
                                         datadir = cache_dir
  )

  # Turn the OBIS occurrence dataframe into simple feature.
  obis_recs %<>% checkmate_obis_recs(crs)
  
  
  # Extract the temperatures for each point
  spdm_h <- raster::extract(spdm_rst, obis_recs) %>%
    tibble::as_tibble()

  # add these temperatures back to the OBIS records and return
  return(dplyr::bind_cols(obis_recs, spdm_h))
}


extract_h_raster <- function(layercode, raster_stack, points){
  h_v <- raster::extract(raster_stack[[layercode]], points)
  
  NAs <- sum(is.na(h_v))
  if(NAs > 0){
    usethis::ui_oops("\n {usethis::ui_field(layercode)} extraction unsuccesfull for {NAs} occurences, {usethis::ui_code(NA)}s returned \n")
  }
  
  usethis::ui_done("{usethis::ui_field(layercode)} extraction complete \n")
  return(tibble::tibble("{layercode}" := h_v))
}
