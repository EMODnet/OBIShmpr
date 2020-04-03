


#' Access EMODnet EUNIS Seabed Habitat layers
#'
#' @param layers character vector of EMODnet seabed habitat wfs layer names.
#' @param cache_dir path to the cached data directory. Defaults to the "cached-data' 
#' folder in the root of the current project
#' @param wfs_url url to the EMODnet WFS service. Defaults to the EUNIS seabed habitat map wfs.
#'
#' @return an sf of requested features
#' @export
#'
#' @examples
#' proj_dir <- tempdir()
#' cache_dir <- fs::path(proj_dir, "cached-data")
#' get_emodnet_wfs_layers(layers = "be000142", cache_dir = cache_dir)
get_emodnet_wfs_layers <- function(layers = c(
                                 "be000142", "be000143", "be000144", "bg003005",
                                 "es000001", "es001000"
                               ),
                               cache_dir = NULL,
                               wfs_url = "https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs") {
  layers <- match.arg(layers, several.ok = TRUE)
  if (is.null(cache_dir)) {
    cache_dir <- here::here("cached-data")
  }
  fs::dir_create(cache_dir)
  layer_paths <- fs::path(cache_dir, glue::glue("emodnet_{layers}.geojson"))

  # checker whether layers are cached. If not, download from WFS into cache_dir
  file.check <- !fs::file_exists(layer_paths)

  if (any(file.check)) {
    purrr::map2(
      .x = layers[file.check], .y = layer_paths[file.check],
      ~ gdalUtils::ogr2ogr(
        src_datasource_name = wfs_url,
        layer = glue::glue("emodnet_open_maplibrary:{.x}"),
        dst_datasource_name = .y, # the target file
        f = "geojson", # the target format
        # spat = c(left = 142600, bottom = 153800, right = 146000, top = 156900),
        # the bounding box
        # t_srs = "EPSG:31370",                    # the coordinate reference system
        verbose = TRUE
      )
    )
  }

  # Load layers
  purrr::map(
    layer_paths,
    ~ sf::st_read(.x) %>%
        tibble::as_tibble() %>%
      sf::st_as_sf()
  ) %>% do.call("rbind", .)
}




#' Access EMODnet WFS info
#'
#' @inheritParams get_emodnet_wfs_layers
#'
#' @return WFS available feature information
#' @export
#'
#' @examples
#' get_emodnet_info()
get_emodnet_info <- function(wfs_url = "https://ows.emodnet-seabedhabitats.eu/emodnet_open_maplibrary/wfs") {
  wfs_url <- paste0("WFS:", wfs_url)
  info <- gdalUtils::ogrinfo(wfs_url,
    so = TRUE,
    ro = TRUE
  )

  info
}
