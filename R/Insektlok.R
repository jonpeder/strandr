#' Returns strand-codes and insect locality data
#'
#' Adds locality names and strand-codes to an input table of coordinates.
#' @param z (dataframe) A table containing coordinates. Georeference system must be longlat WGS84/Euref89. Longitudes and latitudes must be organized in separate rows. Whether there are additional rows of data in the dataset makes no difference.
#' @param long The specific row in the input table containing longitudes
#' @param lat The specific row in the input table containing latitudes
#' @return Returns the input dataframe with locality names and strand-codes added to it
#' @examples ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" =
#' @examples          c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
#' @examples ex_out <- Insektlok(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
#' @import XML
#' @import RCurl
#' @import sp
#' @import maptools
#' @import rgdal
#' @export
Insektlok <- function(z, long, lat) {

  # Add Strand-localities to the dataset
  z <- Strandkoder(z, long, lat)

  # Add locality names to the dataset
  z <- Stedsnavn(z, long, lat)

  return(z)
}
