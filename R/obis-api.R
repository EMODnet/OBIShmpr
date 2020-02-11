#' Title
#'
#' @param species_id 
#' @param missing_check 
#' @param fields 
#'
#' @return
#' @export
#'
#' @examples
get_obis_recs <- function(species_id, missing_check = FALSE,
                          fields = c("decimalLongitude", "decimalLatitude",
                                     "minimumDepthInMeters", "maximumDepthInMeters", "depth",
                                     "eventDate", "year", "month",
                                     "scientificName", "aphiaID")
){
    # Fuction to get OBIS records for a given species_id, which must be a recognised WoRMS Aphia ID
    
    # NB OBIS returns records from all taxa gathered under the same valid Aphia ID; the aphia ID returned is that of the taxon as recorded, not necessarily the valid ID, so in order that the final dataset is correctly named we add back in the 'correct' ID here as valid_AphiaID
    
    if(missing_check == TRUE){
        # catch invalid / unrecognised AphiaIDs here - but recommend doing this prior to calling these functions
        if(length(checklist(taxonid = species_id)) > 1){
            # get OBIS records for a given species ID, add year and month, set negative and missing depth to 0
            obis_recs <- robis::occurrence(
                taxonid = species_id, fields = fields) %>%
                as_tibble()
            if(!"year" %in% names(obis_recs)){
                obis_recs <- obis_recs %>% 
                    mutate(year = "NA")}
            if(!"month" %in% names(obis_recs)){
                obis_recs <- obis_recs %>% 
                    mutate(month = NA)}
            obis_recs <- mutate(obis_recs,
                                depth = as.numeric(depth),
                                year = formatC(year),
                                month = formatC(as.numeric(month), width = 2, flag = "0"),
                                depth0 = case_when(
                                    is.na(depth) ~ 0,
                                    depth < 0 ~ 0,
                                    TRUE ~ depth),
                                valid_AphiaID = species_id)
        } else {
            # at present just returns an empty tibble, which causes problems with other functions further down the pipeline, hence recommend checking AphiaIDs prior to calling
            obis_recs <- tibble()
        }
    } else {
        obis_recs <- robis::occurrence(
            taxonid = species_id, fields = fields) %>%
            as_tibble()
        if(!"year" %in% names(obis_recs)){
            obis_recs <- obis_recs %>% 
                mutate(year = "NA")}
        if(!"month" %in% names(obis_recs)){
            obis_recs <- obis_recs %>% 
                mutate(month = NA)}
        obis_recs <- mutate(
            obis_recs,
            depth = as.numeric(depth),
            year = formatC(year),
            month = formatC(as.numeric(month), width = 2, flag = "0"),
            depth0 = case_when(is.na(depth) ~ 0,
                               depth < 0 ~ 0,
                               TRUE ~ depth),
            valid_AphiaID = species_id
        )
    }
    # return the OBIS records
    obis_recs
}