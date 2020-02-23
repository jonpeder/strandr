#' Returns strand-codes
#'
#' Adds strand-codes to an input table of coordinates. The strand-codes are obtained by identifying the intesects beween the input coordinates and a polygon dataset of the Norwegian municipality borders (Anno 2012)
#' @param longlatTable (dataframe) A table containing coordinates. Georeference system must be longlat WGS84/Euref89. Longitudes and latitudes must be organized in separate rows. Whether there are additional rows of data in the dataset makes no difference.
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
Strandkoder <- function(longlatTable, long, lat) {

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

  # Cross refference municipality-codes between tables, and add municipalities and strand-codes to the input dataset
  longlatTable$Strand_kode <- ""
  longlatTable$Kommune_2018 <- ""

  # Add strand-codes to the dataset
  for (i in 1:nrow(longlatTable)) {
    temp1 <- as.vector(strandx$Strand_kode[strandx$nummer == intersectx$Kommunenum[i]])
    temp2 <- as.vector(strandx$Gammel_kommune[strandx$nummer == intersectx$Kommunenum[i]])
    longlatTable$Strand_kode[i] <- temp1
    longlatTable$Kommune_2018[i] <- temp2
  }
  return(longlatTable)
}
