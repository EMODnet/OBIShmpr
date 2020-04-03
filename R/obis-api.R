#' Query OBIS for occurence data
#'
#' @param sp_id a valid WoRMS aphiaID
#' @param validate_sp_id whether to check for validity of aphiaID on OBIS
#' @param fields fields to return from OBIS query. Defaults to `c("decimalLongitude", 
#' "decimalLatitude","minimumDepthInMeters", "maximumDepthInMeters", "depth",
#' "eventDate", "year", "month", "scientificName", "aphiaID")`
#'
#' @return a tibble of OBIS occurence records
#' for `sp_id`.
#' @export
#'
#' @examples
#' get_obis_recs(sp_id = 325567)
get_obis_recs <- function(sp_id, validate_sp_id = FALSE,
                          fields = c(
                            "decimalLongitude", "decimalLatitude",
                            "minimumDepthInMeters", "maximumDepthInMeters", "depth",
                            "eventDate", "year", "month",
                            "scientificName", "aphiaID"
                          ), trim = NULL) {
  # Fuction to get OBIS records for a given sp_id, which must be a recognised WoRMS Aphia ID

  # NB OBIS returns records from all taxa gathered under the same valid Aphia ID; the aphia ID returned is that of the taxon as recorded, not necessarily the valid ID, so in order that the final dataset is correctly named we add back in the 'correct' ID here as valid_AphiaID

  fields <- match.arg(fields, c(
    "decimalLongitude", "decimalLatitude",
    "minimumDepthInMeters", "maximumDepthInMeters", "depth",
    "eventDate", "year", "month",
    "scientificName", "aphiaID"
  ), several.ok = TRUE)

  if (validate_sp_id) {
    # catch invalid / unrecognised AphiaIDs here - but recommend doing this prior to calling these functions
  sp_id <- checkmate_aphiaid(sp_id)
  }

    obis_recs <- robis::occurrence(
      taxonid = sp_id, fields = fields
    ) %>%
      obis_recs_process() 

  # return the OBIS records
  obis_recs
}



obis_recs_process <- function(obis_recs) {
  obis_recs <- tibble::as_tibble(obis_recs)

  if (!"year" %in% names(obis_recs)) {
    obis_recs <- obis_recs %>%
      dplyr::mutate(year = "NA")
  }
  if (!"month" %in% names(obis_recs)) {
    obis_recs <- obis_recs %>%
      dplyr::mutate(month = NA)
  }

  dplyr::mutate(
    obis_recs,
    depth = as.numeric(.data$depth),
    year = formatC(.data$year),
    month = formatC(as.numeric(.data$month), width = 2, flag = "0"),
    # set negative and missing depth to 0
    depth0 = dplyr::case_when(
      is.na(.data$depth) ~ 0,
      .data$depth < 0 ~ 0,
      TRUE ~ .data$depth
    )
  )
}


checkmate_crs <- function(crs){
  if(checkmate::test_null(crs)){
    crs <- 4326
    usethis::ui_warn("{usethis::ui_field('crs')} missing. Set to default {usethis::ui_value(crs)}")
  }
  crs
}

#' @export
checkmate_obis_recs <- function(obis_recs, crs = NULL){
  if(!checkmate::test_class(obis_recs, "sf")){
    crs <- checkmate_crs(crs)
    obis_recs %<>% sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
                                crs = crs)
    usethis::ui_done("{usethis::ui_code('obis_recs')} successfully converted to {usethis::ui_field('sf')}")
  }
  if(is.na(sf::st_crs(obis_recs)) | is.null(sf::st_crs(obis_recs))){
    crs <- checkmate_crs(crs)
    obis_recs %<>% sf::st_set_crs(crs)
    usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')} successfully set")
  }
  usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')}: {usethis::ui_value(sf::st_crs(obis_recs))}")
  obis_recs
}

checkmate_aphiaid <- function(sp_id){
  wm_record <- worrms::wm_record(c(1, sp_id)) %>%
    dplyr::slice(-1)
  
  if(any(is.na(wm_record$AphiaID))){
    usethis::ui_oops("{usethis::ui_field('sp_id')} {usethis::ui_value(sp_id[is.na(wm_record$AphiaID)])} do not match any WoRMS records. Ignored")
  }
  
  valid_wm_records <- wm_record[!is.na(wm_record$AphiaID), ]
  
  id_diffs <- as.integer(valid_wm_records$AphiaID[valid_wm_records$AphiaID != valid_wm_records$valid_AphiaID])
  if(length(id_diffs) > 0){
    usethis::ui_warn("{usethis::ui_field('sp_id')} {usethis::ui_value(id_diffs)} not valid AphiaID. valid IDs used instead")
  }
  as.integer(valid_wm_records$valid_AphiaID)
}
