
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OBIShmpr

<!-- badges: start -->

<!-- badges: end -->

The goal of OBIShmpr is to link and query OBIS occurence data with a
variety of marine habitat
    data.

### Data Sources

  - #### [**Bio-ORACLE**](https://www.bio-oracle.org/) & [**MARSPEC**](http://www.marspec.org/) data accesed through `sdmpredictors`:
    
    a set of GIS rasters providing geophysical, biotic and environmental
    data for surface and benthic marine realms. Accessed via
    [`sdmpredictors`](https://github.com/lifewatch/sdmpredictors)

  - #### `sedmaps` [Synthetic map of the NW European Shelf sedimentary environment](https://www.earth-syst-sci-data.net/10/109/2018/essd-10-109-2018.pdf)
    
    **data product**
    [10.15129/1e27b806-1eae-494d-83b5-a5f4792c46fc](https://pureportal.strath.ac.uk/en/datasets/data-for-a-synthetic-map-of-the-northwest-european-shelf-sediment)
    0.125◦ by 0.125◦ resolution synthetic maps of continuous properties
    of the north-west European sedimentary environment. The maps are a
    blend of gridded survey data, statistically modelled values based on
    distributions of bed shear stress due to tidal currents and waves
    and bathymetric properties.
    
      - percentage compositions of mud, sand and gravel;
      - porosity and permeability;
      - median grain size of the whole sediment and of the sand and the
        gravel fractions;
      - carbon and nitrogen content of sediments;
      - percentage of seabed area covered by rock;
      - mean and maximum depth-averaged tidal velocity and wave orbital
        velocity at the seabed; and mean monthly natural disturbance
        rates.

  - #### [EMODnet Seabed Habitat maps]()

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("annakrystalli/OBIShmpr")
```

## Example

### Get habitat data for a species

``` r
library(OBIShmpr)
```

## An example with one species

This is an example of how to run the above code for a single species -
we use *Scytothamnus fasciculatus*, Aphia ID 325567, chosen as it has
just 6 OBIS records so should run reasonably quickly.

Choose some layers to extract data from

``` r
sp_id <- 325567
layers <- c("BO2_nitratemax_bdmin", "BO_parmax", "BO2_tempmax_bdmax", "permeability", 
"tidal_vel_max", "april")
```

``` r
obis_match_habitat(sp_id, layers = layers)
#> ✔ `obis_recs` successfully converted to sf
#> ✔ `obis_recs` crs: 4326, +proj=longlat +datum=WGS84 +no_defs
#> ✔ `obis_recs` crs: 4326, +proj=longlat +datum=WGS84 +no_defs
#> Simple feature collection with 6 features and 16 fields
#> geometry type:  POINT
#> dimension:      XY
#> bbox:           xmin: -65 ymin: -48.65 xmax: 173.7005 ymax: -40.7
#> epsg (SRID):    4326
#> proj4string:    +proj=longlat +datum=WGS84 +no_defs
#> # A tibble: 6 x 17
#>   scientificName aphiaID maximumDepthInM… id    minimumDepthInM… eventDate depth
#>   <chr>            <int> <lgl>            <chr> <lgl>            <chr>     <dbl>
#> 1 Scytothamnus …  325567 NA               079a… NA               <NA>         NA
#> 2 Scytothamnus …  325567 NA               45b1… NA               <NA>         NA
#> 3 Scytothamnus …  325567 NA               6761… NA               <NA>         NA
#> 4 Scytothamnus …  325567 NA               99b4… NA               <NA>         NA
#> 5 Scytothamnus …  325567 NA               cbf1… NA               <NA>         NA
#> 6 Scytothamnus …  325567 NA               dd42… NA               1945/09/…    NA
#> # … with 10 more variables: year <chr>, month <chr>, depth0 <dbl>,
#> #   geometry <POINT [°]>, BO2_nitratemax_bdmin <dbl>, BO_parmax <dbl>,
#> #   BO2_tempmax_bdmax <dbl>, permeability <lgl>, tidal_vel_max <lgl>,
#> #   april <lgl>
```

### Get species profile for habitat

## EMODnet Seabed Habitat Data

``` r
get_emodnet_wfs_layers(layers = c("be000142", "be000144"))
#> Reading layer `emodnet_be000142' from data source `/Users/Anna/Documents/workflows/EMODnet/OBIShmpr/cached-data/emodnet_be000142.geojson' using driver `GeoJSON'
#> Simple feature collection with 9 features and 18 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: 319003.6 ymin: 6666315 xmax: 373792.7 ymax: 6696825
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> Reading layer `emodnet_be000144' from data source `/Users/Anna/Documents/workflows/EMODnet/OBIShmpr/cached-data/emodnet_be000144.geojson' using driver `GeoJSON'
#> Simple feature collection with 96 features and 18 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: 255415.1 ymin: 6641535 xmax: 363513.8 ymax: 6762441
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> Simple feature collection with 105 features and 18 fields
#> geometry type:  MULTIPOLYGON
#> dimension:      XY
#> bbox:           xmin: 255415.1 ymin: 6641535 xmax: 373792.7 ymax: 6762441
#> epsg (SRID):    3857
#> proj4string:    +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs
#> # A tibble: 105 x 19
#>    gml_id    gid gui   polygon orig_hab orig_class hab_type version det_mthd
#>    <fct>   <int> <fct>   <int> <fct>    <fct>      <fct>    <fct>   <fct>   
#>  1 be000… 162334 BE00…     222 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  2 be000… 162338 BE00…     228 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  3 be000… 162337 BE00…     227 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  4 be000… 162336 BE00…     226 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  5 be000… 162341 BE00…     229 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  6 be000… 162333 BE00…     221 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  7 be000… 162335 BE00…     223 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  8 be000… 162340 BE00…     225 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#>  9 be000… 162339 BE00…     224 ME_Maco… <NA>       A5.331   EUNIS … Re-dete…
#> 10 be000… 162423 BE00…     312 ME_Neph… <NA>       A5.25_B… Propos… Re-dete…
#> # … with 95 more rows, and 10 more variables: det_name <fct>, det_date <date>,
#> #   t_relate <fct>, tran_com <fct>, val_comm <fct>, eunis_l3 <fct>, comp <fct>,
#> #   comp_type <fct>, sum_conf <int>, geometry <MULTIPOLYGON [m]>
```
