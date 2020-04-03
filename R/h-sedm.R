#' Extract sedmaps data for an OBIS occurence sf
#'
#' @param obis_recs OBIS occurence sf
#' @param layers character vector of layer names to extract
#'
#' @return a tibble of extracted layer data
#' @export
get_sedm <- function(obis_recs, layers){
    checkmate::assert_subset(layers, names(sedm_rst))
    
    raster::extract(sedm_rst[[layers]], obis_recs) %>% 
        tibble::as_tibble()
}