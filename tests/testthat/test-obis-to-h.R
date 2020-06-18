layers <- c("BO_bathymean", "BO2_phosphateltmax_bdmean", 
           "BO2_salinitymin_ss", "rock50cm", "april", 
           "march")

test_that("simple raster match works", {
    test_names <- c(layers,
                    "minimumDepthInMeters", "maximumDepthInMeters", "depth",
                    "eventDate", "year", "month",
                    "scientificName", "aphiaID", "id", "depth0", "geometry")
    
    test_match <-  obis_match_habitat(sp_id = 325567, 
                                      layers)
    
    expect_setequal(names(test_match), test_names)
    expect_s3_class(test_match, class = c("sf", "tbl_df", "tbl", "data.frame"))
})

test_that("simple raster mismatch handled", {
   
    expect_error(obis_match_habitat(sp_id = 325567, 
                                      layers,
                                      geometry = bbox_msdf_mpa))
    expect_warning(obis_match_habitat(sp_id = 325567, 
                                    layers,
                                    geometry = bbox_msdf_mpa,
                                    ignore_failures = TRUE))
})

