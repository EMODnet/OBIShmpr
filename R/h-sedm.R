#' Extract sedmaps data for an OBIS occurence sf
#'
#' @param obis_recs OBIS occurence sf
#' @param layers character vector of layer names to extract
#'
#' @return a tibble of extracted layer data
#' @export
get_sedm <- function(obis_recs, layers = names(sm_rst)){
    checkmate::assert_subset(layers, names(sm_rst))
    
    raster::extract(sm_rst[[layers]], obis_recs) %>% 
        tibble::as_tibble()
}