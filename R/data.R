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
#' @importFrom raster raster
"sedm_rst"

#' sedmaps raster stack variable names.
#' 
#' @format A list of variable names 
#' \describe{
#'   \item{sed}{sediment characteristics layers}
#'   \item{dis}{monthly sedimentary distrurbance layers}
#'   }
"sedm_layers"

#' MSDF MPA assessment area boundary box.
#' 
#' The spatial extent of the MPA assessment areas was defined 
#' as the marine waters surrounding the EU countries whose outer limit is defined 
#' by the 200 NM boundary from the coast (possibly coinciding with formally 
#' recognised EEZ boundaries) or the equidistance (in cases of opposite neighbouring 
#' EU countries), or by the presence of a boundary defined by an agreed treaty. 
#' However, since no formal boundary of this map exists and since this limit 
#' coincides with the boundary of the maritime area (water column) submitted by 
#' EU Member States under MSFD Articles 8, 9 and 10 in the Eionet Central 
#' Data Repository (CDR) ), the decision was taken to use the MSFD Region/Subregion 
#' boundary shapefile assembled in 2013 by ETC/ICM (ETC/ICM, 2013), 
#' based on EU Member States reported data integrated with information from the 
#' Flanders Marine Institute (VLIZ) Maritime Boundaries (version 7) to 
#' delimit the MPA assessment areas
#' @source https://www.eea.europa.eu/data-and-maps/data/europe-seas/mpa-assessment-areas
#' @format sf of MSDF MPA assessment area boundary box.
"bbox_msdf_mpa"


#' North-west European Shelf boundary box.
#' 
#' @source https://doi.org/10.5194/essd-10-109-2018
#' @format sf of North-west European Shelf boundary box.
"bbox_nwes"