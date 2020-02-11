
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OBIShmpr

<!-- badges: start -->

<!-- badges: end -->

The goal of OBIShmpr is to link and query OBIS occurence data with a
variety of marine habitat
data.

## Installation

<!-- You can install the released version of OBIShmpr from [CRAN](https://CRAN.R-project.org) with: 

``` r
install.packages("OBIShmpr")
```
-->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("annakrystalli/OBIShmpr")
```

## Example

### Get habitat data for a species

``` r
library(OBIShmpr)
## basic example code
```

## An example with one species

This is an example of how to run the above code for a single species -
we use *Scytothamnus fasciculatus*, Aphia ID 325567, chosen as it has
just 6 OBIS records so should run reasonably quickly.

``` r
get_temp_summ_by_sp(sp_id = 325567)
```

### Get species profile for habitat
