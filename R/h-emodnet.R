
#' Access EMODnet WFS layers
#'
#' @param layers character vector of EMODnet seabed habitat wfs layer names.
#' @param cache_dir path to the cached data directory. Defaults to the "cached-data' 
#' folder in the root of the current project
#' @param service name of the EMODnet WFS service.
#' @inheritParams obis_match_habitat 
#'
#' @return an sf of requested features
#' @export
#' @examples
#' \dontrun
#' proj_dir <- tempdir()
#' cache_dir <- fs::path(proj_dir, "cached-data")
#' get_emodnet_wfs_layers(layers = "be000142", 
#'                        service = "seabed_habitats_individual_habitat_map_and_model_datasets",
#'                       cache_dir = cache_dir)
get_emodnet_wfs_layers <- function(layers, service,
                               cache_dir = NULL,
                               overwrite = FALSE) {
  layers <- match.arg(layers, choices = layer_info$layer_code,
                      several.ok = TRUE)
  
  if (is.null(cache_dir)) {
    cache_dir <- "cached-data"
  }
  fs::dir_create(cache_dir)
  layer_paths <- fs::path(cache_dir, glue::glue("emodnet_{layers}.geojson"))
  
  # checker whether layers are cached. If not, download from WFS into cache_dir
  if(overwrite){
      file.check <- rep(TRUE, length(layers))
  }else{
  file.check <- !fs::file_exists(layer_paths)
  }
  if (any(file.check)) {
   
    EMODnetWFS::emodnet_get_wfs_info()  
    #  purrr::map2(
     # .x = layers[file.check], .y = layer_paths[file.check],
      #~ gdalUtils::ogr2ogr(
      #  src_datasource_name = wfs_url,
       # layer = glue::glue("emodnet_open_maplibrary:{.x}"),
      #  dst_datasource_name = .y, # the target file
      #  f = "geojson", # the target format
        # spat = c(left = 142600, bottom = 153800, right = 146000, top = 156900),
        # the bounding box
        #t_srs = glue::glue("EPSG:{crs}"),                    # the coordinate reference system
      #  verbose = TRUE,
      #  overwrite = TRUE
        #append = TRUE
     # )
   # )
      usethis::ui_done("Download of EMODnet {usethis::ui_field('layers')} {usethis::ui_value(layers)} complete")
      usethis::ui_info("{usethis::ui_field('layers')} cached in {usethis::ui_field('cache_dir')} {usethis::ui_path(cache_dir)}")
      
  }

  # Load layers
  usethis::ui_info("Reading {usethis::ui_field('layers')} from {usethis::ui_field('cache_dir')} {usethis::ui_code('cache_dir'); usethis::ui_path(cache_dir)}")
  purrr::map(
    layer_paths,
    ~ sf::st_read(.x) %>%
        tibble::as_tibble() %>%
      sf::st_as_sf()
  ) %>% do.call("rbind", .)
}

