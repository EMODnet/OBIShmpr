#' Query OBIS for occurence data
#'
#' @param sp_id a valid WoRMS aphiaID
#' @param validate_sp_id whether to check for validity of aphiaID on OBIS
#' @param fields fields to return from OBIS query. Defaults to `c("decimalLongitude",
#' "decimalLatitude","minimumDepthInMeters", "maximumDepthInMeters", "depth",
#' "eventDate", "year", "month", "scientificName", "aphiaID")`
#' @param geometry an sf object. Queries will be faster if the
#' geometry is simple and restricted in space.
#' @param ignore_failures whether to through an error or return
#' NULL for queries that return no obis records.
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
                          ), geometry = NULL, ignore_failures = FALSE) {
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
  geometry <- checkmate_geometry(geometry)

  obis_recs <- robis::occurrence(
    taxonid = sp_id, fields = fields,
    geometry = geometry
  ) 

  if (nrow(obis_recs) == 0 & ignore_failures) {
    usethis::ui_warn("no data returned for {usethis::ui_field('sp_id')} {usethis::ui_value(sp_id)}")
    return(NULL)
  }
  if (nrow(obis_recs) == 0 & !ignore_failures) {
    usethis::ui_stop("no data returned for {usethis::ui_field('sp_id')} {usethis::ui_value(sp_id)}")
  }
  # return the OBIS records
  obis_recs %>%
    obis_recs_process()
}

#' @importFrom rlang .data
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


checkmate_crs <- function(crs, to_crs = 4326) {
  if (checkmate::test_null(crs)) {
    crs <- to_crs
    usethis::ui_warn("{usethis::ui_field('crs')} missing. Set to default {usethis::ui_value(crs)}")
  }
  crs
}

checkmate_obis_recs <- function(obis_recs, crs = NULL) {
  if (!checkmate::test_class(obis_recs, "sf")) {
    crs <- checkmate_crs(crs)
    obis_recs %<>% sf::st_as_sf(
      coords = c("decimalLongitude", "decimalLatitude"),
      crs = crs
    )
    usethis::ui_done("{usethis::ui_code('obis_recs')} successfully converted to {usethis::ui_field('sf')}")
  }
  if (is.na(sf::st_crs(obis_recs)) | is.null(sf::st_crs(obis_recs))) {
    crs <- checkmate_crs(crs)
    obis_recs %<>% sf::st_set_crs(crs)
    usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')} successfully set")
  }
  usethis::ui_done("{usethis::ui_code('obis_recs')} {usethis::ui_field('crs')}: {usethis::ui_value(sf::st_crs(obis_recs))}")
  obis_recs
}

checkmate_aphiaid <- function(sp_id) {
  wm_record <- worrms::wm_record(c(1, sp_id)) %>%
    dplyr::slice(-1)

  if (any(is.na(wm_record$AphiaID))) {
    usethis::ui_oops("{usethis::ui_field('sp_id')} {usethis::ui_value(sp_id[is.na(wm_record$AphiaID)])} do not match any WoRMS records. Ignored")
  }

  valid_wm_records <- wm_record[!is.na(wm_record$AphiaID), ]

  id_diffs <- as.integer(valid_wm_records$AphiaID[valid_wm_records$AphiaID != valid_wm_records$valid_AphiaID])
  if (length(id_diffs) > 0) {
    usethis::ui_warn("{usethis::ui_field('sp_id')} {usethis::ui_value(id_diffs)} not valid AphiaID. valid IDs used instead")
  }
  as.integer(valid_wm_records$valid_AphiaID)
}


checkmate_geometry <- function(geometry) {
  if (is.null(geometry)) {
    geometry
  } else {
    checkmate::assert_class(
      geometry,
      c("sfc_POLYGON", "sfc")
    )
    sf::st_transform(geometry, crs = 4326) %>%
      sf::st_as_text()
  }
}
