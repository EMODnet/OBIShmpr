#' North-west European Shelf sedimentary environment.
#'
#' A dataset from Wilson, R. J., Speirs, D. C., Sabatino, A., and Heath, M. R.: 
#' ***A synthetic map of the north-west European Shelf sedimentary environment 
#' for applications in marine science***, Earth Syst. Sci. Data, 10, 109-130, 2018
#' 
#' 0.125° by 0.125° resolution synthetic maps of continuous properties of the north-west 
#' European sedimentary environment, extending from the Bay of Biscay to the northern limits 
#' of the North Sea and the Faroe Islands. 
#' 
#' The maps are a blend of gridded survey data, statistically modelled values based on 
#' distributions of bed shear stress due to tidal currents and waves, and bathymetric 
#' properties.
#' 
#' @format A raster stack with variable layers 
#' \describe{
#'   \item{var1}{percentage compositions of mud, sand and gravel}
#'   \item{var1}{median grain size of the whole sediment}
#'   \item{var1}{median grain size of the sand fractions}
#'   \item{var1}{median grain size of the gravel fractions}
#'   \item{var1}{carbon content of sediments}
#'   \item{var1}{nitrogen content of sediments}
#'   \item{var1}{percentage of seabed area covered by rock}
#'   \item{var1}{mean depth-averaged tidal velocity and wave orbital velocity at the seabed}
#'   \item{var1}{mean depth-averaged wave orbital velocity at the seabed}
#'   \item{var1}{maximum depth-averaged tidal velocity at the seabed}
#'   \item{var1}{maximum depth-averaged wave orbital velocity at the seabed}
#'   \item{jan-dec}{mean monthly natural disturbance rates (12 layers)}
#'   ...
#' }
#' @source \url{https://doi.org/10.5194/essd-10-109-2018}
"sm_rst"

#' sedmaps raster stack variable names.
#' 
#' @format A list of variable names 
#' \describe{
#'   \item{sed}{sediment characteristics layers}
#'   \item{dis}{monthly sedimentary distrurbance layers}
#'   }
"sm_layers"