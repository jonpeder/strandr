#' Returns strand-codes
#'
#' Adds strand-codes to an input table of coordinates. The strand-codes are obtained by identifying the intesects beween the input coordinates and a polygon dataset of the Norwegian municipality borders (Anno 2012)
#' @param z (dataframe) A table containing coordinates. Georeference system must be longlat WGS84/Euref89. Longitudes and latitudes must be organized in separate rows. Whether there are additional rows of data in the dataset makes no difference.
#' @param long The specific row in the input table containing longitudes
#' @param lat The specific row in the input table containing latitudes
#' @return Returns the input dataframe with strand-codes added to it
#' @examples ex_in <- data.frame("COL_ID" = c("JPL0051", "JPL0052"), "Longitude" =
#' @examples          c(24.840064, 23.186622), "Latitude" = c(69.57696, 70.44070))
#' @examples ex_out <- Strandkoder(ex_in, long = ex_in$Longitude, lat = ex_in$Latitude)
#' @import sp
#' @import maptools
#' @import rgdal
#' @export
Strandkoder <- function(z, long, lat) {

  # Import coordinates dataset
  koordx <- data.frame(long, lat)
  # Convert dataset from Dataframe to SpatialPoints class, with correct CRS
  koordx_pts <- SpatialPoints(koordx, CRS("+init=epsg:4258"))

  # Import Strand-codes/municipality-codes table
  strandx <- strand
  strandx$nummer <- as.character(strandx$nummer) # Change class from integer to character

  # Import municipality polygon data in geojson format
  kommuner_sp <- kommuner
  kommuner_sp$Kommunenum <- as.character(kommuner_sp$Kommunenum) # Change class from integer to character
  kommuner_sp_longlat <- spTransform(kommuner_sp, CRS("+init=epsg:4258")) # Reproject the data into Longlat coordinate reference system

  # Identify municipalities intersecting with input coordinates
  intersectx <- NULL
  intersectx <- as.data.frame(kommuner_sp_longlat[koordx_pts[1], ])
  for (i in 1:length(koordx_pts)){
    intersectx[i,] <- as.data.frame(kommuner_sp_longlat[koordx_pts[i], ])
  }

  # Add municipality-codes and 'empty' strand-codes to the input dataset
  z$Strand_kode <- ""
  z$Kommune_2018 <- ""

  # Identify strand-codes matching kommunenummer in the dataset
  index <- match(strandx$nummer, intersectx$Kommunenum)

  # Add strand-codes to the dataset
  for (i in 1:nrow(strandx)) {
    if (!is.na(index[i])) {
      z$Strand_kode[index[i]]  <- as.character(strandx$Strand_kode[i])
      z$Kommune_2018[index[i]]  <- as.character(strandx$Gammel_kommune[i])
    } else {
      next
    }
  }
  return(z)
}
