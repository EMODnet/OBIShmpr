#' Query OBIS for occurence data
#'
#' @param sp_id a valid WoRMS aphiaID
#' @param missing_check whether to check for validity of aphiaID on OBIS
#' @param fields fields to return from OBIS query. Defaults to `c("decimalLongitude", 
#' "decimalLatitude","minimumDepthInMeters", "maximumDepthInMeters", "depth",
#' "eventDate", "year", "month", "scientificName", "aphiaID")`
#'
#' @return a tibble of temporally and spatially located OBIS occurence records 
#' for `sp_id`.
#' @export
#'
#' @examples
#' get_obis_recs(sp_id = 325567)
get_obis_recs <- function(sp_id, missing_check = FALSE,
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

  if (missing_check == TRUE) {
    # catch invalid / unrecognised AphiaIDs here - but recommend doing this prior to calling these functions
    if (length(robis::checklist(taxonid = sp_id)) > 1) {
      # get OBIS records for a given species ID, add year and month,
      obis_recs <- robis::occurrence(
        taxonid = sp_id, fields = fields
      ) %>%
        obis_recs_process()
    } else {
      # at present just returns an empty tibble, which causes problems with other functions further down the pipeline, hence recommend checking AphiaIDs prior to calling
      obis_recs <- tibble::tibble()
    }
  } else {
    obis_recs <- robis::occurrence(
      taxonid = sp_id, fields = fields
    ) %>%
      obis_recs_process() %>%
      dplyr::mutate(valid_AphiaID = sp_id)
  }
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
  if(is.na(crs(obis_recs)) | is.null(crs(obis_recs))){
    crs <- checkmate_crs(crs)
    obis_recs %<>% sf::st_set_crs(crs)
    usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')} successfully set")
  }
  usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')}: {usethis::ui_value(sf::st_crs(obis_recs))}")
  obis_recs
}

